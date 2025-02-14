class MedicationDosage < ApplicationRecord
  belongs_to :medication
  belongs_to :dosage

  validates :medication_id, uniqueness: { scope: :dosage_id }
end
