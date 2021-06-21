require 'rails_helper'

describe 'RobotWorld' do
  before(:all) do
    DatabaseCleaner.start
    Rails.application.load_seed
  end

  after(:all) { DatabaseCleaner.clean }

  before do
    allow(SlackNotifier).to receive(:post)
  end

  describe 'full flow with builder and guard robot' do
    it 'builds, moves, and alerts' do
      # First 30 minutes
      30.times { RobotService.start_builder }

      expect(Car.in_factory.count).to eq(300)
      expect(CarPart.where(defective: true)).not_to be_empty

      RobotService.do_guard_rounds

      expect(SlackNotifier).to have_received(:post)
      expect(StockOptimizer.get_store_stock.values.all? { |c| c == 5 }).to be(true)
    end
  end

  describe 'full flow for buyer' do
    before do
      30.times { RobotService.start_builder }
      RobotService.do_guard_rounds
    end

    it 'purchases and exchanges' do
      expect(Car.sold.count).to eq(0)

      10.times { RobotService.start_buyer }
      RobotService.do_guard_rounds

      expect(SlackNotifier).to have_received(:post).at_least(:once)
      expect(Car.sold.count).to be > 0

      stock_pre_exchange = StockOptimizer.get_store_stock.to_a.sort
      2.times { RobotService.buyer_exchange_orders }

      expect(StockOptimizer.get_store_stock.to_a.sort).not_to eq(stock_pre_exchange)
    end
  end

  describe 'end of day' do
    before (:all) do
      30.times { RobotService.start_builder }
      1.times { RobotService.do_guard_rounds }
      30.times { RobotService.start_buyer }
      2.times { RobotService.buyer_exchange_orders }
    end

    it 'builder wipes the factory' do
      expect(Car.in_factory.count).not_to eq(0)

      RobotService.wipe_factory

      expect(Car.in_factory.count).to eq(0)
    end

    it 'sold cars does not change' do
      sold_car_count = Car.sold.count

      RobotService.wipe_factory

      expect(Car.sold.count).to eq(sold_car_count)
    end

    it 'cars in store do not change' do
      store_car_count = Car.in_store.count

      RobotService.wipe_factory

      expect(Car.in_store.count).to eq(store_car_count)
    end
  end
end
