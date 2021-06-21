module Bots
  class Robot < ApplicationRecord
    self.table_name = 'robots'

    def call
      specialized_robot.call
    end

    private

    def specialized_robot
      "Bots::#{kind.classify}".constantize.new
    end
  end
end
