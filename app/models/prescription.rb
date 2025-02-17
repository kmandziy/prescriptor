class Prescription < ApplicationRecord
  belongs_to :patient
  belongs_to :doctor
  has_many :prescription_items, dependent: :destroy
  accepts_nested_attributes_for :prescription_items, 
                              allow_destroy: true, 
                              reject_if: :all_blank
                              
  has_many :medications, through: :prescription_items

  validates :patient_id, presence: true
  validates :doctor_id, presence: true
  validate :prescription_items_present

  before_save :set_total_cost

  def prescription_items_present
    return if prescription_items.any?

    errors.add(:prescription_items, "At least one prescription item is required")
  end

  def set_total_cost
    self.total_cost = prescription_items.sum(&:cost)
  end
end
