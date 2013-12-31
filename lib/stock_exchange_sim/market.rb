require 'pp'

class StockExchangeSim::Market
  include Celluloid
  include Celluloid::Notifications
  include Celluloid::Logger

  attr_accessor :stocks, :transactions, :order_book, :portfolios

  def initialize
    @stocks = []
    @transactions = []
    @order_book = {}
    @portfolios = {}
  end

  def create_portfolio(session_id)
    portfolios[session_id] ||= StockExchangeSim::Portfolio.new(session_id)
  end

  def create(stock_symbol, shares, price)
    stocks << StockExchangeSim::Stock.new(stock_symbol, shares, price)
  end

  def buy(stock_symbol, quantity, price, session_id)
    order = StockExchangeSim::Order.new(stock_symbol, :buy, quantity, price, session_id)
    submit_order(order)
  end

  def sell(stock_symbol, quantity, price, session_id)
    order = StockExchangeSim::Order.new(stock_symbol, :sell, quantity, price, session_id)
    submit_order(order)
  end

  def submit_order(order)
    info "Submit order: #{order}"
    publish('market_order', order)
    order_book[order.stock_symbol] ||= StockExchangeSim::OrderBook.new
    order_book[order.stock_symbol].submit_order(order)
    if order_book[order.stock_symbol].match?
      transaction = order_book[order.stock_symbol].trade!
      publish('market_trade', transaction)
      info "Updating buyer's portfolio #{portfolios[transaction.buy_order.session_id]}"
      portfolios[transaction.buy_order.session_id].update(transaction.buy_order)
      info "Updating seller's portfolio #{portfolios[transaction.sell_order.session_id]}"
      portfolios[transaction.sell_order.session_id].update(transaction.sell_order)
      transactions << transaction
      return true
    end
  end

  def status
    "Portfolios: #{PP.pp(portfolios, '')}\nStocks: #{PP.pp(stocks, '')}\nTransactions: #{PP.pp(transactions, '')}\nOrder book: #{PP.pp(order_book, '')}"
  end
end