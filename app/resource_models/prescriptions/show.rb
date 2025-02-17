module Prescriptions
  class Show
    include ActiveModel::Model

    attr_accessor :id
    
    validates :id, presence: true

    def fetch
      Prescription.includes(:patient, :doctor, :prescription_items)
                  .find(id)
    end
  end
end
