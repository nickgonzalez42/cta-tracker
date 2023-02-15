def get_routes(key)
	live = "http://www.ctabustracker.com/bustime/api/v2/getroutes?key=#{key}"
	doc = Nokogiri::XML(URI.open(live))
	dict = {}
	arr = []
	routes = doc.xpath("//rt")
	routes.each do |route|
		arr << [route.text]
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

def print_routes(routes)
	table = TTY::Table.new(header: ["Route Number", "Route Name"], rows: [])
	routes.each do |route|
		table << [route[0], route[1]]
	end
	puts table.render(:ascii)
end

def get_user_route
	
end