module Bots
  class Buyer
    CARS_TO_BUY = (1..10).to_a
    CARS_TO_EXCHANGE = (1..5).to_a # ASSUMPTION: Exchange 1 to 5 cars per hour

    def buy!
      for i in (1..CARS_TO_BUY.sample)
        new_model = CarBuilderService::MODELS.sample

        if StockChecker.in_store_stock?(new_model)
          place_order!(new_model)
        else
          alert_out_of_stock(new_model)
        end
      end
    end

    def exchange!
      orders = Order.all.sample(CARS_TO_EXCHANGE.sample)
      orders.each do |order|
        exchange_car!(order, CarBuilderService::MODELS.sample)
      end
    end

    private

    def place_order!(model, existing_order: nil)
      car = Car.in_store.find_by(model: model)
      existing_order.present? ? Order.exchange!(existing_order, car) : Order.place!(car)
    end

    def alert_out_of_stock(model) # ASSUMPTION: Log via Slack
      SlackNotifier.post("#{Time.zone.now} Out of Stock: #{model}")
    end

    def exchange_car!(order, new_model)
      if StockChecker.in_store_stock?(new_model)
        order.car.to_store!
        place_order!(new_model, existing_order: order)
      else
        alert_out_of_stock(new_model)
      end
    end
  end
end
