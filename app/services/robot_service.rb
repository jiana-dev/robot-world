class RobotService
  def self.start_builder
    robot('builder').call(:build!)
  end

  def self.wipe_factory
    robot('builder').call(:wipe_out_stock!)
  end

  def self.do_guard_rounds
    robot('guard').call(:alert_for_defects)
    robot('guard').call(:move_factory_stock_to_store!)
  end

  def self.start_buyer
    robot('buyer').call(:buy!)
  end

  def self.buyer_exchange_orders
    robot('buyer').call(:exchange!)
  end

  def self.robot(kind)
    Bots::Robot.find_by(kind: kind)
  end
end
