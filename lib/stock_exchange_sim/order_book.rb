require 'algorithms'

class StockExchangeSim::OrderBook
  attr_accessor :buy_orders, :sell_orders

  def initialize
    @buy_orders = Containers::CRBTreeMap.new
    @sell_orders = Containers::CRBTreeMap.new
  end

  def submit_order(order)
    if order.order_type == :buy
      buy_orders.push(order, true)
    else
      sell_orders.push(order, true)
    end
  end

  def match?
    return false if buy_orders.size == 0 || sell_orders.size == 0
    sell_orders.min_key.match? buy_orders.max_key
  end

  def trade!
    sell = sell_orders.max_key
    buy = buy_orders.min_key

    sell_orders.delete(sell)
    buy_orders.delete(buy)

    return StockExchangeSim::Transaction.new(buy, sell)
  end

  def to_s
    buy_orders_s = []
    buy_orders.each { |k, v| buy_orders_s << k.to_s }
    sell_orders_s = []
    sell_orders.each { |k, v| sell_orders_s << k.to_s }

    "#{buy_orders_s.join("\n")}\n#{sell_orders_s.join("\n")}"
  end
end