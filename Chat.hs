{-# LANGUAGE TemplateHaskell #-}
{-# LANGUAGE DeriveDataTypeable #-}

import System.Environment (getArgs)
import Control.Monad
import Control.Distributed.Process
import Control.Distributed.Process.Closure
import Control.Distributed.Process.Backend.SimpleLocalnet
import Control.Distributed.Process.Node
          (initRemoteTable,runProcess,forkProcess)

import Data.Typeable
import Data.Binary

data ChatData = MasterInfo ProcessId | ChatMessage String
   deriving (Typeable,Show)

instance Binary ChatData where
   put (MasterInfo  p) = put (0::Word8) >> put p
   put (ChatMessage s) = put (1::Word8) >> put s
   get                 = do val <- getWord8
                            case val of
                               0 -> liftM MasterInfo  get
                               1 -> liftM ChatMessage get

masterLoop :: Backend -> [NodeId] -> Process ()
masterLoop b _ = forever $
   do slaves <- findSlaves b
      pid    <- getSelfPid
      -- Frequently send master pid to possibly new clients
      forM_ slaves (\x -> send x (MasterInfo pid))
      -- Listen for messages, forward each message to all clients
      msg <- expectTimeout 10 :: Process (Maybe ChatData)
      case msg of
         Nothing  -> return ()
         Just msg -> do forM_ slaves (\c -> send c msg)
                        liftIO $ putStrLn (show msg)

startCustomSlave :: Backend -> Process () -> IO ()
startCustomSlave backend func = do
   node <- newLocalNode backend
   runProcess node func

slaveLoop :: Process ()
slaveLoop = do
   pid <- getSelfPid
   register "slaveController" pid
   m <- expect :: Process ChatData
   case m of
      (MasterInfo p) -> do
         liftIO . putStrLn $ "Master pid: " ++ show p
         -- Spawn a local process that listens for input
         spawnLocal (sendMsg p)
         -- Listen for messages
         forever (do msg <- expect :: Process ChatData
                     case msg of
                        (ChatMessage s) ->
                           liftIO $ putStrLn s
                        _ -> return ()
                 )
      _ -> do liftIO $ putStrLn "error: could not find server"

sendMsg :: ProcessId -> Process ()
sendMsg pid = forever $ do fromUser <- (liftIO getLine)
                           send pid (ChatMessage fromUser)

main :: IO ()
main = do
   args <- getArgs
   case args of
      ["server", host, port] -> do
         backend <- initializeBackend host port initRemoteTable
         startMaster backend (masterLoop backend)
      ["client", host, port] -> do
         backend <- initializeBackend host port initRemoteTable
         startCustomSlave backend slaveLoop
