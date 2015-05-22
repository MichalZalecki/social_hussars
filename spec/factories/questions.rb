FactoryGirl.define do
  factory :question do
    title "Question Title"
    contents "Question lorem ipsum contents"
    user

    trait :with_answers do
      after(:create) do |question|
        create_list(:answer, 3, question: question)
      end
    end
  end
end
