user = User.create! email: 'user@example.com', password: 'abc123456', password_confirmation: 'abc123456'
other_user = User.create! email: 'other_user@example.com', password: 'abc123456', password_confirmation: 'abc123456'
User.create! email: 'few_points@example.com', password: 'abc123456', password_confirmation: 'abc123456', points: 5
User.create! email: 'lot_points@example.com', password: 'abc123456', password_confirmation: 'abc123456', points: 1005

10.times { Question.create! title: FFaker::Lorem.sentence, contents: FFaker::Lorem.paragraph, user: user }
question = Question.create! title: FFaker::Lorem.sentence, contents: FFaker::Lorem.paragraph, user: user

3.times { Answer.create! contents: FFaker::Lorem.paragraph, user: other_user, question: question }
