class PrescriptionsController < ApplicationController
  before_action :set_prescription, only: [:show, :edit, :update, :destroy]
  before_action :load_associations, only: [:new, :edit, :create]

  def index
    @prescriptions = Prescription.includes(:patient, :doctor, :prescription_items)
                                  .order(created_at: :desc)
  end

  def show; end

  def new
    @prescription = Prescription.new
    @prescription_item = @prescription.prescription_items.build
  end

  def edit
    @prescription_item = @prescription.prescription_items.find(params[:id])
  end

  def create
    @prescription = Prescription.new(prescription_params)

    if @prescription.save
      redirect_to @prescription, notice: 'Prescription was successfully created.'
    else
      load_associations
      render :new, status: :unprocessable_entity
    end
  end

  def update
    if @prescription.update(prescription_params)
      redirect_to @prescription, notice: 'Prescription was successfully updated.'
    else
      load_associations
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @prescription.destroy
    redirect_to prescriptions_url, notice: 'Prescription was successfully deleted.'
  end

  private

  def set_prescription
    @prescription = Prescription.includes(:prescription_items).find(params[:id])
  end

  def load_associations
    @patients = Patient.order(:name)
    @doctors = Doctor.order(:name)
    @medications = Medication.order(:name)
    
    # Load dosages based on selected medication if present
    if params[:prescription] && params[:prescription][:prescription_items_attributes]
      medication_ids = params[:prescription][:prescription_items_attributes].values.map { |item| item[:medication_id] }.compact
      if medication_ids.any?
        @dosages = Dosage.joins(:medication_dosages)
                        .where(medication_dosages: { medication_id: medication_ids })
                        .distinct
                        .order(:frequency)
      else
        @dosages = Dosage.order(:frequency)
      end
    else
      @dosages = Dosage.order(:frequency)
    end
  end

  def prescription_params
    params.require(:prescription).permit(
      :patient_id,
      :doctor_id,
      prescription_items_attributes: [
        :id,
        :medication_id,
        :dosage_id,
        :duration,
        :_destroy
      ]
    )
  end
end
