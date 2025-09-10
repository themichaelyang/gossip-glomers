#!/usr/bin/env ruby

require_relative '../shared_header'
require_relative 'array_set'

class MultiBroadcastNode < Node
  def initialize
    super

    @messages = ArraySet.new
    @topology = {}

    # {"src": "c1", "dest": "n1", "body": {"msg_id": 1, "type": "broadcast", "message": 1000}}
    on 'broadcast' do |msg|
      message = msg[:body][:message]

      unless @messages.include?(message)
        neighbors&.each do |nb|
          send!(nb, { type: 'broadcast', message: message })
        end

        @messages.add(message)
      end

      reply!(msg, { type: 'broadcast_ok'})
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
  end

  def neighbors
    @topology[@node_id]
  end

  def self.test_command
    "./maelstrom/maelstrom test -w broadcast --bin #{__FILE__} --node-count 5 --time-limit 20 --rate 10"
  end
end

# puts MultiBroadcastNode.test_command
MultiBroadcastNode.new.main!
