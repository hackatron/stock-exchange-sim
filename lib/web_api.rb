require 'rack'
require 'dcell'
require 'pp'

DCell.start id: 'web', addr: 'tcp://127.0.0.1:9002'

class WebApi
  def call(env)
    req = Rack::Request.new(env)
    sim_node = DCell::Node['sim']

    case req.request_method
    when 'GET'
      case req.path
      when '/'
        return [200, {'Content-Type' => 'text/html'}, [File.read('public/index.html')]]
      when '/market'
        return [200, {'Content-Type' => 'text/plain'}, [sim_node[:market].status]]
      when '/all'
        return [200, {'Content-Type' => 'text/plain'}, [PP.pp(DCell::Node.all, '')]]
      end
    when 'POST'
      pp req.body.read
      case req.path
      when '/buy'
        return order_action(sim_node[:market], :buy, 'STOCK', 100, 100)
      when '/sell'
        return order_action(sim_node[:market], :sell, 'STOCK', 100, 100)
      end
    end

    [404, {'Content-Type' => 'text/plain'}, ['Not found']]
  end

  def order_action(market, order_type, stock_symbol, quantity, price)
    if market.send(order_type, stock_symbol, quantity, price)
      [302, {'Content-Type' => 'text/plain', 'Location' => '/?ok'}, []]
    else
      [200, {'Content-Type' => 'text/html'}, [File.read('public/index.html')]]
    end
  end
end
