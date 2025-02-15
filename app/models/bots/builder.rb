module Bots
  class Builder
    MAX_CARS = 10

    def build!
      for i in (1..MAX_CARS)
        CarBuilderService.new.build_car!
      end
    end

    def wipe_out_stock!
      (Car.all - Car.sold).each(&:destroy!)
    end
  end
end
