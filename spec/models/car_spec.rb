require 'rails_helper'

RSpec.describe Car, type: :model do
  let(:car) { Car.new }

  describe 'states' do
    context 'when in new' do
      it 'can be moved in assembly line to basic structure assembly' do
        car.move_in_assembly_line
        expect(car.state).to eq('basic_structure_assembly')
      end

      it 'is not complete' do
        expect(car.complete?).to be(false)
      end

      it 'has no current assembly stage' do
        expect(car.current_assembly_stage).to be_nil
      end

      it 'cannot go to any other state' do
        expect { car.purchase }.to raise_error(AASM::InvalidTransition)
      end
    end

    context 'when moving in assembly line' do
      it 'moves through assembly line stages' do
        car.move_in_assembly_line
        expect(car.state).to eq('basic_structure_assembly')

        car.move_in_assembly_line
        expect(car.state).to eq('electronic_assembly')

        car.move_in_assembly_line
        expect(car.state).to eq('painting_and_final_details')
      end

      it 'is not complete' do
        car.move_in_assembly_line
        expect(car.complete?).to be(false)

        car.move_in_assembly_line
        expect(car.complete?).to be(false)

        car.move_in_assembly_line
        expect(car.complete?).to be(false)
      end

      it 'returns the current assembly stage' do
        car.move_in_assembly_line
        expect(car.current_assembly_stage).to eq('basic_structure_assembly')

        car.move_in_assembly_line
        expect(car.current_assembly_stage).to eq('electronic_assembly')

        car.move_in_assembly_line
        expect(car.current_assembly_stage).to eq('painting_and_final_details')
      end
    end

    context 'when in painting and final_details' do
      before do
        car.move_in_assembly_line
        car.move_in_assembly_line
        car.move_in_assembly_line
      end

      it 'can go to factory through finish assembly' do
        car.finish_assembly
        expect(car.state).to eq('in_factory')
      end

      it 'is not complete' do
        expect(car.complete?).to be(false)
      end

      it 'has current assembly stage painting and final details' do
        expect(car.current_assembly_stage).to eq('painting_and_final_details')
      end

      it 'cannot go to any other state' do
        expect { car.purchase }.to raise_error(AASM::InvalidTransition)
      end
    end

    context 'when in factory' do
      before do
        car.move_in_assembly_line
        car.move_in_assembly_line
        car.move_in_assembly_line
        car.finish_assembly
      end

      it 'can go to store' do
        car.to_store
        expect(car.state).to eq('in_store')
      end

      it 'is complete' do
        expect(car.complete?).to be(true)
      end

      it 'cannot go to any other state' do
        expect { car.finish_assembly }.to raise_error(AASM::InvalidTransition)
      end
    end

    context 'when in store' do
      before do
        car.move_in_assembly_line
        car.move_in_assembly_line
        car.move_in_assembly_line
        car.finish_assembly
        car.to_store
      end

      it 'can go to sold through purchase' do
        car.purchase
        expect(car.state).to eq('sold')
      end

      it 'is complete' do
        expect(car.complete?).to be(true)
      end

      it 'has no current assembly stage' do
        expect(car.current_assembly_stage).to be_nil
      end

      it 'cannot go to any other state' do
        expect { car.move_in_assembly_line }.to raise_error(AASM::InvalidTransition)
      end
    end

    context 'when in sold' do
      before do
        car.move_in_assembly_line
        car.move_in_assembly_line
        car.move_in_assembly_line
        car.finish_assembly
        car.to_store
        car.purchase
      end

      it 'can go back to store' do
        car.to_store
        expect(car.state).to eq('in_store')
      end

      it 'is complete' do
        expect(car.complete?).to be(true)
      end

      it 'has no current assembly stage' do
        expect(car.current_assembly_stage).to be_nil
      end

      it 'cannot go to any other state' do
        expect { car.purchase }.to raise_error(AASM::InvalidTransition)
      end
    end
  end

  describe '#computer' do
    before do
      relation = CarPart.all
      allow(relation).to receive(:find_by).and_return(computer)
      allow(car).to receive(:car_parts).and_return(relation)
    end

    let(:computer) { instance_double(CarPart, name: 'computer') }

    it 'returns computer car part' do
      expect(car.computer).to eq(computer)
    end
  end

  describe '#cost_price' do
    before do
      car_parts = [
        instance_double(CarPart, cost_price: 500),
        instance_double(CarPart, cost_price: 500),
        instance_double(CarPart, cost_price: 500)
      ]
      allow(car).to receive(:car_parts).and_return(car_parts)
    end

    it 'returns the price of all parts + labour' do
      expect(car.cost_price).to eq(1500 + Car::LABOUR_COST)
    end

  end

  describe '#price' do
    it 'returns the cost_price plus PROFIT_PERCENTAGE' do
      car_cost = 1000
      allow(car).to receive(:cost_price).and_return(car_cost)

      expect(car.price).to eq(car_cost * Car::PROFIT_PERCENTAGE)
    end
  end

  describe '#revenue' do
    it 'returns the price - cost_price' do
      car_cost = 1000
      allow(car).to receive(:cost_price).and_return(car_cost)

      car_price = 1300
      allow(car).to receive(:price).and_return(car_price)

      expect(car.revenue).to eq(car_price - car_cost)
    end
  end
end
