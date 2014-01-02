class StockExchangeSim::Transaction
  include Celluloid

  attr_accessor :buy_order, :sell_order

  def initialize(buy_order, sell_order)
    @buy_order = buy_order
    @sell_order = sell_order
  end

  def to_s
    [buy_order, sell_order].join("\t")
  end
end