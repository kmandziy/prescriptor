
module Prescriptions
  class Update
    include ActiveModel::Model

    attr_accessor :id, :patient_id, :doctor_id, :prescription_items_attributes
    
    validates :id, :patient_id, :doctor_id, presence: true
    validate :prescription_items_present

    def persist!
      return false unless valid?
      
      prescription = Prescription.find(id)
      
      ActiveRecord::Base.transaction do
        prescription.update!(attributes)
        update_items(prescription)
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

    def update_items(prescription)
      prescription_items_attributes.each do |_, item|
        if item["id"].present?
          if item["_destroy"] == "1"
            prescription.prescription_items.find(item["id"]).destroy!
          else
            prescription.prescription_items.find(item["id"]).update!(item.except("id", "_destroy"))
          end
        else
          next if item["_destroy"] == "1"
          prescription.prescription_items.create!(item.except("_destroy"))
        end
      end
    end
  end
end
