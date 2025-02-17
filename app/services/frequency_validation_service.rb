class FrequencyValidationService
  def initialize(frequency)
    @frequency = frequency
  end

  def valid?
    return false unless @frequency.present?
    Fugit::Cron.parse(@frequency).present?
  rescue
    false
  end
end
