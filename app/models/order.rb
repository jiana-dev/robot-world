class Order < ApplicationRecord
  belongs_to :car, optional: true

  def self.place!(car)
    car.purchase!
    create!(car: car)
  end

  def self.exchange!(order, car)
    car.purchase!
    order.update!(car: car)
  end

  def revenue
    car.revenue
  end

  def value
    car.price
  end
end
