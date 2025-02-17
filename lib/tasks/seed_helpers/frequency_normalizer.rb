module SeedHelpers
  class FrequencyNormalizer
    FREQUENCY_MAPPINGS = {
      'once daily' => '0 9 * * *',      # Every day at 9 AM
      'twice daily' => '0 9,21 * * *',   # Every day at 9 AM and 9 PM
      'once weekly' => '0 9 * * MON'     # Every Monday at 9 AM
    }.freeze

    DEFAULT_FREQUENCY = '0 9 * * *'  # Default to once daily at 9 AM

    def self.normalize(frequency)
      return nil if frequency.nil?
      
      normalized = frequency.strip.downcase
      FREQUENCY_MAPPINGS[normalized] || DEFAULT_FREQUENCY
    end
  end
end
