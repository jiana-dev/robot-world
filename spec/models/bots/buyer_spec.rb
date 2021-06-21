require 'rails_helper'

RSpec.describe Bots::Buyer, type: :model do
  before(:all) { DatabaseCleaner.start }
  after(:all) { DatabaseCleaner.clean }

  let(:robot) { Bots::Robot.new(kind: 'buyer') }

  describe '#buy!' do
    before do
      5.times { Car.create(model: 'test_model', year: 2021, state: 'in_store') }
    end

    it 'places orders' do
      stub_const('Bots::Buyer::CARS_TO_BUY', [5])
      stub_const('CarBuilderService::MODELS', ['test_model'])

      expect { robot.call(:buy!) }.to change(Order, :count).by(5)
    end
  end

  describe '#exchange!' do
    before do
      stub_const('Bots::Buyer::CARS_TO_EXCHANGE', [1])
      stub_const('CarBuilderService::MODELS', ['test_model_exchange'])
    end

    let(:car) { Car.create(model: 'test_model', year: 2021, state: 'in_store') }

    context 'when new model is in stock' do
      it 'exchanges order' do
        order = Order.place!(car)
        new_car = Car.create(model: 'test_model_exchange', year: 2021, state: 'in_store')

        robot.call(:exchange!)

        expect(order.reload.car).to eq(new_car)
      end
    end

    context 'when new model is not in stock' do
      before { allow(SlackNotifier).to receive(:post).and_return(true) }

      it 'alerts Slack and does not change car' do
        order = Order.place!(car)

        robot.call(:exchange!)

        expect(SlackNotifier).to have_received(:post)
        expect(order.reload.car).to eq(car)
      end
    end
  end
end
