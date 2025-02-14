class PrescriptionItem < ApplicationRecord
  belongs_to :prescription
  belongs_to :medication
  belongs_to :dosage

  validates :duration, presence: true, numericality: { greater_than: 0 }
  validates :medication_id, uniqueness: { scope: :prescription_id }
  validate :dosage_must_be_available_for_medication

  before_validation :set_default_duration, on: :create

  def total_cost
    daily_doses = case dosage.frequency
                 when 'once daily' then 1
                 when 'twice daily' then 2
                 when 'three times daily' then 3
                 when 'four times daily' then 4
                 else 1 # default for 'as needed'
                 end

    medication.unit_price * daily_doses * duration
  end

  private

  def dosage_must_be_available_for_medication
    unless medication.dosages.include?(dosage)
      errors.add(:dosage, "is not available for this medication")
    end
  end

  def set_default_duration
    self.duration ||= dosage.default_duration.to_i if dosage
  end
end
