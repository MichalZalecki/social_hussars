FactoryGirl.define do
  factory :user do
    sequence(:username) { |n| "User #{n}" }
    sequence(:email) { |n| "user#{n}@example.com" }
    password 'abc123456'
    password_confirmation { password }
    points 100
  end
end
