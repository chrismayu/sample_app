namespace :db do
  desc "Fill database with sample data"
  task populate: :environment do
    make_users
   
  end
end

def make_users
  admin = User.create!(name:     "Chris - Morninglight",
                       email:    "example@morninglight.ca",
                       password: "morninglight",
                       password_confirmation: "morninglight")
  admin.toggle!(:admin)
  150.times do |n|
    name  = Faker::Name.name
    email = "fake_person-#{n+1}@morninglight.ca"
    password  = "password"
    User.create!(name:     name,
                 email:    email,
                 password: password,
                 password_confirmation: password)
  end
end
