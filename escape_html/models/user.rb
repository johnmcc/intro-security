require 'pg'

class User
  attr_accessor :id, :name, :age, :bio

  def initialize(options)
    @id = options['id']
    @name = options['name']
    @age = options['age']
    @bio = options['bio']
  end

  def self.get(id)
    db = PG.connect({ host: 'localhost', dbname: 'escape_html' })
    sql = "SELECT * FROM escape_html_users WHERE id=#{id}"
    result = db.exec(sql)
    return User.new(result[0])
  end
end