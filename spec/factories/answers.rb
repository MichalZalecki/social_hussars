FactoryGirl.define do
  factory :answer do
    contents "Answer lorem ipsum contents"
    user nil
    question nil

    trait :with_author do
      user FactoryGirl.build(:user, :answer_author)
    end
  end

end
