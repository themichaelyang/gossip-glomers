#!/usr/bin/env ruby

require_relative '../shared_header'

# From https://github.com/jepsen-io/maelstrom/blob/main/demo/ruby/echo_full.rb
class EchoNode
  def initialize
    @node = Node.new

    @node.on 'echo' do |msg|
      @node.reply! msg, msg[:body].merge(type: 'echo_ok')
    end
  end

  def main!
    @node.main!
  end

  def self.test_command
    "./maelstrom/maelstrom test -w echo --bin #{__FILE__} --node-count 1 --time-limit 10"
  end
end

EchoNode.new.main!
