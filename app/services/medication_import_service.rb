require 'csv'

class MedicationImportService
  def initialize(csv_path)
    @csv_path = csv_path
    @current_medication = nil
  end

  def import
    CSV.foreach(@csv_path, headers: true) do |row|
      next if skip_row?(row)
      
      process_row(row)
    end
    
    print_summary
  end

  private

  def skip_row?(row)
    row['Name'].nil? && row['ID'].nil?
  end

  def process_row(row)
    if row['ID'].present?
      create_medication(row)
    end

    create_dosage(row) if row['Dosage Amount'].present?
  end

  def create_medication(row)
    @current_medication = Medication.create!(
      name: row['Name'],
      unit_price: SeedHelpers::PriceCleaner.clean(row['Unit Price'])
    )
    puts "Created medication: #{@current_medication.name}"
  end

  def create_dosage(row)
    dosage = Dosage.find_or_create_by!(
      amount: row['Dosage Amount'],
      frequency: SeedHelpers::FrequencyNormalizer.normalize(row['Frequency']),
      default_duration: row['Default Duration']
    )

    MedicationDosage.create!(
      medication: @current_medication,
      dosage: dosage
    )
    
    puts "Added dosage #{dosage.amount} #{dosage.frequency} to #{@current_medication.name}"
  end

  def print_summary
    puts "\nSeeding completed!"
    puts "Created #{Medication.count} medications"
    puts "Created #{Dosage.count} dosages"
    puts "Created #{MedicationDosage.count} medication-dosage associations"
  end
end
