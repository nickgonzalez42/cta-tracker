require "nokogiri"

def get_station_alerts(station_id)
	station_alert_temp = "https://www.transitchicago.com/api/1.0/alerts.aspx?stationid=#{station_id}"
	doc = Nokogiri::XML(URI.open(station_alert_temp))
	alerts = doc.xpath("//Headline")
	arr = []
	alerts.each do |alert|
		arr << alert.text
	end
	return arr
end