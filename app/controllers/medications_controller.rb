class MedicationsController < ApplicationController
  def index
    @medications = Medication.includes(:dosages).all
  end

  def show
    @medication = Medication.includes(:dosages).find(params[:id])
  end
end
