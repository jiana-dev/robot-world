module Bots
  class Builder
    MAX_CARS = 10

    def call
      for i in (1..MAX_CARS)
        CarBuilderService.new.build_car!
      end
    end

    def wipe_out_stock
      return
    end
  end
end
