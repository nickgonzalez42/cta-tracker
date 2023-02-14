#init and sample variables
key = ""

# TTY::Color.color?    # => true
# TTY::Color.support?  # => true

base = "lapi.transitchicago.com/api/1.0/ttarrivals.aspx"
example = "http://lapi.transitchicago.com/api/1.0/ttarrivals.aspx?key=#{key}&mapid=40380&max=10"
example_damen = "http://lapi.transitchicago.com/api/1.0/ttarrivals.aspx?key=#{key}&mapid=40090&max=10"

# gems
require "csv"
require "open-uri"
require "nokogiri"
require "timezone"
require "tty-table"
require "tty-color"
require "pastel"

# file
require_relative "customer_alerts"

def checker(obj)
	if obj == nil
		puts "Connection or file not found"
		exit(0)
	end
end

def initialize_destinations
	file = CSV.read("stops.txt")
	checker(file)
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
	checker(file)
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
		table << [stop[0], stop[1]]
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
			return stops.key(i)
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

def get_arrival_times(station, key, destinations)
	live = "http://lapi.transitchicago.com/api/1.0/ttarrivals.aspx?key=#{key}&mapid=#{station}&max=10"
	doc = Nokogiri::XML(URI.open(live))
	arr = []
	i = 0
	trains = doc.xpath("//rt")
	trains.each do |train|
		arr << [train.text]
	end
	i = 0
	trains = doc.xpath("//arrT")
	trains.each do |train|
		arr[i] << train.text
		i += 1
	end
	i = 0
	stations = doc.xpath("//destSt")
	stations.each do |station|
		code = station.text
		code = code.to_i
		if destinations.keys.include? code
			name = destinations[code]
		elsif code == 0
			name = "the Loop"
		else
			name = "destination not found"
		end
		arr[i] << name
		i += 1
	end
	return arr
end

def convert_time_to_minutes(raw_time)
	year = raw_time[0, 4].to_i
	month = raw_time[4..5].to_i
	day = raw_time[6..7].to_i
	hour = raw_time[9..10].to_i
	minute = raw_time[12..13].to_i
	second = raw_time[15..16].to_i
	tz = Timezone["America/Chicago"]
	local_time = Time.now.getlocal
	arrival_time = Time.new(year, month, day, hour, minute, second, tz)
	return ((arrival_time - local_time) / 60).round
end

def display_arrival_times(times, stops, user_stop)
	# TODO Get table working
	# TODO Add a color works in terminal checker
	if times.length < 1
		puts "No arrival times scheduled"
		exit(0)
	end
	pastel = Pastel.new
	table = TTY::Table.new(header: ["Arrival Times for " + stops[user_stop]], rows: [])
	times.each do |time|
		colored_text = ""
		case time[0]
		when "Brn"
			colored_text = pastel.bright_black("Brown")
		when "Red"
			colored_text = pastel.red("Red")
		when "G"
			colored_text = pastel.green("Green")
		when "Y"
			colored_text = pastel.yellow("Yellow")
		when "P"
			colored_text = pastel.magenta("Purple")
		when "Org"
			colored_text = pastel.bright_yellow("Orange")
		when "Blue"
			colored_text = pastel.blue("Blue")
		when "Pink"
			colored_text = pastel.bright_red("Pink")
		end
		time_to_arrival = convert_time_to_minutes(time[1])
		if TTY::Color.color?
			table << [colored_text + " line train towards " + time[2] + " will arrive in #{time_to_arrival} minutes."]
		else
			table << [time[0] + " line train towards " + time[2] + " will arrive in #{time_to_arrival} minutes."]
		end
		# table << "A " + colored_text + " line train towards " + time[2] + " will arrive at " + time[1]
	end
	Gem.win_platform? ? (system "cls") : (system "clear")
	puts table.render(:ascii)
end

def display_alerts(user_stop)
	while true
		print "View station/line alerts? (Y/N) "
		i = gets.chomp.downcase
		if i == "y"
			table = TTY::Table.new(header: ["Alerts"], rows: [])
			alerts = get_station_alerts(user_stop)
			alerts.each do |alert|
				table << [alert]
			end
			puts table.render(:ascii)
			exit(0)
		elsif i == "n"
			exit(0)
		end
	end
end

stops = initialize_stops
destinations = initialize_destinations
print_stops(stops)
user_stop = get_user_stop(stops) # returns station code to plug into URL 
arrival_times = get_arrival_times(user_stop, key, destinations)
display_arrival_times(arrival_times, stops, user_stop)
display_alerts(user_stop)