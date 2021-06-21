require 'rails_helper'

RSpec.describe CarPart, type: :model do
  before(:all) do
    DatabaseCleaner.start
  end

  after(:all) do
    DatabaseCleaner.clean
  end

  describe '#defects' do
    context 'when part is a computer' do
      it 'returns defects' do
        car = Car.create
        car.car_parts.create(name: 'wheel', defective: true)
        computer = CarPart.new(car: car, name: 'computer')

        expect(computer.defects.first.name).to eq('wheel')
      end
    end

    context 'when part is not computer' do
      it 'returns nil' do
        part = CarPart.new(name: 'wheel')

        expect(part.defects).to be_nil
      end
    end
  end
end
