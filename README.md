sthlmhaskell cloud haskell chat
===============================

for ghc base < 5, download from hackage:
cabal update
cabal install cabal-install
cabal install distributed-process
cabal install distributed-process-simplelocalnet

for ghc base >= 5, download from:
http://haskell-distributed.github.io

To set up a chat server and three clients with the cabal sandbox
   (after cabal build):

dist/build/the-chat/the-chat server 127.0.0.1 10001
dist/build/the-chat/the-chat client 127.0.0.1 10002
dist/build/the-chat/the-chat client 127.0.0.1 10003
dist/build/the-chat/the-chat client 127.0.0.1 10004
