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
		puts "File not found"
		exit(0)
	end
end

def print_table(stops, reorder)
	if reorder
		stops = stops.sort_by { |key, value| value }.to_h
	end
	
	table = TTY::Table.new(header: ["Station ID", "Station Name"], rows: [])
	stops.each do |stop|
		table << [stop[0], stop[1]]
	end
	puts table.render(:ascii)
end

def get_user_choice(table)
	i = gets.chomp
	if i.to_i == 0
		names = []
		table.values.each do |value|
			names << value
		end
		if names.include? i
			return table.key(i)
		else
			puts "Selection not found."
			exit(0)
		end
	else
		code = i.to_i
		if table.keys.include? code
			return code
		else
			puts "Numeric selection not found."
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

def run_train_tracker(train_key)
	stops = initialize_train_stops
	destinations = initialize_train_destinations
	print_table(stops, true)
	print "Please enter your Station Name or ID: "
	user_stop = get_user_choice(stops) # returns station code to plug into URL 
	arrival_times = get_train_arrival_times(user_stop, train_key, destinations)
	display_train_arrival_times(arrival_times, stops, user_stop)
	display_alerts(user_stop)
end

def run_bus_tracker(bus_key)
	routes = get_routes(bus_key)
	print_table(routes, false)
	print "Please enter your Station Name or ID: "
	user_route = get_user_choice(routes)
	direction = get_user_direction(user_route, bus_key)
	stops = get_route_stops(user_route, direction, bus_key)
	print_table(stops, false)
	print "Please enter your Stop Name or ID: "
	stop = get_user_choice(stops)
	times = get_bus_arrival_times(user_route, stop, direction, bus_key)
	display_bus_arrival_times(times)
	display_alerts(stop)
	# user_stop = get_user_stop(stops) # returns station code to plug into URL 
	# arrival_times = get_train_arrival_times(user_stop, train_key, destinations)
	# display_arrival_times(arrival_times, stops, user_stop)
	# display_alerts(user_stop)
end

def state(train_key, bus_key)
	prompt = TTY::Prompt.new
	i = prompt.yes?("Train Tracker or Bus Tracker?") do |q|
	  q.suffix "Train/Bus"
	  q.positive "Train"
	  q.negative "Bus"
	  q.convert -> (input) { !input.match(/^train$/i).nil? }
	end
	if i
		run_train_tracker(train_key)
	else
		run_bus_tracker(bus_key)
	end
end

state(train_key, bus_key)