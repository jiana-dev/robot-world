class Order < ApplicationRecord
  belongs_to :car

  after_save :decrease_store_stock

  private

  def decrease_store_stock
    car.purchase!
  end

  def revenue
    car&.revenue.to_i
  end

  def value
    car&.price.to_i
  end
end
