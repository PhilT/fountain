class User < ActiveRecord::Base
  acts_as_authentic

  validates_presence_of :name, :message => "Please enter your name."
  validates_presence_of :email, :message => "Please enter your Email Address."
  validates_presence_of :password, :on => :create, :message => "Please enter a password."

  validates_confirmation_of :password, :on => :create
  validates_confirmation_of :password, :on => :update, :allow_nil => true

  def email_address_with_name
    "#{name} <#{email}>"
  end

  def first_name
    self.name.split(' ').first
  end
end

