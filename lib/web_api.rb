require 'sinatra/base'
require 'dcell'
require 'pp'

DCell.start id: 'web', addr: 'tcp://127.0.0.1:9002'

class WebApi < Sinatra::Base
  configure do
    set :sim_node, DCell::Node['sim']
    set :static, true
    set :public_folder, File.join(File.dirname(__FILE__), '..', 'public')

    mime_type :text, 'text/plain'
  end

  get '/' do
    File.read(File.join(settings.public_folder, 'index.html'))
  end

  get '/market' do
    content_type :text
    settings.sim_node[:market].status
  end

  get '/all' do
    content_type :text
    PP.pp(DCell::Node.all, '')
  end

  post '/buy' do
    order_action(settings.sim_node[:market], :buy, 'STOCK', 100, 100)
  end

  post '/sell' do
    order_action(settings.sim_node[:market], :sell, 'STOCK', 100, 100)
  end

  def order_action(market, order_type, stock_symbol, quantity, price)
    if market.send(order_type, stock_symbol, quantity, price)
      redirect to('/?ok')
    else
      File.read(File.join(settings.public_folder, 'index.html'))
    end
  end
end
