class Dosage < ApplicationRecord
  has_many :medication_dosages
  has_many :medications, through: :medication_dosages
  has_many :prescription_items

  validates :amount, presence: true
  validates :frequency, presence: true
  validates :default_duration, presence: true

  # Predefined frequencies
  FREQUENCIES = [
    'once daily',
    'twice daily',
    'three times daily',
    'four times daily',
    'as needed'
  ]

  validates :frequency, inclusion: { in: FREQUENCIES }
end
