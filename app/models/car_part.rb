class CarPart < ApplicationRecord
  belongs_to :car

  def defects
    return nil if name != 'computer'

    car.car_parts.where(defective: true)
  end
end
