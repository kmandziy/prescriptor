# db/seeds.rb

# First, clear existing data
puts "Cleaning database..."
PrescriptionItem.destroy_all
Prescription.destroy_all
MedicationDosage.destroy_all
Medication.destroy_all
Dosage.destroy_all

puts "Creating medications and dosages..."

require 'csv'

# Method to clean price string
def clean_price(price_string)
  price_string.gsub('$', '').to_f
end

# Method to normalize frequency
def normalize_frequency(freq)
  return nil if freq.nil?
  
  freq = freq.strip.downcase
  case freq
  when 'once daily'
    'once daily'
  when 'twice daily'
    'twice daily'
  when 'once weekly'
    'once daily'  # Convert to daily equivalent or handle as needed
  else
    'once daily'  # Default fallback
  end
end

# Store current medication to handle multiple dosages
current_medication = nil

CSV.foreach(Rails.root.join('db', 'medications_data', 'data.csv'), headers: true) do |row|
  next if row['Name'].nil? && row['ID'].nil?  # Skip empty rows

  if row['ID'].present?
    # Create new medication when ID is present
    current_medication = Medication.create!(
      name: row['Name'],
      unit_price: clean_price(row['Unit Price'])
    )
    puts "Created medication: #{current_medication.name}"
  end

  # Skip if no dosage amount
  next if row['Dosage Amount'].nil?

  # Create or find dosage
  dosage = Dosage.find_or_create_by!(
    amount: row['Dosage Amount'],
    frequency: normalize_frequency(row['Frequency']),
    default_duration: row['Default Duration']
  )

  # Create medication_dosage association
  MedicationDosage.create!(
    medication: current_medication,
    dosage: dosage
  )
  puts "Added dosage #{dosage.amount} #{dosage.frequency} to #{current_medication.name}"
end

# Print summary
puts "\nSeeding completed!"
puts "Created #{Medication.count} medications"
puts "Created #{Dosage.count} dosages"
puts "Created #{MedicationDosage.count} medication-dosage associations"
