#!/usr/bin/env ruby

require_relative '../shared_header'
require_relative 'array_set'

# Not quite working
class MinimalBroadcastNode < Node
  def initialize
    super

    @messages = ArraySet.new
    @topology = {}
    @gossiped = 0

    on 'broadcast' do |msg|
      message = msg[:body][:message]
      
      @messages.add(message)
      reply!(msg, {type: 'broadcast_ok'})
    end

    on '_gossip' do |msg|
      messages = msg[:body][:messages]

      gossip(msg[:src], neighbors)

      messages.each do |message|
        @messages.add(message)
      end

      # Don't reply on gossip to save messages
    end

    on 'read' do |msg|
      reply!(msg, {type: 'read_ok', messages: @messages.to_a})
    end

    on 'topology' do |msg|
      @topology = msg[:body][:topology]

      reply!(msg, {type: 'topology_ok'})
    end

    every(0.5) do
      gossip(nil, neighbors&.sample(1))
    end
  end

  def gossip(source, dests)
    ungossiped_messages = @messages.to_a[@gossiped..-1]
  
    dests&.each do |nb|
      if nb != source
        send!(nb, {type: '_gossip', messages: ungossiped_messages})
      end
    end
  
    @gossiped = @messages.length
  end

  def neighbors
    @topology[@node_id]
  end
end

MinimalBroadcastNode.new.main!
