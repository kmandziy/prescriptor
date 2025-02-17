
  module Prescriptions
    class Create
      include ActiveModel::Model

      attr_accessor :patient_id, :doctor_id, :prescription_items_attributes
      
      attr_reader :prescription

      validates :patient_id, :doctor_id, presence: true
      validate :prescription_items_present

      def persist!
        @prescription = Prescription.new(**attributes, prescription_items_attributes:) 
        @prescription.save!
      end

      private

      def attributes
        {
          patient_id: patient_id,
          doctor_id: doctor_id
        }
      end
    end
  end
