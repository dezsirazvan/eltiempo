require 'httparty'
require "eltiempo/cli"

module Eltiempo
 class Calculator
    def initialize(city, affiliate_id = 'zdo2c683olan')
      @city = city
      @affiliate_id = affiliate_id
    end

    def city
      @city
    end

    def affiliate_id
      @affiliate_id
    end

    def request_url
      "http://api.tiempo.com/index.php?api_lang=es&division=102&affiliate_id=#{affiliate_id}"
    end

    def today
      city_temperatures = extract_city_temperatures
      
      return nil if city_temperatures.nil?

      min_temperature_today = city_temperatures[0]['data']['forecast'][DateTime.now.wday - 1]['value']
      max_temperature_today = city_temperatures[1]['data']['forecast'][DateTime.now.wday - 1]['value']
      
      puts('The minimum temperature for today is: ' + min_temperature_today)
      puts('The maximum temperature for today is: ' + max_temperature_today)

      [min_temperature_today, max_temperature_today]
    end

    def av_max
      city_temperatures = extract_city_temperatures

      return nil if city_temperatures.nil?

      av_max_temp = city_temperatures[1]['data']['forecast'].inject(0){ |sum,e| sum + e['value'].to_i } / 7
      
      puts('The average max temperature for this week is: ' + av_max_temp.to_s)

      av_max_temp
    end

    def av_min
      city_temperatures = extract_city_temperatures
      
      return nil if city_temperatures.nil?

      av_min_temp = city_temperatures[0]['data']['forecast'].inject(0){ |sum,e| sum + e['value'].to_i } / 7
      
      puts('The average min temperature for this week is: ' + av_min_temp.to_s)

      av_min_temp
    end

    private

      def extract_city_url
        response = HTTParty.get(request_url)
        city_array = []
        
        unless response['report']['location'].nil?
          cities = response['report']['location']['data']

          city_array = cities.select{ |selected_city| selected_city['name']['__content__'] == city }
        end

        if city_array.empty?
          puts("Can't find this city. Sorry :D")

          nil
        else
          city_array.first["url"] + "&affiliate_id=#{affiliate_id}"
        end

      end

      def extract_city_temperatures
        url = extract_city_url

        return nil if url.nil?

        response = HTTParty.get(url)
        
        response['report']['location']['var']
      end
 end
end
