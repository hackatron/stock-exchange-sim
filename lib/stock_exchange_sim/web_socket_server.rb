class StockExchangeSim::WebSocketServer < Reel::Server
  include Celluloid::Logger

  def initialize(host = '0.0.0.0', port = 1234)
    info "Websocket server starting on #{host}:#{port}"
    super(host, port, &method(:on_connection))
  end

  def on_connection(connection)
    while request = connection.request
      if request.websocket?
        info 'Received a WebSocket connection'

        # If we want to hand this connection off to another actor, we first
        # need to detach it from the Reel::Server (in this case, Reel::Server::HTTP)
        connection.detach

        route_websocket request.websocket
        return
      else
        info "404 Not Found: #{request.path}"
        connection.respond :not_found, 'Not found'
      end
    end
  end

  def route_websocket(socket)
    if socket.url == '/'
      StockExchangeSim::Broker.new(socket)
    else
      info "Received invalid WebSocket request for: #{socket.url}"
      socket.close
    end
  end
end