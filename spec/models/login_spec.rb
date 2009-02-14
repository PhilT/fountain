require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Login do

  it "should be valid when correct password is given" do
    Login.valid?(ADMIN_PASSWORD).should be_true
  end

  it "should not be valid when incorrect password is given" do
    Login.valid?('some password').should be_false
  end
end
