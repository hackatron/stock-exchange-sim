class StockExchangeSim::Order
  attr_accessor :stock_symbol, :order_type, :quantity, :price, :time

  def initialize(stock_symbol, order_type, quantity, price)
    @stock_symbol = stock_symbol
    @order_type = order_type
    @quantity = quantity
    @price = price
    @time = Time.now
  end

  def <=>(other)
    stock_symbol_e = stock_symbol <=> other.stock_symbol
    return stock_symbol_e if stock_symbol_e != 0

    price_e = price <=> other.price
    return price_e if price_e != 0

    time_e = time <=> other.time
    return time_e
  end

  def to_s
    [time, order_type, stock_symbol, price, quantity].join("\t")
  end

  def match?(other)
    price_match = if order_type == :buy && other.order_type == :sell
      price >= other.price
    else
      price <= other.price
    end
    
    stock_symbol == other.stock_symbol &&
      quantity == other.quantity &&
      price_match
  end
end
