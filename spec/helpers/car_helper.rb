module CarHelper
  extend self

  def create_car_with_computer(options)
    car = Car.create(options)
    car.car_parts.create(name: 'computer')
    car.reload
  end
end
