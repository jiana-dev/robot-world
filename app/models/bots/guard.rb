module Bots
  class Guard
    MAX_CARS = 10

    def alert_for_defects
      SlackNotifier.post(defect_message)
    end

    def move_factory_stock_to_store!
      while StockChecker.store_stock.size < StockChecker::STORE_MAX do
        car = StockOptimizer.retrieve_car
        car.to_store!
      end
    end

    private

    def defect_message
      message = "Defective Car Parts Report:\n"

      defective_car_ids.each do |car_id|
        car = Car.find(car_id)
        message += "\n Car ID: #{car.id}, Model: #{car.model}, Defective Parts: "
        message += car.computer.defects.map(&:name).join(", ")
      end

      message
    end

    def defective_car_ids
      CarPart.where('created_at >= ? and defective = true', 30.minutes.ago).pluck(:car_id).uniq
    end

  end
end
