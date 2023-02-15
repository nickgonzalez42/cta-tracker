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
	route_names = doc.xpath("//dir")
	route_names.each do |route|
		arr << route.text
	end
	prompt = TTY::Prompt.new
	i = prompt.yes?("Please choose a direction:") do |q|
	  q.suffix "#{arr[0]}, #{arr[1]}"
	  q.positive "#{arr[0]}"
	  q.negative "#{arr[1]}"
	end
	if i
		return arr[0]
	else
		return arr[1]
	end
end

def get_route_stops(route, direction, key)
	dict = {}
	arr = []
	live = "http://www.ctabustracker.com/bustime/api/v2/getstops?key=#{key}&rt=#{route}&dir=#{direction}"
	doc = Nokogiri::XML(URI.open(live))
	stops = doc.xpath("//stpid")
	stops.each do |stop|
		arr << [stop.text.to_i]
	end
	stop_names = doc.xpath("//stpnm")
	i = 0
	stop_names.each do |name|
		arr[i] << name.text
		i += 1
	end
	arr.each do |arr|
		dict[arr[0]] = arr[1]
	end
	return dict
end

def get_bus_arrival_times(route, stop, direction, key)
	live = "http://www.ctabustracker.com/bustime/api/v2/getpredictions?key=#{key}&rt=#{route}&stpid=#{stop}&rtdir=#{direction}"
end