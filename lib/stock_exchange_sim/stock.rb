class StockExchangeSim::Stock
  attr_accessor :symbol, :shares, :price

  def initialize(symbol, shares, price)
    @symbol = symbol
    @shares = shares
    @price = price
  end

  def to_s
    [symbol, shares, price].join("\t")
  end
end