
  module Prescriptions
    class Create
      include ActiveModel::Model

      attr_accessor :patient_id, :doctor_id, :prescription_items_attributes
      
      validates :patient_id, :doctor_id, presence: true
      validate :prescription_items_present

      def persist!
        return false unless valid?

        ActiveRecord::Base.transaction do
          prescription = Prescription.create!(attributes)
          associate_items(prescription)
          prescription
        end
      end

      private

      def attributes
        {
          patient_id: patient_id,
          doctor_id: doctor_id
        }
      end

      def prescription_items_present
        return if prescription_items_attributes&.any?
        errors.add(:base, "At least one prescription item is required")
      end

      def associate_items(prescription)
        prescription_items_attributes.each do |_, item|
          next if item["_destroy"] == "1"
          
          prescription.prescription_items.create!(
            medication_id: item[:medication_id],
            dosage_id: item[:dosage_id],
            duration: item[:duration]
          )
        end
      end
    end
  end
