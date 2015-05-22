FactoryGirl.define do
  factory :answer do
    contents "Answer lorem ipsum contents"
    user
    question
  end
end
