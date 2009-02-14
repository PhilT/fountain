class Login
  def self.valid?(password)
    password == ADMIN_PASSWORD
  end
end
