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

base < 5:
runhaskell Chat.hs server 127.0.0.1 10001
runhaskell Chat.hs client 127.0.0.1 10002
runhaskell Chat.hs client 127.0.0.1 10003
runhaskell Chat.hs client 127.0.0.1 10004

base >= 5:
dist/build/the-chat/the-chat server 127.0.0.1 10001
dist/build/the-chat/the-chat client 127.0.0.1 10002
dist/build/the-chat/the-chat client 127.0.0.1 10003
dist/build/the-chat/the-chat client 127.0.0.1 10004

relevant papers:
A unified semantics for future Erlang:
http://dl.acm.org/citation.cfm?id=1863514

Towards Haskell in the Cloud:
http://research.microsoft.com/en-us/um/people/simonpj/papers/parallel/remote.pdf
