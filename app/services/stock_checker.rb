class StockChecker
  FACTORY_MAX = 100 # ASSUMPTION: Warehouse and store have maximums
  STORE_MAX = 50

  def self.factory_stock(model:)
    return Car.in_factory.where(model: model) if model

    Car.in_factory
  end

  def self.store_stock(model:)
    return Car.in_store.where(model: model) if model

    Car.in_store
  end

  def self.in_factory_stock?(model)
    non_defective_cars.select { |car| car.model == model }.present?
  end

  def self.non_defective_cars
    Car.in_factory.select { |car| car.computer.defects.empty? }
  end

end
