FactoryGirl.define do
  factory :user do
    email 'user@example.com'
    password 'abc123456'
    password_confirmation { password }
    points nil

    trait :other_user do
      email 'other_user@example.com'
    end

    trait :answer_author do
      email 'answer_author@example.com'
    end
  end
end
