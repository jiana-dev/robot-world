require 'rails_helper'

RSpec.describe Bots::Builder, type: :model do
  before(:all) { DatabaseCleaner.start }
  after(:all) { DatabaseCleaner.clean }

  let(:robot) { Bots::Robot.new(kind: 'builder') }

  describe '#build!' do
    it 'builds 10 cars' do
      expect { robot.call(:build!) }.to change(Car, :count).by(10)
    end
  end

  describe '#wipe_out_stock!' do
    before { robot.call(:build!) }

    it 'builds 10 cars' do
      expect { robot.call(:wipe_out_stock!) }.to change(Car, :count).by(-10)
    end
  end
end
