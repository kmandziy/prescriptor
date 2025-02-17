# app/controllers/dosages_controller.rb
class DosagesController < ApplicationController
  before_action :set_medication, only: [:index]

  def index
    @dosages = @medication.dosages
    
    render json: @dosages.map { |dosage| 
      {
        id: dosage.id,
        amount: dosage.amount,
        frequency: dosage.frequency,
        default_duration: dosage.default_duration,
        display_text: "#{dosage.amount} - #{dosage.frequency_description}"
      }
    }
  end

  private

  def set_medication
    @medication = Medication.find(params[:medication_id])
  rescue ActiveRecord::RecordNotFound
    render json: { error: 'Medication not found' }, status: :not_found
  end
end
