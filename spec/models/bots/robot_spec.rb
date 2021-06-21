require 'rails_helper'

RSpec.describe Bots::Robot, type: :model do
  it 'calls the specialized robot function' do
    robot = Bots::Robot.new(kind: 'guard')
    guard_bot = instance_double(Bots::Guard, call: true)

    allow(Bots::Guard).to receive(:new).and_return(guard_bot)
    robot.call

    expect(guard_bot).to have_received(:call)
  end
end
