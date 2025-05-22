require 'open-uri'
require 'json'
require 'faker'

puts "Cleaning the DB..."

Booking.destroy_all
Creature.destroy_all
User.destroy_all

puts "creatng users..."
user1 = User.create!(email: "juan@lewagon.com", password: "vvwvwwv23")
user2 = User.create!(email: "lukaz@lewagon.com", password: "vfber323")
user3 = User.create!(email: "Shwetha@lewagon.com", password: "dfbebe2323")
user4 = User.create!(email: "vytautas@lewagon.com", password: "weff32323")
user5 = User.create!(email: "jessica@lewagon.com", password: "sdfwwe232")

users = [user1, user2, user3, user4, user5]

puts "#{User.count} users created"


puts "creating creatures"

(1..30).each do |id|
  url = "https://pokeapi.co/api/v2/pokemon/#{id}"
  response = URI.open(url).read
  data = JSON.parse(response)

  name = data["name"].capitalize
  image_url = data["sprites"]["front_default"]
  price = rand(10.0..200.0).round(2)
  types = data["types"].map { |t| t["type"]["name"] }.join(", ")
  available = true

  locations = [
    "london, england", "paris, france", "Beriln, germany", "Barcelona, spain", "Rome,italy",
  ]

  Creature.create!(
    name: name,
    image_url: image_url,
    price: price,
    user: users.sample,
    types: types,
    available: available,
    location: locations.sample,
    address: "#{Faker::Address.street_address}.#{Faker::Address.city}, #{locations.sample}"
  )
end

puts "#{Creature.count} creatures created"

puts "Done!"
