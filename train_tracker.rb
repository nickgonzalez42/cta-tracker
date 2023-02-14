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