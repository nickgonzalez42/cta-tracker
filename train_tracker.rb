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