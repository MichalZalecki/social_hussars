user = User.create! email: 'user@example.com', password: 'abc123456', password_confirmation: 'abc123456'

10.times { Question.create! title: FFaker::Lorem.sentence, contents: FFaker::Lorem.paragraph, user: user }
