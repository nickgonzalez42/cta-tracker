def initialize_train_stops
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

def initialize_train_destinations
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

def get_train_arrival_times(station, key, destinations)
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

def display_train_arrival_times(times, stops, user_stop)
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