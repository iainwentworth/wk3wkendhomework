require_relative("../db/sql_runner.rb")
require_relative("./film.rb")
require_relative("./ticket.rb")


class Customer

  attr_reader :id
  attr_accessor :name, :funds

  def initialize(properties)
    @id = properties['id'].to_i if properties['id']
    @name = properties['name']
    @funds = properties['funds'].to_i
  end

  def save()
    sql = "INSERT INTO customers (name, funds) VALUES ($1, $2) RETURNING id"
    values = [@name, @funds]
    user = SqlRunner.run( sql, values ).first
    @id = user['id'].to_i
  end

  def self.all()
    sql = "SELECT * FROM customers"
    values = []
    customers = SqlRunner.run(sql, values)
    result = customers.map { |customer| Customer.new(customer) }
    return result
  end

  def self.find(id)
    sql = "SELECT * FROM customers WHERE id = $1"
    values = [id]
    results = SqlRunner.run(sql, values)
    customer_hash = results.first
    customer = Customer.new(customer_hash)
    return customer
  end

  def update()
      sql = "UPDATE customers SET (name, funds) = ($1, $2) WHERE id = $3"
      values = [@name, @funds, @id]
      SqlRunner.run(sql, values)
    end

  def delete()
    sql = "DELETE FROM customers where id = $1"
    values = [@id]
    SqlRunner.run(sql, values)
  end

  def self.delete_all()
    sql = "DELETE FROM customers"
    values = []
    SqlRunner.run(sql, values)
  end

  def films()
    sql = "SELECT films.*
    FROM films INNER JOIN tickets
    ON films.id = tickets.film_id
    WHERE tickets.customer_id = $1"
    values = [@id]
    film_array = SqlRunner.run(sql, values)
    films = film_array.map {|film_hash| Film.new(film_hash)}
    return films
  end

  def buy_ticket(film)
    # if the customer has sufficient funds
    # sell ticket
    if sufficient_funds?(film)
      update_funds = @funds -= film.price()
      self.funds = update_funds
      self.update
      Ticket.sell_ticket(@id, film)
    end
  end

  def sufficient_funds?(film)
      return @funds >= film.price()
    end

    def self.order_by_name()
      sql = "SELECT * FROM customers ORDER BY name"
      values = []
      customers = SqlRunner.run(sql, values)
      result = customers.map { |customer| Customer.new(customer) }
      return result
    end

  end
