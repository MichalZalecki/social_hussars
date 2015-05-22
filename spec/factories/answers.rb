FactoryGirl.define do
  factory :answer do
    contents "Answer lorem ipsum contents"
    accepted false
    user
    question

    trait :accepted do
      accepted true
    end
  end
end
