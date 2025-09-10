#!/usr/bin/env ruby

require_relative '../shared_header'
require 'securerandom'

class UniqueIdNode
  def initialize
    @node = Node.new

    @node.on('generate') do |msg|
      @node.reply!(msg, {
        type: 'generate_ok',
        id: SecureRandom.uuid
      })
    end
  end

  def main!
    @node.main!
  end

  def self.test_command
    "./maelstrom/maelstrom test -w unique-ids --bin #{__FILE__} --time-limit 30 --rate 1000 --node-count 3 --availability total --nemesis partition"
  end
end

puts UniqueIdNode.test_command
UniqueIdNode.new.main!
