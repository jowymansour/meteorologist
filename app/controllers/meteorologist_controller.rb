require 'open-uri'

class MeteorologistController < ApplicationController
  def street_to_weather_form
    # Nothing to do here.
    render("street_to_weather_form.html.erb")
  end

  def street_to_weather
    @street_address = params[:user_street_address]
    url_safe_street_address = URI.encode(@street_address)

    # ==========================================================================
    # Your code goes below.
    # The street address the user input is in the string @street_address.
    # A URL-safe version of the street address, with spaces and other illegal
    #   characters removed, is in the string url_safe_street_address.
    # ==========================================================================

    # Fetching of the localisation data
    url_address = "http://maps.googleapis.com/maps/api/geocode/json?address=#{url_safe_street_address}"
    parsed_geocalisation_data = JSON.parse(open(url_address).read)

    # Retrieving latitude and longitude from the data
    @lat = parsed_geocalisation_data["results"][0]["geometry"]["location"]["lat"]
    @lng = parsed_geocalisation_data["results"][0]["geometry"]["location"]["lng"]

    # Fetching of the Forecast data
    url_address = "https://api.forecast.io/forecast/79cdf91d3ddb9a62ed3d79ec50184b08/#{@lat},#{@lng}"
    parsed_forecast_data = JSON.parse(open(url_address).read)

    # Retrieving forecast information from the data
    @current_temperature = parsed_forecast_data["currently"]["temperature"]

    @current_summary = parsed_forecast_data["currently"]["summary"]

    @summary_of_next_sixty_minutes = parsed_forecast_data["minutely"]["summary"]

    @summary_of_next_several_hours = parsed_forecast_data["hourly"]["summary"]

    @summary_of_next_several_days = parsed_forecast_data["daily"]["summary"]


    render("street_to_weather.html.erb")
  end
end
