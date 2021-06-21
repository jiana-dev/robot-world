class DailyReport
  attr_reader :date

  def initialize(date: Time.zone.today)
    @date = date
  end

  def revenue
    all_orders.sum(&:revenue)
  end

  def cars_sold
    all_orders.count
  end

  def average_order_value
    all_orders.sum(&:value)
  end

  private

  def all_orders
    # If car not present, it tried to be exchanged but the replacement wasn't in stock
    Order.where(updated_at: date.all_day).select { |order| order.car.present? }
  end
end
