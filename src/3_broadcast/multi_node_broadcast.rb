#!/usr/bin/env ruby

require_relative '../shared_header'

class MultiBroadcastNode < Node
  def initialize
    super

    @messages = []
    @topology = {}

    # {"src": "c1", "dest": "n1", "body": {"msg_id": 1, "type": "broadcast", "message": 1000}}
    on 'broadcast' do |msg|
      message = msg[:body][:message]

      original_len = @messages.length
      @messages.append(message)
      @messages.uniq!
      new_len = @messages.length

      if original_len != new_len
        neighbors&.each do |nb|
          send!(nb, { type: 'broadcast', message: message })
        end
      end

      reply!(msg, { type: 'broadcast_ok'})
    end

    on 'broadcast_ok' do |msg|
    end

    on 'read' do |msg|
      reply!(msg, { 
        type: 'read_ok',
        messages: @messages 
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
