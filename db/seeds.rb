user = User.create! username: 'user', email: 'user@example.com', password: 'abc123456', password_confirmation: 'abc123456', points: 300
other_user = User.create! username: 'Other user', email: 'other_user@example.com', password: 'abc123456', password_confirmation: 'abc123456'
User.create! username: 'Few points', email: 'few_points@example.com', password: 'abc123456', password_confirmation: 'abc123456', points: 5
User.create! username: 'Lot points', email: 'lot_points@example.com', password: 'abc123456', password_confirmation: 'abc123456', points: 1005

20.times { Question.create! title: FFaker::Lorem.sentence, contents: FFaker::Lorem.paragraph, user: user }
question = Question.create! title: FFaker::Lorem.sentence, contents: FFaker::Lorem.paragraph, user: user
5.times { Question.create! title: FFaker::Lorem.sentence, contents: FFaker::Lorem.paragraph, user: other_user }

3.times { Answer.create! contents: FFaker::Lorem.paragraph, user: other_user, question: question }
