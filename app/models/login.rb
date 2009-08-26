class Login
  def self.valid?(password)
    password == ACCESS_PASSWORD
  end
end
