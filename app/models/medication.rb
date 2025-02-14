class Medication < ApplicationRecord
  has_many :prescription_items
  has_many :prescriptions, through: :prescription_items
  has_many :medication_dosages
  has_many :dosages, through: :medication_dosages

  validates :name, presence: true, uniqueness: true
  validates :unit_price, presence: true, numericality: { greater_than_or_equal_to: 0 }

  def self.seed_from_csv(file_path)
    require 'csv'
    
    CSV.foreach(file_path, headers: true) do |row|
      medication = Medication.find_or_initialize_by(name: row['Name'])
      medication.update!(
        unit_price: row['Unit Price'].to_f,
      )

      # Create associated dosage if it doesn't exist
      dosage = Dosage.find_or_create_by!(
        amount: row['Dosage Amount'],
        frequency: row['Frequency'],
        default_duration: row['Default Duration']
      )

      # Associate medication with dosage
      MedicationDosage.find_or_create_by!(
        medication: medication,
        dosage: dosage
      )
    end
  end
end
