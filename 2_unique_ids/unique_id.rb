#!/usr/bin/env ruby

ENV['BUNDLE_GEMFILE'] ||= File.expand_path('../Gemfile', __dir__)

require 'bundler/setup'
require 'maelstrom_ruby'
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
end

UniqueIdNode.new.main!
