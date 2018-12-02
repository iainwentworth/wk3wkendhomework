require_relative("../db/sql_runner.rb")
require_relative("./customer.rb")


class Film

  attr_reader :id
  attr_accessor :title, :price

  def initialize(properties)
    @id = properties['id'].to_i if properties['id']
    @title = properties['title']
    @price = properties['price'].to_i
  end

  def save()
    sql = "INSERT INTO films (title, price) VALUES ($1, $2) RETURNING id"
    values = [@title, @price]
    film = SqlRunner.run( sql, values).first
    @id = film['id'].to_i
  end

  def self.all()
    sql = "SELECT * FROM films"
    values = []
    films = SqlRunner.run(sql, values)
    result = films.map { |film| Film.new(film) }
    return result
  end

  def self.find(id)
    sql = "SELECT * FROM films WHERE id = $1"
    values = [id]
    results = SqlRunner.run(sql, values)
    film_hash = results.first
    film = Film.new(film_hash)
    return film
  end

  def update()
    sql = "UPDATE films SET (title, price) = ($1, $2) WHERE id = $3"
    values = [@title, @price, @id]
    SqlRunner.run(sql, values)
  end

  def delete()
    sql = "DELETE FROM films where id = $1"
    values = [@id]
    SqlRunner.run(sql, values)
  end

  def self.delete_all()
    sql = "DELETE FROM films"
    values = []
    SqlRunner.run(sql, values)
  end

def customers ()
  sql = "SELECT customers.*
  FROM customers INNER JOIN tickets
  ON customers.id = tickets.customer_id
  WHERE tickets.film_id = $1"
  values = [@id]
  customer_array = SqlRunner.run(sql, values)
  customers = customer_array.map {|customer_hash| Customer.new(customer_hash)}
  return customers
end

end
