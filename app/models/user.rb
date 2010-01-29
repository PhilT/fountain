class User < ActiveRecord::Base
  acts_as_authentic do |c|
    c.validate_password_field           = false
  end

  def email_address_with_name
    "#{name} <#{email}>"
  end
end

