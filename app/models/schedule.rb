# Opening hours for each day of the week, stored as JSON in the database:
#   { "1" => [["09:00", "12:00"], ["14:00", "17:00"]], "4" => [["10:00", "16:00"]] }
# (1 = Monday … 7 = Sunday, at most 2 time ranges per day). An empty schedule means "not given".
class Schedule
  DAYS = { 1 => "lundi", 2 => "mardi", 3 => "mercredi", 4 => "jeudi", 5 => "vendredi", 6 => "samedi", 7 => "dimanche" }.freeze
  RANGES_PER_DAY = 2
  STEP = 15 # minutes between two times in the menus
  FIRST_TIME = 6 * 60
  LAST_TIME = 22 * 60
  # "06:00", "06:15" … "22:00"
  TIMES = (FIRST_TIME..LAST_TIME).step(STEP).map { |minutes| format("%02d:%02d", minutes / 60, minutes % 60) }.freeze

  attr_reader :days

  def initialize(days)
    @days = (days || {}).to_h.transform_keys(&:to_s).select { |_day, ranges| ranges.present? }
  end

  # From the form (see app/views/shared/_schedule_fields.html.erb):
  #   { "1" => { "open" => "1", "ranges" => { "0" => { "from" => "09:00", "to" => "12:00" }, "1" => { … } } }, … }
  # Only the known keys are read. Ranges left empty are ignored; half-filled ones are kept, and refused by #errors.
  def self.from_form(params)
    days = DAYS.keys.each_with_object({}) do |day, result|
      day_params = params&.dig(day.to_s)
      next unless day_params && day_params[:open] == "1"

      ranges = (0...RANGES_PER_DAY).map do |index|
        range = day_params.dig(:ranges, index.to_s) || {}
        [ range[:from].to_s, range[:to].to_s ]
      end
      ranges = ranges.reject { |from, to| from.blank? && to.blank? }
      result[day.to_s] = ranges.presence || [ [ "", "" ] ]
    end
    new(days)
  end

  def to_h
    days
  end

  def empty?
    days.empty?
  end

  # Problems to show in the form, or an empty list.
  def errors
    days.flat_map do |_day, ranges|
      ranges.filter_map do |from, to|
        if !TIMES.include?(from) || !TIMES.include?(to)
          "chaque jour coché doit avoir une heure de début et une heure de fin"
        elsif from >= to
          "une plage horaire doit finir après son début"
        end
      end
    end.uniq
  end

  def ranges_on(date)
    days.fetch(date.cwday.to_s, [])
  end

  def open_on?(date)
    ranges_on(date).any?
  end

  # Is this time inside one of the time ranges of its day? (the end of a range is excluded)
  def includes?(time)
    clock = time.strftime("%H:%M")
    ranges_on(time.to_date).any? { |from, to| clock >= from && clock < to }
  end

  # The times that can be chosen on that day, every 15 minutes ("09:00", "09:15" … "11:45").
  def times_on(date)
    ranges_on(date).flat_map { |from, to| TIMES.select { |clock| clock >= from && clock < to } }.uniq.sort
  end

  # In French, the days with the same hours together: "Du lundi au vendredi : 9h–12h et 14h–17h · Samedi : 10h–12h"
  def to_s
    groups = days.sort_by { |day, _ranges| day.to_i }.group_by { |_day, ranges| ranges }
    groups.map { |ranges, group| "#{days_label(group.map { |day, _| day.to_i })} : #{ranges_label(ranges)}" }.join(" · ")
  end

  private

  # 3 days or more in a row: "du lundi au vendredi"; otherwise the days one by one: "mardi et jeudi".
  def days_label(numbers)
    labels = numbers.slice_when { |previous, current| current != previous + 1 }.flat_map do |run|
      run.size >= 3 ? "du #{DAYS[run.first]} au #{DAYS[run.last]}" : run.map { |day| DAYS[day] }
    end
    labels.to_sentence(words_connector: ", ", two_words_connector: " et ", last_word_connector: " et ").upcase_first
  end

  def ranges_label(ranges)
    ranges.map { |from, to| "#{clock_label(from)}–#{clock_label(to)}" }.join(" et ")
  end

  # "09:00" → "9h", "09:30" → "9h30"
  def clock_label(clock)
    hours, minutes = clock.split(":")
    "#{hours.to_i}h#{minutes unless minutes == "00"}"
  end
end
