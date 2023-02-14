train_key = "fc53f4482790470da2cd1d4d1364199b"
bus_key = "xy8nWBFwwiRYaAQjLDewxLZN2"

# gems
require "csv"
require "open-uri"
require "nokogiri"
require "timezone"
require "tty-table"
require "tty-color"
require "pastel"
require "tty-prompt"

# file
require_relative "customer_alerts"
require_relative "train_tracker"
require_relative "bus_tracker"

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
		prompt = TTY::Prompt.new
		i = prompt.yes?("View alerts?") do |q|
		  q.suffix "Yes/No"
		  q.positive "Yes"
		  q.negative "No"
		  q.convert -> (input) { !input.match(/^yes$/i).nil? }
		end
		if i
			table = TTY::Table.new(header: ["Alerts"], rows: [])
			alerts = get_station_alerts(user_stop)
			if alerts.length < 1
				puts "No alerts"
				exit(0)
			end
			alerts.each do |alert|
				table << [alert]
			end
			puts table.render(:ascii)
			exit(0)
		elsif i == false
			exit(0)
		end
	end
end

stops = initialize_stops
destinations = initialize_destinations
print_stops(stops)
user_stop = get_user_stop(stops) # returns station code to plug into URL 
arrival_times = get_train_arrival_times(user_stop, train_key, destinations)
display_arrival_times(arrival_times, stops, user_stop)
display_alerts(user_stop)