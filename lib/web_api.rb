require 'sinatra/base'
require 'dcell'
require 'pp'

DCell.start id: 'web', addr: 'tcp://127.0.0.1:9002'

class WebApi < Sinatra::Base
  configure do
    set :sim_node, DCell::Node['sim']
    enable :static, :sessions
    set :public_folder, File.join(File.dirname(__FILE__), '..', 'public')
    set :server, 'thin'

    mime_type :text, 'text/plain'
  end

  get '/' do
    File.read(File.join(settings.public_folder, 'index.html'))
  end

  get '/market' do
    content_type :text
    settings.sim_node[:market].status
  end

  get '/nodes/all' do
    content_type :text
    PP.pp(DCell::Node.all, '')
  end

  get '/nodes/:id/actors' do |id|
    content_type :text
    PP.pp(DCell::Node[id].actors, '')
  end

  post '/orders' do
    if settings.sim_node[:market].send(params['order_type'], params['stock_symbol'], params['quantity'], params['price'])
      redirect to('/?ok')
    else
      File.read(File.join(settings.public_folder, 'index.html'))
    end
  end
end
