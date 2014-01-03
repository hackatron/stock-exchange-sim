require 'json'

class StockExchangeSim::Broker
  include Celluloid
  include Celluloid::Notifications
  include Celluloid::Logger

  def initialize(websocket, session_id)
    info 'Streaming market changes to client'
    @socket = websocket
    @socket.on_close do |status, message|
      info "Client closed connection. Status: #{status}. Reason: #{message}"
      @socket << WebSocket::Message.close.to_data
      @socket.close
      terminate
    end
    @socket.on_error do |m|
      info "Received error #{m}"
      @socket.close
      terminate
    end
    subscribe('market_order', :notify_market_update)
    subscribe('market_trade', :notify_market_update)
  end

  def notify_market_update(topic, data)
    info "Received notification: #{topic}, #{data}"
    @socket << JSON.generate({ topic: topic, data: data.to_h })
  rescue Exception => e
    info 'Market client disconnected'
    info e.inspect
    @socket.close
    terminate
  end
end