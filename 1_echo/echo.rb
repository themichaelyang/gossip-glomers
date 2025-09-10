#!/usr/bin/env ruby

ENV['BUNDLE_GEMFILE'] ||= File.expand_path('../Gemfile', __dir__)

require 'bundler/setup'
require 'maelstrom_ruby'

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
end

EchoNode.new.main!
