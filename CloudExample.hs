{-# LANGUAGE DeriveDataTypeable #-}

import Data.Typeable
import Data.Binary

import Control.Monad
import Control.Distributed.Process
import Control.Distributed.Process.Node

import Network.Transport.TCP

data SenderPacket = SenderPacket String ProcessId
   deriving (Typeable,Show)

instance Binary SenderPacket where
   put (SenderPacket s i) = put (0::Word8) >> put s >> put i
   get                    = do _ <- getWord8 -- stripping 0
                               liftM2 SenderPacket get get

main :: IO ()
main = do
   transportToEval <- createTransport "127.0.0.1" "11001" defaultTCPParameters
   case transportToEval of
      (Right a) -> do
         env   <- newLocalNode a initRemoteTable
         procA <- forkProcess env
            (do liftIO $ putStrLn "procA: Wait for message."
                (SenderPacket str id) <- expect :: Process SenderPacket
                send id "gotcha!"
                liftIO.putStrLn $ str
            )
         procB <- forkProcess env
            (do pickOut <- getSelfPid
                send procA (SenderPacket "hello!" pickOut)
                receivedMsg <- expect :: Process String
                liftIO.putStrLn $ "got:" ++ receivedMsg
            )
         closeLocalNode env

      (Left a)  -> putStrLn $ "Fail: " ++ show a
