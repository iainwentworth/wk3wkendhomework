require_relative( 'models/customer.rb' )
require_relative( 'models/film.rb' )
require_relative( 'models/ticket.rb' )

require( 'pry-byebug' )

Ticket.delete_all()
Film.delete_all()
Customer.delete_all()

customer1 = Customer.new({ 'name' => 'Iain', 'funds' => 100 })
customer1.save()
customer2 = Customer.new({ 'name' => 'John', 'funds' => 50 })
customer2.save()


film1 = Film.new({ 'title' => 'The Matrix', 'price' => 7 })
film1.save()
film2 = Film.new({ 'title' => 'Alien', 'price' => 5 })
film2.save()


ticket1 = Ticket.new({ 'customer_id' => customer1.id, 'film_id' => film1.id })
ticket1.save()
ticket2 = Ticket.new({ 'customer_id' => customer1.id, 'film_id' => film2.id })
ticket2.save()
ticket3 = Ticket.new({ 'customer_id' => customer2.id, 'film_id' => film1.id })
ticket3.save()





# Testing  customer name update - it works
# customer1.name = 'Charlie'
# customer1.update

# Testing film title update - it works
# film1.title = 'The Fifth Element'
# film1.update

# Testing customer delete
# customer1.delete()

# Testing film delete
# film1.delete

# Testing ticket find - tested in Terminal ( Ticket.find(1) ) -  works

# Testing ticket delete - works
# ticket1.delete()

# Ticket update test
# ticket1.customer_id = customer2.id
# ticket1.update

binding.pry
nil
