gem "tty-color"

require "csv"
require "open-uri"
require "nokogiri"

file = CSV.read("stops.txt")
# pp file

dict = {}

file.each do |line|
	if line[0].to_i > 39999 and line[0].to_i < 50000
		dict[line[0].to_i] = line[2]
	end
end

pp dict

base = "lapi.transitchicago.com/api/1.0/ttarrivals.aspx"
damen_stop = "30019"
key = "fc53f4482790470da2cd1d4d1364199b"
example = "http://lapi.transitchicago.com/api/1.0/ttarrivals.aspx?key=#{key}&mapid=40380&max=10"
example_damen = "http://lapi.transitchicago.com/api/1.0/ttarrivals.aspx?key=#{key}&mapid=40090&max=10"
example_damen_kimball_bound = "http://lapi.transitchicago.com/api/1.0/ttarrivals.aspx?key=#{key}&mapid=30018&max=10"

doc = Nokogiri::XML(URI.open(example))

# pp doc
# pp doc.xpath("children")
arr = []

# adds the line to the arr
trains = doc.xpath("//rt")
trains.each do |train|
  arr << "A " + train.text + " line train will be arriving at "
end

i = 0
# adds the next Damen arrival times to arr
trains = doc.xpath("//arrT")
trains.each do |train|
  puts train.text
  arr[i] += train.text
  i += 1
end

i = 0
trains = doc.xpath("//destSt")
trains.each do |train|
  arr[i] += " headed towards " + train.text + " station."
  i += 1
end

puts arr
