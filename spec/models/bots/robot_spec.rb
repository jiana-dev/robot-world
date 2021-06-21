require 'rails_helper'

RSpec.describe Bots::Robot, type: :model do
  it 'calls the specialized robot function' do
    robot = Bots::Robot.new(kind: 'guard')
    guard_bot = instance_double(Bots::Guard, alert_for_defects: true)

    allow(Bots::Guard).to receive(:new).and_return(guard_bot)
    robot.call(:alert_for_defects)

    expect(guard_bot).to have_received(:alert_for_defects)
  end
end
