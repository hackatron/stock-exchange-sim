class StockExchangeSim::Broker
  include Celluloid
  include Celluloid::Notifications
  include Celluloid::Logger

  def initialize(websocket)
    info 'Streaming market changes to client'
    @socket = websocket
    subscribe('market_updates', :notify_market_update)
  end

  def notify_market_update(topic, order)
    info 'Received notification'
    @socket << order.to_s
  rescue Exception => e
    info 'Market client disconnected'
    info e.inspect
    terminate
  end
end