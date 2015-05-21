FactoryGirl.define do
  factory :question do
    title "Question Title"
    contents "Question lorem ipsum contents"
    user
  end
end
