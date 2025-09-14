# Gossip Glomers (Fly.io Distributed Systems Challenge)

https://fly.io/dist-sys/

## Notes on Maelstrom

- Maelstrom takes in an executable and spins up a process per "node" with that executable.
- For each node, it simulates a network by sending data to the node with STDIN and listening to STDOUT to send data from the node. STDERR is saved into as into a per-node log file after Maelstrom is done.
- In the Ruby Maelstrom demo node, each handler spawns a new Thread. The Node has a Mutex for STDIO (so IO is ordered), and for selecting handlers (so response callbacks are invoked once).

## Setup 

1. `git clone` this repo
2. Download [Maelstrom 0.2.3](https://github.com/jepsen-io/maelstrom/releases/tag/v0.2.3) into this repo
2. Unzip with `tar -xzf maelstrom.tar.bz2`
3. `git clone git@github.com:jepsen-io/maelstrom.git vendor/gems/maelstrom_ruby/maelstrom` to add the vendored Ruby library
4. `chmod +x yourfile.rb` for Maelstrom to run your file. Don't forget the #!
5. Run! e.g. `./maelstrom/maelstrom test -w echo --bin src/1_echo/echo.rb --node-count 1 --time-limit 10`

Known issues:
LSP links to the `./maelstrom/demo/ruby` Ruby files, instead of the vendored code. May need to update: https://solargraph.org/guides/configuration (which ignores `vendor` by default)
