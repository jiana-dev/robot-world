require 'rails_helper'

RSpec.describe Order, type: :model do
  describe '.place!' do
    before do
      allow(Order).to receive(:create!).and_return(true)
      Order.place!(car)
    end

    let(:car) { Car.new(state: 'in_store') }

    it 'moves the car to sold' do
      expect(car.sold?).to be(true)
    end

    it 'creates a new order' do
      expect(Order).to have_received(:create!).with(car: car)
    end
  end

  describe '.update!' do
    before do
      allow(order_to_exchange).to receive(:update!).and_return(true)
      Order.exchange!(order_to_exchange, car)
    end

    let(:order_to_exchange) { Order.new }
    let(:car) { Car.new(state: 'in_store') }

    it 'moves the car to sold' do
      expect(car.sold?).to be(true)
    end

    it 'creates a new order' do
      expect(order_to_exchange).to have_received(:update!).with(car: car)
    end
  end

  describe '#revenue' do
    before { allow(order).to receive(:car).and_return(car) }

    let(:car) { instance_double(Car, revenue: 300) }
    let(:order) { Order.new }

    it 'returns the car revenue' do
      expect(order.revenue).to eq(car.revenue)
    end
  end

  describe '#value' do
    before { allow(order).to receive(:car).and_return(car) }

    let(:car) { instance_double(Car, price: 1000) }
    let(:order) { Order.new }

    it 'returns the car price' do
      expect(order.value).to eq(car.price)
    end
  end
end
