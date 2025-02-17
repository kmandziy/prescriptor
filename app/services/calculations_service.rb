class CalculationsService
  class << self
    def total_cost(medication, frequency, duration_days)
      return 0 unless valid_inputs?(medication, frequency, duration_days)

      daily_doses = calculate_daily_doses(frequency)
      medication.unit_price * daily_doses * duration_days
    end

    def monthly_cost(medication, frequency)
      total_cost(medication, frequency, 30)
    end

    def yearly_cost(medication, frequency)
      total_cost(medication, frequency, 365)
    end

    private

    def valid_inputs?(medication, frequency, duration_days)
      return false if medication.nil? || !medication.respond_to?(:unit_price)
      return false if frequency.nil? || !valid_cron?(frequency)
      return false if duration_days.nil? || duration_days <= 0

      true
    end

    def valid_cron?(frequency)
      !Fugit::Cron.parse(frequency).nil?
    rescue StandardError
      false
    end

    def calculate_daily_doses(frequency)
      cron = Fugit::Cron.parse(frequency)
      return 0 unless cron

      if daily_schedule?(cron)
        cron.hours.length
      else
        calculate_weekly_average_doses(cron)
      end
    end

    def daily_schedule?(cron)
      cron.weekdays.nil? || cron.weekdays == [0, 1, 2, 3, 4, 5, 6]
    end

    def calculate_weekly_average_doses(cron)
      weekly_days = cron.weekdays.flatten.length
      doses_per_day = cron.hours.length
      (weekly_days * doses_per_day) / 7.0
    end
  end
end
