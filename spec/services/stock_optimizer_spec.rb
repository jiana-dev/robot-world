require 'rails_helper'
require 'helpers/car_helper'

RSpec.describe StockOptimizer do
  include CarHelper

  before(:all) do
    DatabaseCleaner.start

    2.times { create_car_with_computer(state: 'in_factory', model: 'popular') }
    2.times { create_car_with_computer(state: 'in_factory', model: 'cool') }
    4.times { create_car_with_computer(state: 'in_store', model: 'popular') }
    2.times { create_car_with_computer(state: 'in_store', model: 'cool') }
    1.times { create_car_with_computer(state: 'in_store', model: 'new') }
  end

  after(:all) { DatabaseCleaner.clean }

  before { stub_const('CarBuilderService::MODELS', ['popular', 'cool', 'new']) }

  describe '.retrieve_car' do
    it 'returns car that has the lowest stock in the store and available in the factory' do
      expect(StockOptimizer.retrieve_car.model).to eq('cool')
    end
  end

  describe '.get_store_stock' do
    it 'returns a hash of the store stock with model as keys and count as values' do
      expected_stock = {
        'popular' => 4,
        'cool' => 2,
        'new' => 1
      }.to_a.sort

      expect(StockOptimizer.get_store_stock.to_a.sort).to eq(expected_stock)
    end
  end
end
