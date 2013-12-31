class StockExchangeSim::Order
  attr_accessor :stock_symbol, :order_type, :quantity, :price, :time, :session_id

  def initialize(stock_symbol, order_type, quantity, price, session_id)
    @stock_symbol = stock_symbol.upcase
    @order_type = order_type.to_sym
    @quantity = quantity.to_i
    @price = price.to_i
    @session_id = session_id
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
    [session_id, time, order_type.upcase, stock_symbol, price, quantity].join("\t")
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
