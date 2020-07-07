require 'eltiempo'
require 'thor'
require 'httparty'

module Eltiempo
 class CLI < Thor
    desc "today city", "will display the min and max temperature for today"
    def today(city)
      city_temperatures = extract_city_temperatures(city)
      
      return nil if city_temperatures.nil?

      min_temperature_today = city_temperatures[0]['data']['forecast'][DateTime.now.wday - 1]['value']
      max_temperature_today = city_temperatures[1]['data']['forecast'][DateTime.now.wday - 1]['value']
      
      puts('The minimum temperature for today is: ' + min_temperature_today)
      puts('The maximum temperature for today is: ' + max_temperature_today)
    end

    desc "av_max city", "will display the average max temperature for this week"
    def av_max(city)
      city_temperatures = extract_city_temperatures(city)

      return nil if city_temperatures.nil?

      av_max_temp = city_temperatures[1]['data']['forecast'].inject(0){ |sum,e| sum + e['value'].to_i } / 7
      
      puts('The average max temperature for this week is: ' + av_max_temp.to_s)
    end

    desc "av_min city", "will display the average max temperature for this week"
    def av_min(city)
      city_temperatures = extract_city_temperatures(city)
      
      return nil if city_temperatures.nil?

      av_min_temp = city_temperatures[0]['data']['forecast'].inject(0){ |sum,e| sum + e['value'].to_i } / 7
      
      puts('The average min temperature for this week is: ' + av_min_temp.to_s)

    end

    private

      def extract_city_url(city)
        response = HTTParty.get('http://api.tiempo.com/index.php?api_lang=es&division=102&affiliate_id=zdo2c683olan')
        
        cities = response['report']['location']['data']

        city_array = cities.select{ |selected_city| selected_city['name']['__content__'] == city }

        if city_array.empty?
          puts("Can't find this city. Sorry :D")

          nil
        else
          city_array.first["url"] + "&affiliate_id=zdo2c683olan"
        end

      end

      def extract_city_temperatures(city)
        url = extract_city_url(city)

        return nil if url.nil?

        response = HTTParty.get(url)
        
        response['report']['location']['var']
      end
 end
end
