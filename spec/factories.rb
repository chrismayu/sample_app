FactoryGirl.define do
  factory :user do
    name     "Chris Mailloux"
    email    "chris@morninglight.ca"
    password "foobar"
    password_confirmation "foobar"
  end
end