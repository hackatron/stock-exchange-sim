require 'pp'

class StockExchangeSim::Portfolio
  attr_accessor :session_id, :stocks, :money

  def initialize(session_id)
    @session_id = session_id
    @stocks = {}
    @money = 0
  end

  def update(order)
    stocks[order.stock_symbol] ||= { shares: 0, price: 0 }

    if order.order_type == :buy
      stock_shares = stocks[order.stock_symbol][:shares] + order.quantity
      stocks[order.stock_symbol][:price] = stocks[order.stock_symbol][:price]*(stocks[order.stock_symbol][:shares]/stock_shares) + order.price*(order.quantity/stock_shares)
      @money -= order.price*order.quantity
    else
      stock_shares = stocks[order.stock_symbol][:shares] - order.quantity
      @money += order.price*order.quantity
    end

    stocks[order.stock_symbol][:shares] = stock_shares
  end

  def to_s
    "Portfolio: #{session_id}\nMoney: #{money}"
  end
end