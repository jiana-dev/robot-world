require 'net/http'

module Bots
  class Guard
    MAX_CARS = 10

    def call
      alert_for_defects()
      move_factory_stock_to_store!()
    end

    private
  
    def alert_for_defects
      SlackNotifier.post(defect_message)
    end

    def defect_message
      message = "Defective Car Parts Report:\n"
      defective_cars.each do |car|
        message += "\n Car ID: #{car.id}, Model: #{car.model}, Defective Parts: "
        message += car.computer.defects.map(&:name).join(", ")
      end

      message
    end

    def defective_cars
      Car.where('created_at >= ?', 30.minutes.ago).select{|car| car.computer.present? && car.computer.defects.any? }
    end

    def move_factory_stock_to_store!
      while StockChecker.store_stock.count < StockChecker::STORE_MAX do
        car = StockOptimizer.retrieve_car
        car.to_store!
      end
    end
  end
end
