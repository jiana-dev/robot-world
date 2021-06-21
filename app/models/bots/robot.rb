module Bots
  class Robot < ApplicationRecord
    self.table_name = 'robots'

    def call(method)
      specialized_robot.public_send(method)
    end

    private

    def specialized_robot
      "Bots::#{kind.classify}".constantize.new
    end
  end
end
