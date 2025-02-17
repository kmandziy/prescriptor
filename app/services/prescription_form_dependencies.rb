class PrescriptionFormDependencies
  def initialize(params)
    @params = params
  end

  def patients
    Patient.order(:name)
  end

  def doctors
    Doctor.order(:name)
  end

  def medications
    Medication.order(:name)
  end

  def dosages
    if medication_ids.any?
      filtered_dosages
    else
      Dosage.order(:frequency)
    end
  end

  private

  def medication_ids
    return [] unless @params[:prescription]&.dig(:prescription_items_attributes)
    
    @params[:prescription][:prescription_items_attributes]
      .values
      .map { |item| item[:medication_id] }
      .compact
  end

  def filtered_dosages
    Dosage.joins(:medication_dosages)
          .where(medication_dosages: { medication_id: medication_ids })
          .distinct
          .order(:frequency)
  end
end
