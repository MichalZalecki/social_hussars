FactoryGirl.define do
  factory :question do
    title "Question Title"
    contents "Question lorem ipsum contents"
    user { FactoryGirl.create(:user, email: 'question_author@example.com') }
  end

end
