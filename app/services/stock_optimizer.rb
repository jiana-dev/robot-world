class StockOptimizer
  def self.retrieve_car
    sorted_store_stock = get_store_stock().sort_by {|k, v| v}

    least_stocked_car = sorted_store_stock.detect { |model, _| StockChecker.in_factory_stock?(model) }
    least_stocked_car
  end

  def self.get_store_stock # OPTIMIZE
    stock = {}

    CarBuilderService::MODELS.each do |model|
      num_model_in_store = StockChecker.store_stock(model: model).count
      stock[model] = num_model_in_store
    end

    stock
  end
end

