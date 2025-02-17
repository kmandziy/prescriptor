class PrescriptionsController < ApplicationController
  def index
    resource =Prescriptions::Index.new(index_params)
    @prescriptions = resource.fetch
  end

  def show
    resource = Prescriptions::Show.new(id: params[:id])
    @prescription = resource.fetch
  end

  def new
    @prescription = Prescription.new
    @prescription.prescription_items.build
    load_form_dependencies
  end

  def create
    resource = Prescriptions::Create.new(prescription_params)
    
    if prescription = resource.persist!
      redirect_to prescription, notice: 'Prescription was successfully created.'
    else
      @prescription = Prescription.new(prescription_params)
      flash.now[:alert] = resource.errors.full_messages
      load_form_dependencies
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    resource = Prescriptions::Show.new(id: params[:id])
    @prescription = resource.fetch
    load_form_dependencies
  end

  def update
    resource = Prescriptions::Update.new(prescription_params.merge(id: params[:id]))
    
    if prescription = resource.persist!
      redirect_to prescription, notice: 'Prescription was successfully updated.'
    else
      @prescription = Prescription.find(params[:id])
      flash.now[:alert] = resource.errors.full_messages
      load_form_dependencies
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    resource Prescriptions::Destroy.new(id: params[:id])
    
    if resource.persist!
      redirect_to prescriptions_url, notice: 'Prescription was successfully deleted.'
    else
      redirect_to prescriptions_url, alert: 'Unable to delete prescription.'
    end
  end

  private

  def load_form_dependencies
    @patients = Patient.order(:name)
    @doctors = Doctor.order(:name)
    @medications = Medication.order(:name)
    @dosages = Dosage.order(:frequency)
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

  def index_params
    params.permit(:page, :per_page)
  end
end
