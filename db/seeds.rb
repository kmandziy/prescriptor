require_relative '../lib/tasks/seed_helpers/database_cleaner'
require_relative '../lib/tasks/seed_helpers/frequency_normalizer'
require_relative '../lib/tasks/seed_helpers/price_cleaner'

csv_path = Rails.root.join('db', 'medications_data', 'data.csv')

SeedHelpers::DatabaseCleaner.clean
MedicationImportService.new(csv_path).import
