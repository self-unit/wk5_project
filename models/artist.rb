require_relative('../db/sql_runner.rb')

class Artist
  attr_reader :id
  attr_accessor :first_name, :last_name, :bio, :link

  def initialize( options )
    @id = options['id'].to_i if options['id']
    @first_name = options['first_name']
    @last_name = options['last_name'] if options['last_name']
    @bio = options['bio']
    @link = options['link']
  end

  def full_name
    return "#{@first_name} #{@last_name}"
  end

  def save
    sql = "INSERT INTO artists
    (first_name, last_name, bio, link)
    VALUES
    ($1, $2, $3, $4)
    RETURNING id"
    values = [@first_name, @last_name, @bio, @link]
    results = SqlRunner.run(sql, values)
    @id = results.first()['id'].to_i
  end

  def edit
    sql = "UPDATE artists
    SET (first_name, last_name, bio, link) =
    ($1, $2, $3, $4)
    WHERE id = $5"
    values = [@first_name, @last_name, @bio, @link, @id]
    SqlRunner.run(sql, values)
  end

  def exhibits
    sql = "SELECT * FROM exhibits
    WHERE artist_id = $1"
    values = [@id]
    returned_array = SqlRunner.run(sql, values)
    return returned_array.map{ |exhibit| Exhibit.new( exhibit ) }
  end

  def exhibit_names
    objects_array = self.exhibits
    titles = objects_array.map{ |exhibit| exhibit.title }
    return titles
  end

  def delete
    sql = "DELETE FROM artists
    WHERE id = $1"
    values = [@id]
    SqlRunner.run(sql, values)
  end

  def self.all
    sql = "SELECT * FROM artists"
    values = []
    returned_array = SqlRunner.run(sql, values)
    return returned_array.map { |artist| Artist.new( artist ) }
  end

  def self.find(id)
    sql = "SELECT * FROM artists
    WHERE id = $1"
    values = [id]
    returned_array = SqlRunner.run(sql, values)
    return returned_array.map{ |artist| Artist.new( artist ) }
  end

  def self.delete_all
    sql = "DELETE FROM artists"
    values = []
    SqlRunner.run(sql, values)
  end

end
