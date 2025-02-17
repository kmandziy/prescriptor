module Prescriptions
  class Index
    include ActiveModel::Model

    attr_accessor :page, :per_page

    def fetch
      Prescription.includes(:patient, :doctor, :prescription_items)
                  .order(created_at: :desc)
                  .page(page)
                  .per(per_page || 25)
    end
  end
end
