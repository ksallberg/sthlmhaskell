sthlmhaskell cloud haskell chat
===============================

<b>You can use CloudExample.hs to see if Cloud Haskell is installed properly. Simply runhaskell CloudExample.hs</b>

for ghc base < 5, download from hackage: <br>
cabal update <br>
cabal install cabal-install <br>
cabal install distributed-process <br>
cabal install distributed-process-simplelocalnet <br>
<br>
for ghc base >= 5, download from:<br>
http://haskell-distributed.github.io<br>
<br>
To set up a chat server and three clients with the cabal sandbox<br>
   (after cabal build):<br>
<br>
base< < 5:<br>
runhaskell Chat.hs server 127.0.0.1 10001<br>
runhaskell Chat.hs client 127.0.0.1 10002<br>
runhaskell Chat.hs client 127.0.0.1 10003<br>
runhaskell Chat.hs client 127.0.0.1 10004<br>
<br>
base >= 5:<br>
dist/build/the-chat/the-chat server 127.0.0.1 10001<br>
dist/build/the-chat/the-chat client 127.0.0.1 10002<br>
dist/build/the-chat/the-chat client 127.0.0.1 10003<br>
dist/build/the-chat/the-chat client 127.0.0.1 10004<br>
<br>
relevant papers:<br>
A unified semantics for future Erlang:<br>
http://dl.acm.org/citation.cfm?id=1863514<br>
<br>
Towards Haskell in the Cloud:<br>
http://research.microsoft.com/en-us/um/people/simonpj/papers/parallel/remote.pdf<br>
