class StockExchangeSim::Transaction
  attr_accessor :buy_order, :sell_order

  def initialize(buy_order, sell_order)
    @buy_order = buy_order
    @sell_order = sell_order
  end

  def update_portfolios
    # TODO
  end

  def to_s
    [buy_order, sell_order].to_s
  end
end