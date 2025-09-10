# Gossip Glomers (Fly.io Distributed Systems Challenge)

https://fly.io/dist-sys/

## Setup 

1. `git clone` this repo
2. Download [Maelstrom 0.2.3](https://github.com/jepsen-io/maelstrom/releases/tag/v0.2.3) into this repo
2. Unzip with `tar -xzf maelstrom.tar.bz2`
3. `git clone git@github.com:jepsen-io/maelstrom.git vendor/gems/maelstrom_ruby/maelstrom` to add the vendored Ruby library
4. `chmod +x yourfile.rb` for Maelstrom to run your file. Don't forget the #!
5. Run! e.g. `./maelstrom/maelstrom test -w echo --bin src/1_echo/echo.rb --node-count 1 --time-limit 10`
