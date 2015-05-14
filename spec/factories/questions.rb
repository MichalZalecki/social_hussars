FactoryGirl.define do
  factory :question do
    title "Question Title"
    contents "Question lorem ipsum contents"
    user { FactoryGirl.create(:user, email: 'question_author@example.com') }
  end
  factory :new_question, class: Question do
    title "Question Title"
    contents "Question lorem ipsum contents"
    user nil
  end
end
