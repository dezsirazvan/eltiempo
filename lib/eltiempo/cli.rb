require 'thor'
require 'httparty'
require "calculator"

module Eltiempo
 class CLI < Thor
    map "-today" => "today"
    map "-av_max" => "av_max"
    map "-av_min" => "av_min"

    desc "-today city", "will display the min and max temperature for today"
    def today(city)
      Eltiempo::Calculator.new(city).today
    end

    desc "-av_max city", "will display the average max temperature for this week"
    def av_max(city)
      Eltiempo::Calculator.new(city).av_max
    end

    desc "-av_min city", "will display the average max temperature for this week"
    def av_min(city)
      Eltiempo::Calculator.new(city).av_min
    end
 end
end
