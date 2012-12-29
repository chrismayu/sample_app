
# include utilties.rb
 
 
FactoryGirl.define do
  factory :user do
    sequence(:name)  { |n| "Person #{n}" }
    #name     "Chris Mailloux"
    
    sequence(:email) { |n| "person_#{n}@example.com"}  
    #email    "chris@morninglight.ca" 
    password "foobar"
    password_confirmation "foobar"

    factory :admin do
      admin true
    end
  end
  
  factory :micropost do
    content "Lorem ipsum"
    user
  end
  
end

