require 'rails_helper'

RSpec.describe Bots::Buyer, type: :model do
  describe '#call' do
    let(:robot) { Bots::Robot.new(kind: 'buyer') }

    before do
      5.times do
        Car.create(model: 'test_model', year: 2021, state: 'in_store')
      end
    end

    it 'places orders' do
      stub_const('Bots::Buyer::CARS_TO_BUY', [5])
      stub_const('CarBuilderService::MODELS', ['test_model'])

      expect { robot.call }.to change(Order, :count).by(5)
    end
  end
end
