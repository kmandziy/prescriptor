module SeedHelpers
  class DatabaseCleaner
    def self.clean
      puts "Cleaning database..."
      PrescriptionItem.destroy_all
      Prescription.destroy_all
      MedicationDosage.destroy_all
      Medication.destroy_all
      Dosage.destroy_all
    end
  end
end
