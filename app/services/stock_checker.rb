module StockChecker
  STORE_MAX = 50 # ASSUMPTION: Store has maximum

  def self.factory_stock(model: nil)
    return Car.in_factory.where(model: model) if model

    Car.in_factory
  end

  def self.store_stock(model: nil)
    return Car.in_store.where(model: model) if model

    Car.in_store
  end

  def self.in_factory_stock?(model)
    non_defective_cars.select { |car| car.model == model }.present?
  end

  def self.non_defective_cars
    Car.in_factory.select { |car| car.computer.defects.empty? }
  end

  def self.in_store_stock?(model)
    store_stock(model: model).select { |car| car.model == model }.present?
  end
end
