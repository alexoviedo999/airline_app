require 'stripe'
require 'prawn'
require 'pony'
require 'net/http'
require 'json'
require 'pp'
require 'yaml'

# request = {
#   :itinerary => {
#     :leave => {
#       :depart_data => {
#         :airport => "DTW",
#         :date => "9/26/2012",
#         :time => "1800"
#       },
#       :arrive_data => {
#         :airport => "MIA",
#         :date => "9/26/2012",
#         :time => "2100"
#       }
#     },
#     :return => {
#       :depart_data => {
#         :airport => "MIA",
#         :date => "9/28/2012",
#         :time => "1800"
#       },
#       :arrive_data => {
#         :airport => "DTW",
#         :date => "9/28/2012",
#         :time => "2100"
#       }
#     }
#   },
#   :po => {
#     :price => 300,
#     :time => Time.now
#   },
#   :user => {
#     :name => "John Bernstein",
#     :email => "stuwags@gmail.com",
#     :cc => {
#       :number => "424242424242",
#       :CVC => "424",
#       :expiration => "09/2012"
#     }
#   }
# }

class TravelRequest
   

  def initialize(request)
    @request = request
    # @origin = origin
    # @destination = destination 
    enter_travel_plan
  end

  def enter_travel_plan
     
    puts "Please give flight Departing Airport" @request[:itinerary][:leave][:depart_data][:airport] = gets.chomp 
    puts "Please give departing date (9/28/2012)" @request[:itinerary][:leave][:depart_data][:date] = gets.chomp
    puts "Please give departing time(2100)" @request[:itinerary][:leave][:depart_data][:time] = gets.chomp

    puts "Please give your flight Arriving Airport, date (9/28/2012), and time (2100)"
    @request[:itinerary][:leave][:arrive_data][:airport] = gets.chomp
    @request[:itinerary][:leave][:arrive_data][:date] = gets.chomp
    @request[:itinerary][:leave][:arrive_data][:time] = gets.chomp

    puts "Please give your return flight depart date and time"
    @request[:itinerary][:return][:depart_data][:airport] = @request[:itinerary][:leave][:arrive_data][:airport]
    @request[:itinerary][:return][:depart_data][:date] = gets.chomp
    @request[:itinerary][:return][:depart_data][:time] = gets.chomp

    puts "Please give your return flight arrive date and time"
    @request[:itinerary][:return][:arrive_data][:airport] = @request[:itinerary][:leave][:depart_data][:airport]
    @request[:itinerary][:return][:arrive_data][:date] = gets.chomp
    @request[:itinerary][:return][:arrive_data][:time] = gets.chomp

  end


  def pdf_print
    puts "This is the pdf print method"
    Prawn::Document.generate(@request[:user][:name] + ' invoice.pdf') do |pdf| 
    pdf.text("Congratulations on your purchase!" + "\n" + "Your price was " + @request[:po][:price].to_s) 
    puts "This is the end to this method"
    end
  end

  def email
  end

  def charge
    Stripe.api_key = "vtUQeOtUnYr7PGCLQ96Ul4zqpDUO4sOE"
    Stripe::Charge.create(
    :amount => (@request[:po][:price]*100),
    :currency => "usd",
    :card => "tok_jOq0M8vJprCUUU", # obtained with Stripe.js
    :description => "Charge for test@example.com"
  )
  end
# origin = @request[:itinerary][:leave][:depart_data][:airport]
# destination = @request[:itinerary][:leave][:arrive_data][:airport]

  def brighterplanet(origin, destination)
    uri = URI('http://impact.brighterplanet.com/flights.json')
    res = Net::HTTP.post_form(uri, 'origin_airport' => origin,
                               'destination_airport' => destination)

      data = JSON.parse(res.body) 
      pp data 

      @cars_off_road_day = data['equivalents']['cars_off_the_road_for_a_day']
      @lightbulbs_day = data['equivalents']['lightbulbs_for_a_day']
      @departure_airport = data['characteristics']['origin_airport']['object']['airport']['name']
      @destination_airport = data['characteristics']['destination_airport']['object']['airport']['name']

      puts "cars off the road #{@cars_off_road_day}"

    end
      
  end
  


puts "origin: "
origin = gets.chomp
puts "destination: "
destination = gets.chomp



request1 = TravelRequest.new(request)
request1.pdf_print

request1.brighterplanet(origin, destination)



