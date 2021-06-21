class StockOptimizer
  def self.retrieve_car
    sorted_store_stock = get_store_stock().sort_by {|k, v| v}

    least_stocked_car_model, _ = sorted_store_stock.detect { |model, _| StockChecker.in_factory_stock?(model) }
    
    Car.in_factory.find_by(model: least_stocked_car_model)
  end

  def self.get_store_stock
    stock = {}

    CarBuilderService::MODELS.each do |model|
      num_model_in_store = StockChecker.store_stock(model: model).count
      stock[model] = num_model_in_store
    end

    stock
  end
end

