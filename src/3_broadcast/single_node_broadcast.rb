#!/usr/bin/env ruby

require_relative '../shared_header'

class SingleBroadcastNode < Node
  def initialize
    super

    @messages = []
    @topology = nil

    # {"src": "c1", "dest": "n1", "body": {"msg_id": 1, "type": "broadcast", "message": 1000}}
    on 'broadcast' do |msg|
      @messages.append(msg[:body][:message])
      reply!(msg, { type: 'broadcast_ok'})
    end

    on 'read' do |msg|
      reply!(msg, { 
        type: 'read_ok',
        messages: @messages 
      })
    end

    on 'topology' do |msg|
      @topology = msg[:topology]

      reply!(msg, {
        type: 'topology_ok'
      })
    end
  end

  def self.test_command
    "./maelstrom/maelstrom test -w broadcast --bin #{__FILE__} --node-count 1 --time-limit 20 --rate 10"
  end
end

# puts SingleBroadcastNode.test_command
SingleBroadcastNode.new.main!
