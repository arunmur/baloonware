require 'time'

require_relative 'models/measurement'
require_relative 'models/unit'

time = DateTime.parse("2000-01-01T00:00:00")
location = [ 0, 0 ]
drift_speed_per_measurement = 1
max_temp = 44
min_temp = -10

countries = [ 'AU', 'US', 'FR', 'DE', 'PL', 'RU' ]
country_index = 0

gen_data_country = Measurement::Country.get("AU")

File.open("sample.dat", "w") { |file|
  500_000_000.times do |i|

    temp = Unit::Celcius.new(rand(max_temp - min_temp) + min_temp)
    country = countries[country_index]
    if rand(100) > 92
      m = Measurement.new((time + Rational(rand(10) - 5, 1440)), location.map { |co_ord| Unit::Kilometers.new(co_ord) }, temp, gen_data_country)
    else
      m = Measurement.new(time, location.map { |co_ord| Unit::Kilometers.new(co_ord) }, temp, gen_data_country)
    end
    file.write(m.for(Measurement::Country.get(country)).as_recording + "\n")
    puts "Generated #{i}" if i % 10_000 == 0
    country_index = (country_index + 1) % countries.size if i % 10_000 == 0
    location_jump = rand(2)
    if location_jump == 0
      location = [ (location[0] + 1) % 50000, location[1] ]
    else
      location = [ location[0], (location[1] + 1) % 50000 ]
    end

    time = time + Rational(1, 1440)
  end
}
