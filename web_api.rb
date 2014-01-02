require 'sinatra/base'
require 'dcell'
require 'pp'

DCell.start id: 'web', addr: 'tcp://127.0.0.1:9002'

class WebApi < Sinatra::Base
  configure do
    set :sim_node, DCell::Node['sim']
    enable :static, :sessions
    set :server, 'thin'

    mime_type :text, 'text/plain'
  end

  before do
    @market = settings.sim_node[:market]
    @portfolio = @market.create_portfolio(session.id)
  end

  get '/' do
    erb :index
  end

  get '/market' do
    content_type :text
    @market.to_s
  end

  get '/nodes' do
    content_type :text
    PP.pp(DCell::Node.all, '')
  end

  get '/nodes/:id' do |id|
    content_type :text
    PP.pp(DCell::Node[id].actors, '')
  end

  post '/orders' do
    if @market.send(params['order_type'], params['stock_symbol'], params['quantity'], params['price'], session.id)
      redirect to('/?ok')
    else
      erb :index
    end
  end
end
