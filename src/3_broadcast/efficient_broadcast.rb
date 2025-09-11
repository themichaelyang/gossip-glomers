#!/usr/bin/env ruby

require_relative '../shared_header'
require_relative 'array_set'

# https://github.com/jepsen-io/maelstrom/blob/main/doc/03-broadcast/02-performance.md
# https://community.fly.io/t/gossip-glomers-challenge-3d-efficiency-described-is-impossible/12324
class EfficientBroadcastNode < Node
  def initialize
    super

    @messages = ArraySet.new
    @topology = {}

    on 'broadcast' do |msg|
      save_and_gossip(msg)
      reply!(msg, {type: 'broadcast_ok'})
    end

    on '_gossip' do |msg|
      save_and_gossip(msg)
      # Don't reply on gossip to save messages
    end

    on 'read' do |msg|  
      reply!(msg, {type: 'read_ok', messages: @messages.to_a})
    end

    # Works fast with `--topology tree4`
    # TODO: customize topology instead of using maelstrom's topologies
    on 'topology' do |msg|
      @topology = msg[:body][:topology]

      reply!(msg, {type: 'topology_ok'})
    end
  end

  def save_and_gossip(msg)
    message = msg[:body][:message]
    unless @messages.include?(message)
      neighbors&.each do |nb|
        # Don't gossip with source
        if nb != msg[:src]
          send!(nb, {type: '_gossip', message: message})
        end
      end

      @messages.add(message)
    end
  end

  def neighbors
    @topology[@node_id]
  end
end

EfficientBroadcastNode.new.main!
