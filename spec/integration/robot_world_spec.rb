require 'rails_helper'

xdescribe 'RobotWorld' do
  before(:all) do
    DatabaseCleaner.start
    Rails.application.load_seed
  end

  after(:all) { DatabaseCleaner.clean }

  describe 'full flow with builder and guard robot' do
    before { allow(SlackNotifier).to receive(:post) }

    it 'builds, moves, and alerts' do
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
      allow(SlackNotifier).to receive(:post)

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
    before do
      allow(SlackNotifier).to receive(:post)

      30.times { RobotService.start_builder }
      1.times { RobotService.do_guard_rounds }
      30.times { RobotService.start_buyer }
      2.times { RobotService.buyer_exchange_orders }
    end

    it 'wipes the factory and leaves the purchased and in-store cars' do
      sold_car_count = Car.sold.count
      store_car_count = Car.in_store.count

      RobotService.wipe_factory

      expect(Car.in_factory.count).to eq(0)
      expect(Car.sold.count).to eq(sold_car_count)
      expect(Car.in_store.count).to eq(store_car_count)
    end

    it 'has the correct values on the daily report' do
      report = DailyReport.new

      expect(report.revenue).to eq(Order.all.sum(&:revenue))
      expect(report.cars_sold).to be <= 50
      expect(report.average_order_value).to eq(Order.all.sum(&:value) / Order.count)
    end
  end
end
