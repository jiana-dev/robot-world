require 'rails_helper'

describe CarBuilderService do
  before(:all) { DatabaseCleaner.start }
  after(:all) { DatabaseCleaner.clean }

  let(:service) { CarBuilderService.new }

  describe "#build_car!" do
    it 'creates a car' do
      expect { service.build_car! }.to change(Car, :count).by(1)
    end

    describe 'assembly stages' do
      let(:car) do
        instance_double(
          Car,
          move_in_assembly_line!: true,
          finish_assembly!: true
        )
      end

      before do
        allow(Car).to receive(:create).and_return(car)
        allow(car).to receive(:car_parts).and_return(double(build: true))
      end

      it 'moves through the assembly line' do
        service.build_car!

        expect(car).to have_received(:move_in_assembly_line!).exactly(3).times
        expect(car).to have_received(:finish_assembly!).exactly(1).times
      end
    end

    describe 'car details' do
      let(:car) { service.build_car! }

      it 'has a random model' do
        expect(CarBuilderService::MODELS.include?(car.model)).to be(true)
      end

      it 'has a year' do
        expect(car.year).to eq(Time.zone.now.year)
      end

      it 'has parts' do
        expect(car.car_parts).not_to be_empty
      end

      it 'has defects based on DEFECT_CHANCE' do
        stub_const('BasicStructure::DEFECT_CHANCE', 1)
        stub_const('ElectronicDevices::DEFECT_CHANCE', 1)

        expect(car.car_parts.all? { |part| part.defective? }).to be(true)
      end
    end
  end
end
