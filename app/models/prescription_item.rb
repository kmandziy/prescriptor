class PrescriptionItem < ApplicationRecord
  belongs_to :prescription
  belongs_to :medication
  belongs_to :dosage

  validates :duration, presence: true, numericality: { greater_than: 0 }
  validates :medication_id, uniqueness: { scope: :prescription_id }
  validate :dosage_must_be_available_for_medication
  validate :medication_should_be_present

  after_validation :set_cost

  private

  def dosage_must_be_available_for_medication
    unless medication&.dosages&.include?(dosage)
      errors.add(:dosage, "is not available for this medication")
    end
  end

  def medication_should_be_present
    unless medication.present?
      errors.add(:medication, "is not present")
    end
  end

  def set_cost
    return if medication.blank? || dosage.blank? || duration.blank?
    
    self.cost = CalculationsService.total_cost(medication, dosage.frequency, duration)
  end
end
