require 'rails_helper'

RSpec.describe Bots::Guard, type: :model do
  describe '#call' do
    let(:builder) { Bots::Robot.new(kind: 'builder') }

    it 'builds 10 cars' do
      expect { builder.call }.to change(Car, :count).by(10)
    end
  end
end
