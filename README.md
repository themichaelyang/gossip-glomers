# Gossip Glomers (Fly.io Distributed Systems Challenge)

https://fly.io/dist-sys/

## Setup 

1. `git clone` this repo
2. Download [Maelstrom 0.2.3](https://github.com/jepsen-io/maelstrom/releases/tag/v0.2.3) into this repo
2. Unzip with `tar -xzf maelstrom.tar.bz2`
3. `git clone git@github.com:jepsen-io/maelstrom.git vendor/gems/maelstrom_ruby/maelstrom` to add the vendored Ruby library
4. `chmod +x yourfile.rb` if you want Maelstrom to run it

## 2. Unique ID Generation

```
$ ./maelstrom/maelstrom test -w unique-ids --bin ./2_unique_ids/unique_id.rb --time-limit 30 --rate 1000 --node-count 3 --availability total --nemesis partition
```

