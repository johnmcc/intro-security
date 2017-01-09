require 'pg'

class User
  # (Snip!)

  def self.authenticate(username, password)
    db = PG.connect({ host: 'localhost', dbname: 'injection_users' })
    sql = "SELECT * FROM injection_users WHERE username='#{username}' AND password='#{password}';"
    result = db.exec(sql)
    db.close
    return result.count > 0 ? true:false
  end

end