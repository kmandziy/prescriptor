class CalculationsController < ApplicationController
  def index
    medication_ids = prescription_items_params.map { |item| item[:medication_id] }
    dosage_ids = prescription_items_params.map { |item| item[:dosage_id] }

    @medications = Medication.where(id: medication_ids)
    @dosages = Dosage.where(id: dosage_ids)

    total_cost = prescription_items_params.sum do |item|
      medication = @medications.find(item[:medication_id])
      dosage = @dosages.find(item[:dosage_id])
      duration = item[:duration]

      CalculationsService.total_cost(medication, dosage.frequency, duration.to_i)
    end
    
    render json: { total_cost: }
  rescue 
    render json: { total_cost: 0, error: 'Invalid parameters' }, status: :unprocessable_entity
  end

  private

  def prescription_items_params
    params.permit(prescription_items: [:medication_id, :dosage_id, :duration])[:prescription_items]
  end
end
