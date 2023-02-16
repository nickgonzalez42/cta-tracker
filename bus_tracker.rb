def get_routes(key)
	live = "http://www.ctabustracker.com/bustime/api/v2/getroutes?key=#{key}"
	doc = Nokogiri::XML(URI.open(live))
	dict = {}
	arr = []
	routes = doc.xpath("//rt")
	routes.each do |route|
		arr << [route.text.to_i]
	end
	route_names = doc.xpath("//rtnm")
	i = 0
	route_names.each do |name|
		arr[i] << name.text
		i += 1
	end
	arr.each do |arr|
		dict[arr[0]] = arr[1]
	end
	return dict
end

def get_user_direction(route, key)
	live = "http://www.ctabustracker.com/bustime/api/v2/getdirections?key=#{key}&rt=#{route}"
	doc = Nokogiri::XML(URI.open(live))
	arr = []
	arr = looper("//dir", arr, doc)
	prompt = TTY::Prompt.new
	i = prompt.yes?("Please choose a direction:") do |q|
	  q.suffix "#{arr[0][0]}, #{arr[1][0]}"
	  q.positive "#{arr[0][0]}"
	  q.negative "#{arr[1][0]}"
	end
	if i
		return arr[0][0]
	else
		return arr[1][0]
	end
end

def get_route_stops(route, direction, key)
	live = "http://www.ctabustracker.com/bustime/api/v2/getstops?key=#{key}&rt=#{route}&dir=#{direction}"
	doc = Nokogiri::XML(URI.open(live))
	dict = {}
	arr = []
	stops = doc.xpath("//stpid")
	stops.each do |stop|
		arr << [stop.text.to_i]
	end
	looper("//stpnm", arr, doc)
	arr.each do |arr|
		dict[arr[0]] = arr[1]
	end
	return dict
end

def get_bus_arrival_times(route, stop, direction, key)
	live = "http://www.ctabustracker.com/bustime/api/v2/getpredictions?key=#{key}&rt=#{route}&stpid=#{stop}&rtdir=#{direction}"
	doc = Nokogiri::XML(URI.open(live))
	arr = []
	arr = looper("//typ", arr, doc)
	arr = looper("//prdctdn", arr, doc)
	arr = looper("//dly", arr, doc)
	return arr
end

def display_bus_arrival_times(times)
	if times.length < 1
		puts "No arrival times scheduled"
		exit(0)
	end
	table = TTY::Table.new(header: ["Arrival Times", "On-Time Status"], rows: [])
	times.each do |time|
		minutes = time[1]
		type = ""
		delay = ""
		if times[0] == "A"
			type = "arrival"
		else
			type = "departure"
		end
		if times[2] == true
			delay = "Delayed"
		else
			delay = "On time"
		end
		table << ["#{minutes} minutes until bus #{type}", "#{delay}"]
	end
	Gem.win_platform? ? (system "cls") : (system "clear")
	puts table.render(:ascii)
end