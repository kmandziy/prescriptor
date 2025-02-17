module SeedHelpers
  class PriceCleaner
    def self.clean(price_string)
      price_string.gsub('$', '').to_f
    end
  end
end
