class FrequencyService
  class << self
    def next_occurrences(frequency, count = 5)
      Fugit::Cron.parse(frequency)
        .next_times(count)
        .map(&:to_time)
    end

    def format_description(frequency)
      cron = Fugit::Cron.parse(frequency)
      return 'Invalid frequency' unless cron

      if daily_schedule?(cron)
        format_daily_description(cron.hours)
      else
        format_weekly_description(cron.weekdays, cron.hours)
      end
    end

    private

    def daily_schedule?(cron)
      cron.weekdays.nil? || cron.weekdays == [0, 1, 2, 3, 4, 5, 6]
    end

    def format_daily_description(hours)
      case hours.length
      when 1 then "Once daily"
      when 2 then "Twice daily"
      else "#{hours.length} times daily"
      end
    end

    def format_weekly_description(weekdays, hours)
      days = weekdays.map { |d| Date::DAYNAMES[d.to_i] }
      if hours.length == 1
        "Once weekly on #{days.to_sentence}"
      else
        "#{hours.length} times weekly on #{days.to_sentence}"
      end
    end

    def format_hour(hour, frequency)
      meridian = hour >= 12 ? 'PM' : 'AM'
      hour = hour % 12
      hour = 12 if hour == 0
      "#{hour}:#{format('%02d', Fugit::Cron.parse(frequency).minutes.first)} #{meridian}"
    end
  end
end
