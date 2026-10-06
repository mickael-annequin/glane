require "test_helper"

class ScheduleTest < ActiveSupport::TestCase
  test "sums up the planning in French, days with the same hours together" do
    week = (1..5).to_h { |day| [ day.to_s, [ %w[09:00 12:00], %w[14:00 17:00] ] ] }.merge("6" => [ %w[10:00 12:30] ])

    assert_equal "Du lundi au vendredi : 9h–12h et 14h–17h · Samedi : 10h–12h30", Schedule.new(week).to_s
    assert_equal "Mardi et jeudi : 10h–16h", Schedule.new("2" => [ %w[10:00 16:00] ], "4" => [ %w[10:00 16:00] ]).to_s
  end

  test "reads the form: checked days only, empty ranges ignored" do
    params = ActionController::Parameters.new(
      "1" => { "open" => "1", "ranges" => { "0" => { "from" => "09:00", "to" => "12:00" }, "1" => { "from" => "", "to" => "" } } },
      "2" => { "ranges" => { "0" => { "from" => "09:00", "to" => "12:00" } } }, # not checked
      "sent" => "1"
    )

    assert_equal({ "1" => [ %w[09:00 12:00] ] }, Schedule.from_form(params).to_h)
  end

  test "the times of a day, every 15 minutes, end excluded" do
    schedule = Schedule.new("1" => [ %w[09:00 10:00], %w[14:00 14:30] ])
    monday = Date.new(2026, 10, 12)

    assert_equal %w[09:00 09:15 09:30 09:45 14:00 14:15], schedule.times_on(monday)
    assert_empty schedule.times_on(monday + 1)
    assert schedule.includes?(Time.zone.parse("2026-10-12 09:45"))
    assert_not schedule.includes?(Time.zone.parse("2026-10-12 10:00"))
  end

  test "refuses half-filled or reversed time ranges" do
    assert_equal [ "chaque jour coché doit avoir une heure de début et une heure de fin" ], Schedule.new("1" => [ [ "09:00", "" ] ]).errors
    assert_equal [ "une plage horaire doit finir après son début" ], Schedule.new("1" => [ %w[17:00 09:00] ]).errors
    assert_empty Schedule.new("1" => [ %w[09:00 17:00] ]).errors
  end
end
