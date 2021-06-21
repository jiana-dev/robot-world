module Bots
  class Buyer
    CARS_TO_BUY = (1..10).to_a
    CARS_TO_EXCHANGE = (1..5).to_a # ASSUMPTION: Exchange 1 to 5 cars per hour

    def call
      for i in (1..CARS_TO_BUY.sample)
        place_order!(CarBuilderService::MODELS.sample)
      end
    end

    def exchange_cars!
      order_ids = Order.pluck(:id).sample(CARS_TO_EXCHANGE.sample)
      order_ids.each do |o_id|
        exchange_car!(o_id, CarBuilderService::MODELS.sample)
      end
    end

    private

    def place_order!(model, existing_order: nil)
      car_order = Car.in_store.find_by(model: model)

      if car_order.nil?
        alert_out_of_stock(model) # ASSUMPTION: Log via Slack
        return
      end

      existing_order.present? ? existing_order.update!(car: car_order) : Order.create!(car: car_order)
    end

    def alert_out_of_stock(model)
      ::SlackNotifier.post("#{Time.zone.now} Out of Stock: #{model}")
    end

    def exchange_car!(order_id, new_model)
      order = Order.find(order_id)

      if order.car
        order.car.to_store!
        order.car = nil
      end

      place_order!(new_model, existing_order: order)
    end
  end
end
