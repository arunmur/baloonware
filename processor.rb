require_relative 'models/measurement'
require_relative 'models/unit'
require_relative 'models/stats'



required_distance = "Kilometers"
required_temperature = "Celcius"
stats = [
  Stats::MaxTemp.new,
  Stats::MinTemp.new,
  Stats::MeanTemp.new,
  Stats::ObservationsPerObeservatory.new,
  Stats::TotalDistanceTravelled.new
]
File.open("sample.dat", "r").each_line do |line|
  m = Measurement.from_recording(line)
  converted_m = m.for(Measurement::Country.new(m.country.code, required_temperature, required_distance))
  stats = stats.map { |s| s.record(converted_m) }
end

puts "Max Temperature #{stats[0].value}"
puts "Min Temperature #{stats[1].value}"
puts "Mean Temperature #{stats[2].value}"
puts "Per Observatort:"
stats[3].each do |observatory, count|
  puts "\t#{observatory} = #{count}"
end
puts "Total Distance #{stats[4].value}"
