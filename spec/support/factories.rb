Factory.sequence :email do |n|
  "person#{n}@example.com"
end

Factory.define :page do |f|
  f.name "PageName"
  f.title "Page Title"
end

Factory.define :user do |f|
  f.name 'A User'
  f.password 'password'
  f.password_confirmation 'password'
  f.email { Factory.next :email }
end

