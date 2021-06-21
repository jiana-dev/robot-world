require 'rails_helper'

describe CarBuilderService do
  describe "#build_car!" do
    it 'creates a car' do
      expect { CarBuilderService.new.build_car! }.to change(Car, :count).by(1)
    end

    describe 'build assembly stages' do
      let(:car) { instance_double(Car, move_in_assembly_line!: true, finish_assembly!: true) }

      before do
        allow(Car).to receive(:create).and_return(car)
        allow(car).to receive_message_chain(:car_parts, :build).and_return(true) # OPTIMIZE: Message chain?
      end

      it 'moves through the assembly line' do
        CarBuilderService.new.build_car!
        expect(car).to have_received(:move_in_assembly_line!).exactly(3).times
        expect(car).to have_received(:finish_assembly!).exactly(1).times
      end
    end

    describe 'car details' do
      let(:car) { CarBuilderService.new.build_car! }

      it 'has a random model' do
        expect(CarBuilderService::MODELS.include?(car.model)).to be(true)
      end

      it 'has a year' do
        expect(car.year).to eq(2021)
      end

      it 'has parts' do
        expect(car.car_parts).not_to be_empty
      end

      it 'has defects' do
        stub_const('BasicStructure::DEFECT_CHANCE', 1)
        stub_const('ElectronicDevices::DEFECT_CHANCE', 1)

        expect(car.car_parts.all? { |part| part.defective? }).to be(true)
      end
    end
  end
end
