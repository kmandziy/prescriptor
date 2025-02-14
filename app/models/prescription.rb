class Prescription < ApplicationRecord
  belongs_to :patient
  belongs_to :doctor
  has_many :prescription_items, dependent: :destroy
  has_many :medications, through: :prescription_items

  validates :patient_id, presence: true
  validates :doctor_id, presence: true

  def total_cost
    prescription_items.sum(&:total_cost)
  end
end
