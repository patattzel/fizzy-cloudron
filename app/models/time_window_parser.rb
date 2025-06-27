class TimeWindowParser
  attr_reader :now

  class << self
    def parse(string)
      new.parse(string)
    end
  end

  def initialize(now: Time.current)
    @now = now
  end

  def parse(string)
    case normalize(string)
    when "today"
      now.beginning_of_day..now.end_of_day
    when "yesterday"
      (now - 1.day).beginning_of_day..(now - 1.day).end_of_day
    when "thisweek"
      now.beginning_of_week..now.end_of_week
    when "thismonth"
      now.beginning_of_month..now.end_of_month
    when "thisyear"
      now.beginning_of_year..now.end_of_year
    when "lastweek"
      (now - 1.week).beginning_of_week..(now - 1.week).end_of_week
    when "lastmonth"
      (now - 1.month).beginning_of_month..(now - 1.month).end_of_month
    when "lastyear"
      (now - 1.year).beginning_of_year..(now - 1.year).end_of_year
    end
  end

  private
    def normalize(string)
      if string
        string.downcase.gsub(/[\s_\-]/, "")
      end
    end
end
