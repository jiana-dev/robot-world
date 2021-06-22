require 'rails_helper'

RSpec.describe DailyReport do
  describe 'instance methods' do
    before do
      allow(Order).to receive(:where).and_return(orders_stub)
    end

    let(:orders_stub) do
      [
        instance_double(Order, revenue: 400, value: 1000),
        instance_double(Order, revenue: 300, value: 1000),
        instance_double(Order, revenue: 200, value: 1000)
      ]
    end

    let(:report) { DailyReport.new }

    describe '#revenue' do
      it 'returns the sum of all the orders revenues' do
        expect(report.revenue).to eq(orders_stub.sum(&:revenue))
      end
    end

    describe '#cars_sold' do
      it 'returns the number of cars sold' do
        expect(report.cars_sold).to eq(orders_stub.size)
      end
    end

    describe '#average_order_value' do
      it 'returns the average of all the orders values' do
        expect(report.average_order_value).to eq(orders_stub.sum(&:value) / orders_stub.size)
      end
    end
  end

  describe 'getting report for certain day' do
    before(:all) { DatabaseCleaner.start }
    after(:all) { DatabaseCleaner.clean }

    it 'only returns orders made on the date' do
      Order.create(created_at: Date.new(2021,6,20), car: Car.create)
      Order.create(created_at: Date.new(2021,6,21), car: Car.create)

      report = DailyReport.new(date: Date.new(2021,6,21))

      expect(report.cars_sold).to eq(1)
    end
  end
end
