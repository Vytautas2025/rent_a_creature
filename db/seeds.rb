
puts "Cleaning the DB..."

Booking.destroy_all
Creature.destroy_all
User.destroy_all

puts "creatng users..."
user1 = User.create!(email: "juan@lewagon.com", password: "vvwvwwv23")
user2 = User.create!(email: "lukaz@lewagon.com", password: "vfber323")
user3 = User.create!(email: "Shwetha@lewagon.com", password: "dfbebe2323")
user4 = User.create!(email: "vytautas@lewagon.com", password: "weff32323")
user5 = User.create!(email: "jessica@lewawagon.com", password: "sdfwwe232")

puts "#{User.count} users created"

# puts "creating creatures"
# Creature.create!(name: "Bulbasaur", available: true, price: 15.99, description: 'Grass and posion Pokemon,a plant seed on its back right from the day this Pokémon is born', user_id: user1.id )
# Creature.create!(name: "Charmander", available: true, price: 15.99, description: 'As a Fire-type Pokémon, Charmander only takes half of the normal damage from Fire, Ice, Grass, Bug, and Steel-types.', user_id: user2.id  )
# Creature.create!(name: "Squirtle", available: true, price: 15.99, description: 'water type pokemon, retracts its long neck into its shell, it squirts out water with vigorous force.', user_id: user3.id )
# Creature.create!(name: "Gengar", available: false, price: 100.99, description: 'Ghost and poison pokémon with a wicked grin that loves to play tricks in the dark.', user_id: user4.id )
# Creature.create!(name: "Greninja", available: true, price: 1000.99, description: "A sleek, blue Water/Dark type ninja Pokémon that moves swiftly and uses water shurikens in battle.", user_id: user5.id )

# puts "#{Creature.count} creatures created"

puts "Done!"
