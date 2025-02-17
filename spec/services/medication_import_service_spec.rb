require 'rails_helper'
require Rails.root.join('lib/tasks/seed_helpers/price_cleaner')
require Rails.root.join('lib/tasks/seed_helpers/frequency_normalizer')
require 'csv'

RSpec.describe MedicationImportService, type: :service do
  let(:csv_content) do
    <<~CSV
      ID,Name,Unit Price,Dosage Amount,Frequency,Default Duration
      1,Paracetamol,10.50,500mg,twice a day,5 days
      ,,,250mg,once a day,3 days
      2,Ibuprofen,15.00,200mg,thrice a day,7 days
    CSV
  end

  let(:csv_path) { Rails.root.join('tmp', 'medications.csv') }

  before do
    File.open(csv_path, 'w') { |file| file.write(csv_content) }
    allow(SeedHelpers::PriceCleaner).to receive(:clean).and_return(10.50, 15.00)
    allow(SeedHelpers::FrequencyNormalizer).to receive(:normalize).and_return('0 9 * * *')
  end

  after do
    File.delete(csv_path) if File.exist?(csv_path)
  end

  subject { described_class.new(csv_path) }

  describe '#import' do
    it 'creates medications from CSV' do
      expect { subject.import }.to change { Medication.count }.by(2)
    end

    it 'creates dosages and associates them with medications' do
      expect { subject.import }.to change { Dosage.count }.by(2).and change { MedicationDosage.count }.by(2)
    end

    it 'skips rows without medication ID and name' do
      empty_row_csv = <<~CSV
        ID,Name,Unit Price,Dosage Amount,Frequency,Default Duration
        ,,,,
      CSV

      File.open(csv_path, 'w') { |file| file.write(empty_row_csv) }

      expect { subject.import }.not_to change { Medication.count }
    end
  end
end
