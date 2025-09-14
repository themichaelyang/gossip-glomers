#!/usr/bin/env ruby

require_relative '../shared_header'
require_relative 'array_set'

# TODO: make it wait for a response instead of syncing the whole thing naively
# There's a guide in https://github.com/jepsen-io/maelstrom/blob/main/doc/03-broadcast/02-performance.md for doing this
# with sleep. 

# I was trying to do this with condition variables (with Promise.new) to suspend the thread while it waits for a response,
# but kept running into macOS thread limits. It's possible that this was because the on('broadcast') Thread was being suspended, 
# with each callback also spawning a new Thread.
class FaultTolerantBroadcastNode < Node
  def initialize
    super

    @messages = ArraySet.new
    @topology = {}

    # {"src": "c1", "dest": "n1", "body": {"msg_id": 1, "type": "broadcast", "message": 1000}}
    on 'broadcast' do |msg|
      message = msg[:body][:message]

      unless @messages.include?(message)
        neighbors&.each do |nb|
          send!(nb, {type: 'broadcast', message: message})
        end

        @messages.add(message)
      end

      reply!(msg, {type: 'broadcast_ok'})
    end

    on 'broadcast_ok' do |msg|
    end

    on 'read' do |msg|  
      reply!(msg, { 
        type: 'read_ok',
        messages: @messages.to_a
      })
    end

    on 'topology' do |msg|
      @topology = msg[:body][:topology]

      reply!(msg, {
        type: 'topology_ok'
      })
    end

    on 'read_ok' do |msg|
      msg[:body][:messages].each do |message|
        @messages.add(message)
      end
    end

    every(0.5) do
      neighbors&.sample(1)&.each do |nb|
        # This is a bit naive, but sends the whole set to neighbors
        replicate(nb)
      end
    end
  end

  def replicate(nb)
    send!(nb, {type: 'read', messages: @messages.to_a})
  end

  def neighbors
    @topology[@node_id]
  end

  def self.test_command
    "./maelstrom/maelstrom test -w broadcast --bin #{__FILE__} --node-count 5 --time-limit 20 --rate 10"
  end
end

# puts FaultTolerantBroadcastNode.test_command
FaultTolerantBroadcastNode.new.main!
