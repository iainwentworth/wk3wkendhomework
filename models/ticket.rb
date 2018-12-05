require_relative("../db/sql_runner.rb")
require_relative("./customer.rb")
require_relative("./film.rb")



class Ticket

  attr_reader :id
  attr_accessor :customer_id, :film_id

  def initialize( options )
    @id = options['id'].to_i if options['id']
    @customer_id = options['customer_id'].to_i
    @film_id = options['film_id'].to_i
  end

  def save()
    sql = "INSERT INTO tickets (customer_id, film_id) VALUES ($1, $2) RETURNING id"
    values = [@customer_id, @film_id]
    ticket = SqlRunner.run( sql, values).first
    @id = ticket['id'].to_i
  end

  def self.all()
    sql = "SELECT * FROM tickets"
    tickets = SqlRunner.run(sql)
    result = tickets.map { |ticket| Ticket.new(ticket) }
    return result
  end

  def self.find(id)
    sql = "SELECT * FROM tickets WHERE id = $1"
    values = [id]
    results = SqlRunner.run(sql, values)
    ticket_hash = results.first
    ticket = Ticket.new(ticket_hash)
    return ticket
  end

  def update()
    sql = "UPDATE tickets SET (customer_id, film_id) = ($1, $2) WHERE id = $3"
    values = [@customer_id, @film_id, @id]
    SqlRunner.run(sql, values)
  end

  def delete()
    sql = "DELETE FROM tickets where id = $1"
    values = [@id]
    SqlRunner.run(sql, values)
  end

  def self.delete_all()
    sql = "DELETE FROM tickets"
    SqlRunner.run(sql)
  end

  def film()
    sql = "SELECT * FROM films WHERE id = $1"
    values = [@film_id]
    film_hash = SqlRunner.run(sql, values)[0]
    film = Film.new(film_hash)
    return film
  end

  def customer()
    sql = "SELECT * FROM customers WHERE id = $1"
    values = [@customer_id]
    customer_hash = SqlRunner.run(sql, values)[0]
    customer = Customer.new(customer_hash)
    return customer
  end

  def self.sell_ticket(customer, film)
    ticket1 = Ticket.new({ 'customer_id' => customer, 'film_id' => film.id })
    ticket1.save()
  end


# This doesn't work
  def self.customer_sales(customer)
    # all_tickets = Ticket.all
    all_tickets = self.all
    number_of_tickets_sold_to_customer = 0
    all_tickets.map { |ticket| if ticket.customer_id == customer.id then number_of_tickets_sold_to_customer += 1 end}
    return "Customer has bought #{number_of_tickets_sold_to_customer} tickets"
  end



end
