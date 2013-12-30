require 'pp'

class StockExchangeSim::Market
  include Celluloid
  include Celluloid::Notifications
  include Celluloid::Logger

  attr_accessor :stocks, :transactions, :order_book

  def initialize
    @stocks = []
    @transactions = []
    @order_book = {}
  end

  def create(stock_symbol, shares, price)
    stocks << StockExchangeSim::Stock.new(stock_symbol, shares, price)
  end

  def buy(stock_symbol, quantity, price)
    order = StockExchangeSim::Order.new(stock_symbol, :buy, quantity, price)
    submit_order(order)
  end

  def sell(stock_symbol, quantity, price)
    order = StockExchangeSim::Order.new(stock_symbol, :sell, quantity, price)
    submit_order(order)
  end

  def submit_order(order)
    info "Submit order: #{order}"
    publish('market_updates', order)
    order_book[order.stock_symbol] ||= StockExchangeSim::OrderBook.new
    order_book[order.stock_symbol].submit_order(order)
    if order_book[order.stock_symbol].match?
      transaction = order_book[order.stock_symbol].trade!
      transaction.update_portfolios
      transactions << transaction
    end
  end

  def status
    "Stocks: #{PP.pp(stocks, '')}\nTransactions: #{PP.pp(transactions, '')}\nOrder book: #{PP.pp(order_book, '')}"
  end
end