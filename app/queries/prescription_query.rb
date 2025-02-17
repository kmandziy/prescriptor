class PrescriptionQuery
  def with_associations
    Prescription.includes(:patient, :doctor, :prescription_items)
  end

  def latest_first
    with_associations.order(created_at: :desc)
  end

  def find_with_items(id)
    Prescription.includes(:prescription_items).find(id)
  end
end
