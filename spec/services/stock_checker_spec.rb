require 'rails_helper'
require 'helpers/car_helper'

RSpec.describe StockChecker do
  include CarHelper

  before(:all) do
    DatabaseCleaner.start

    2.times { create_car_with_computer(state: 'in_factory', model: 'test_model') }
    2.times { create_car_with_computer(state: 'in_factory') }
    4.times { create_car_with_computer(state: 'in_store', model: 'test_model') }
    4.times { create_car_with_computer(state: 'in_store') }
  end

  after(:all) { DatabaseCleaner.clean }

  describe '.factory_stock' do
    it 'returns cars in factory with model' do
      expect(StockChecker.factory_stock(model: 'test_model').size).to eq(2)
    end

    it 'returns all cars in factory if without model' do
      expect(StockChecker.factory_stock.size).to eq(4)
    end
  end

  describe '.store_stock' do
    it 'returns cars in store with model' do
      expect(StockChecker.store_stock(model: 'test_model').size).to eq(4)
    end

    it 'returns all cars in store if without model' do
      expect(StockChecker.store_stock.size).to eq(8)
    end
  end

  describe '.in_factory_stock?' do
    it 'returns true if there are non defective cars with model in the factory' do
      expect(StockChecker.in_factory_stock?('test_model')).to eq(true)
    end

    it 'returns false if there are no non defective cars with model in the factory' do
      expect(StockChecker.in_factory_stock?('test_model_1')).to eq(false)
    end
  end

  describe '.non_defective_cars' do
    it 'returns non defective cars in factory' do
      expect(StockChecker.non_defective_cars.size).to eq(4)
    end

    it 'does not include defective cars' do
      Car.in_factory.first.car_parts.create(defective: true)

      expect(StockChecker.non_defective_cars.size).to eq(3)
    end
  end

  describe '.in_store_stock?' do
    it 'returns true if there are cars with model in the store' do
      expect(StockChecker.in_store_stock?('test_model')).to eq(true)
    end

    it 'returns false if there are no cars with model in the factory' do
      expect(StockChecker.in_store_stock?('test_model_1')).to eq(false)
    end
  end
end
