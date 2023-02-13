#init and sample variables
key = "fc53f4482790470da2cd1d4d1364199b"

# TTY::Color.color?    # => true
# TTY::Color.support?  # => true

base = "lapi.transitchicago.com/api/1.0/ttarrivals.aspx"

example = "http://lapi.transitchicago.com/api/1.0/ttarrivals.aspx?key=#{key}&mapid=40380&max=10"
example_damen = "http://lapi.transitchicago.com/api/1.0/ttarrivals.aspx?key=#{key}&mapid=40090&max=10"
example_damen_kimball_bound = "http://lapi.transitchicago.com/api/1.0/ttarrivals.aspx?key=#{key}&mapid=30018&max=10"

require "csv"
require "open-uri"
require "nokogiri"

require "tty-table"
require "tty-color"

def initialize_destinations
	file = CSV.read("stops.txt")
	dict = {}
	file.each do |line|
		if line[0].to_i > 29999 and line[0].to_i < 40000
			dict[line[0].to_i] = line[2]
		end
	end
	return dict
end

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

def get_arrival_times(station, key)
	live = "http://lapi.transitchicago.com/api/1.0/ttarrivals.aspx?key=#{key}&mapid=#{station}&max=10"
	doc = Nokogiri::XML(URI.open(live))
	arr = []
	trains = doc.xpath("//rt")
	trains.each do |train|
		arr << "A " + train.text + " line train will be arriving at "
	end
	i = 0
	trains = doc.xpath("//arrT")
	trains.each do |train|
		arr[i] += train.text
		i += 1
	end
	i = 0
	trains = doc.xpath("//destSt")
	trains.each do |train|
		arr[i] += " headed towards " + train.text + " station."
		i += 1
	end
	return arr
end

stops = initialize_stops
destinations = initialize_destinations
print_stops(stops)
user_stop = get_user_stop(stops) # returns station code to plug into URL 
puts get_arrival_times(user_stop, key)