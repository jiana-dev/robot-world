class Order < ApplicationRecord
  belongs_to :car

  def self.place!(car)
    car.purchase!
    create!(car: car)
  end

  def self.exchange!(order, car)
    car.purchase!
    order.update!(car: car)
  end

  delegate :revenue, to: :car

  def value
    car.price
  end
end
