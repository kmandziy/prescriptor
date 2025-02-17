
module Prescriptions
  class Update
    include ActiveModel::Model

    attr_accessor :id, :patient_id, :doctor_id, :prescription_items_attributes, :prescription
    
    validates :id, :patient_id, :doctor_id, presence: true
    validate :prescription_items_present

    def persist!
      @prescription = Prescription.find(id)
      
      ActiveRecord::Base.transaction do
        @prescription.assign_attributes(**attributes, prescription_items_attributes:)
        @prescription.save!
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
  end
end
