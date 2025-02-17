class PrescriptionItemsController < ApplicationController
  before_action :set_prescription

  def index
    @prescription_items = @prescription.prescription_items
  end

  def new
    @prescription_item = @prescription.prescription_items.build
  end

  def edit
    @prescription_item = @prescription.prescription_items.find(params[:id])
  end

  def create
    @prescription_item = @prescription.prescription_items.build(prescription_item_params)

    if @prescription_item.save
      redirect_to prescription_path(@prescription), notice: 'Prescription item was successfully created.'
    else
      render :new, status: :unprocessable_entity
    end
  end

  def update
    @prescription_item = @prescription.prescription_items.find(params[:id])

    if @prescription_item.update(prescription_item_params)
      redirect_to prescription_path(@prescription), notice: 'Prescription item was successfully updated.'
    else
      render :edit, status: :unprocessable_entity
    end
  end

  private

  def set_prescription
    @prescription = Prescription.find(params[:prescription_id]) || Prescription.new
  end

  def prescription_item_params
    params.require(:prescription_item).permit(:quantity, :medicine_id, :dosage, :frequency)
  end
end
