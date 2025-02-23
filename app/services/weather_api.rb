class WeatherApi
  def self.key
    return nil if Rails.env.test?
    raise 'WEATHER_APIKEY env variable not defined' if ENV['WEATHER_APIKEY'].nil?

    ENV.fetch('WEATHER_APIKEY')
  end

  def self.weather_in(city)
    city = city.downcase
    url = "http://api.weatherstack.com/current"

    response = HTTParty.get(url, query: { access_key: key, query: city })
    response.parsed_response
  end
end
