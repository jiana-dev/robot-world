class RobotService

  def self.start_builder
    robot('builder').call
  end

  def self.wipe_factory
    robot('builder').wipe_out_stock
  end

  def self.do_guard_rounds
    robot('guard').call
  end

  def self.start_buyer
    robot('buyer').call
  end

  def self.buyer_exchange_orders
    robot('buyer').exchange_cars!
  end

  def self.robot(kind)
    Robot.find(kind: kind)
  end
end
