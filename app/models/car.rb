class Car < ApplicationRecord
  COMPLETED_STATES = %w(in_factory in_store sold)
  ASSEMBLY_STAGES = %w(basic_structure_assembly electronic_assembly painting_and_final_details)
  LABOUR_COST = 100
  PROFIT_PERCENTAGE = 1.3

  has_many :car_parts, dependent: :destroy

  include AASM

  aasm column: :state do
    state :new, initial: true
    state :basic_structure_assembly
    state :electronic_assembly
    state :painting_and_final_details
    state :in_factory
    state :in_store
    state :sold

    event :move_in_assembly_line do
      transitions from: :new, to: :basic_structure_assembly
      transitions from: :basic_structure_assembly, to: :electronic_assembly
      transitions from: :electronic_assembly, to: :painting_and_final_details
    end

    event :finish_assembly do
      transitions from: :painting_and_final_details, to: :in_factory
    end

    event :to_store do
      transitions from: :in_factory, to: :in_store
      transitions from: :sold, to: :in_store
    end

    event :purchase do
      transitions from: :in_store, to: :sold
    end
  end

  def complete?
    COMPLETED_STATES.include?(state)
  end

  def current_assembly_stage
    return nil unless ASSEMBLY_STAGES.include?(state)

    state
  end

  def computer
    car_parts.find_by(name: 'computer')
  end

  def cost_price
    car_parts_cost = 0
    car_parts.each { |part| car_parts_cost += part.cost_price }

    car_parts_cost + LABOUR_COST
  end

  def price
    cost_price * PROFIT_PERCENTAGE
  end

  def revenue
    price - cost_price
  end
end
