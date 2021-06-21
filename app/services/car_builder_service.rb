class CarBuilderService
  attr_reader :car

  MODELS = %w(mazda_scrum isuzu_mysterious_utility_wizard ford_probe honda_joy_machine tang_hua_detroit_fish
              volkswagen_thing toyota_deliboy amc_gremlin mitsubishi_lettuce honda_life_dunk)
  YEAR = Time.zone.now.year

  def build_car!
    @car = Car.create(model: MODELS.sample, year: YEAR)

    assemble!(BasicStructure)
    assemble!(ElectronicDevices)
    assemble!(FinalDetails)

    car.finish_assembly!
    car
  end

  private

  def assemble!(assembly_stage)
    parts_hash = assembly_stage::PARTS_CATALOG
    defect_chance = assembly_stage::DEFECT_CHANCE

    parts_hash.each do |part, cost_price|
      car.car_parts.build(name: part, cost_price: cost_price, defective: rand() <= defect_chance)
    end

    car.move_in_assembly_line!
  end
end

class BasicStructure
  DEFECT_CHANCE = 0.1
  PARTS_CATALOG = {
    left_front_wheel: 500,
    right_front_wheel: 500,
    left_back_wheel: 500,
    right_back_wheel: 500,
    chassis: 500,
    engine: 500,
    driver_seat: 500,
    passenger_seat: 500
  }
end

class ElectronicDevices
  DEFECT_CHANCE = 0.2
  PARTS_CATALOG = {
    computer: 1000,
    laser: 500
  }
end

class FinalDetails
  PARTS_CATALOG = {}
  DEFECT_CHANCE = 0
end
