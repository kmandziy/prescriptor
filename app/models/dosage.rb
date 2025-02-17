class Dosage < ApplicationRecord
  has_many :medication_dosages
  has_many :medications, through: :medication_dosages
  has_many :prescription_items

  validates :amount, presence: true
  validates :frequency, presence: true
  validates :default_duration, presence: true
  validate :validate_frequency_format

  def frequency_description
    ::FrequencyService.format_description(frequency)
  end

  private

  def validate_frequency_format
    validator = FrequencyValidationService.new(frequency)
    errors.add(:frequency, 'must be a valid cron expression') unless validator.valid?
  end
end
