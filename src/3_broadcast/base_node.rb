# Unfortunately, this doesn't play well with the LSP
# It would look like this, instead of in the initialize:
#
# class BroadcastNode
#   on 'broadcast' do |msg|
#   end

#   on 'read' do |msg|
#   end

#   on 'topology' do |msg|
#   end
# end

class BaseNode < Node
  def self.on(event_type, &blk)
    @handlers ||= {}
    @handlers[event_type] = blk
  end

  def self.handlers
    @handlers || {}
  end

  def initialize
    self.class.handlers.each do |event_type, handler|
      on(event_type) do |msg|
        handler.call(msg)
      end
    end
  end
end