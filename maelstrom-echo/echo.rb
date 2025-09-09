#!/usr/bin/env ruby

# ENV['BUNDLE_GEMFILE'] = File.join(File.dirname(__FILE__), '..', 'Gemfile')
ENV['BUNDLE_GEMFILE'] = File.expand_path('../Gemfile', __dir__)

require 'bundler/setup'
require "maelstrom_ruby"

class EchoNode
  def initialize
    @node = Node.new

    @node.on "echo" do |msg|
      @node.reply! msg, msg[:body].merge(type: "echo_ok")
    end
  end

  def main!
    @node.main!
  end
end

EchoNode.new.main!
