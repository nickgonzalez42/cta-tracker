key = "fc53f4482790470da2cd1d4d1364199b"

require "csv"
require "open-uri"
require "nokogiri"

require "tty-table"
require "tty-color"

def initialize_stops
	file = CSV.read("stops.txt")
	dict = {}
	file.each do |line|
		if line[0].to_i > 39999 and line[0].to_i < 50000
			dict[line[0].to_i] = line[2]
		end
	end
	return dict
end

def print_stops(stops)
	stops = stops.sort_by { |key, value| value }.to_h
	
	table = TTY::Table.new(header: ["Station ID", "Station Name"], rows: [])
	stops.each do |stop|
		table << [ stop[0], stop[1]]
	end
	puts table.render(:ascii)
end

def get_user_stop(stops)
	print "Please enter your Station Name or ID: "
	i = gets.chomp
	if i.to_i == 0
		names = []
		stops.values.each do |stop|
			names << stop
		end
		if names.include? i
			p stops.key(i)
		else
			puts "No station found."
			exit(0)
		end
	else
		code = i.to_i
		if stops.keys.include? code
			return code
		else
			puts "No station found."
			exit(0)
		end
	end
end

stops = initialize_stops
print_stops(stops)
user_stop = get_user_stop(stops) # returns station code to plug into URL 

p TTY::Color.color?    # => true
p TTY::Color.support?  # => true

base = "lapi.transitchicago.com/api/1.0/ttarrivals.aspx"

example = "http://lapi.transitchicago.com/api/1.0/ttarrivals.aspx?key=#{key}&mapid=40380&max=10"
example_damen = "http://lapi.transitchicago.com/api/1.0/ttarrivals.aspx?key=#{key}&mapid=40090&max=10"
example_damen_kimball_bound = "http://lapi.transitchicago.com/api/1.0/ttarrivals.aspx?key=#{key}&mapid=30018&max=10"
live = "http://lapi.transitchicago.com/api/1.0/ttarrivals.aspx?key=#{key}&mapid=#{user_stop}&max=10"

doc = Nokogiri::XML(URI.open(live))

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
  # puts train.text
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
