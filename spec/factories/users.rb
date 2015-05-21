FactoryGirl.define do
  factory :user do
    email 'user@example.com'
    password 'abc123456'
    password_confirmation { password }

    trait :other_user do
      email 'other_user@example.com'
    end
  end
end
