require 'rails_helper'

RSpec.describe Bots::Guard, type: :model do
  before(:all) { DatabaseCleaner.start }
  after(:all) { DatabaseCleaner.clean }

  let(:robot) { Bots::Robot.new(kind: 'guard') }

  describe '#alert_for_defects' do
    before { allow(SlackNotifier).to receive(:post).and_return(true) }

    it 'sends Slack message with defects' do
      car = Car.create(model: 'test_model', year: 2021)
      car.car_parts.create(name: 'computer', defective: true)

      robot.call(:alert_for_defects)

      expected_defect_message = "Defective Car Parts Report:\n\n Car ID: #{car.id}, Model: #{car.model}, Defective Parts: "
      expected_defect_message += car.computer.defects.map(&:name).join(", ")

      expect(SlackNotifier).to have_received(:post).with(expected_defect_message)
    end

  end

  describe '#move_factory_stock_to_store!' do
    before do
      require 'stock_checker'

      stub_const('StockChecker::STORE_MAX', 2)
      store_stock = [instance_double(Car)]

      allow(StockChecker).to receive(:store_stock).and_return(store_stock, store_stock + [car])
      allow(StockOptimizer).to receive(:retrieve_car).and_return(car)
      allow(car).to receive(:to_store!)
    end

    let(:car) { instance_double(Car) }

    it 'moves factory stock to store up to store max' do
      robot.call(:move_factory_stock_to_store!)

      expect(car).to have_received(:to_store!)
    end
  end
end
