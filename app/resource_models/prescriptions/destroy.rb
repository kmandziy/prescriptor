module Prescriptions
  class Destroy
    include ActiveModel::Model

    attr_accessor :id
    
    validates :id, presence: true

    def persist!
      return false unless valid?
      
      prescription = Prescription.find(id)
      prescription.destroy!
    end
  end
end
