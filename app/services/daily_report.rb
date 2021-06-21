class DailyReport
  attr_reader :date

  def initialize(date: Time.zone.today)
    @date = date
  end

  def revenue
    all_orders.sum(&:revenue)
  end

  def cars_sold
    all_orders.size
  end

  def average_order_value
    all_orders.sum(&:value) / cars_sold
  end

  private

  def all_orders
    Order.where(created_at: date.all_day)
  end
end
