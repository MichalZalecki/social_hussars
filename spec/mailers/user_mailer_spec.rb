require "rails_helper"

RSpec.describe UserMailer, type: :mailer do
  describe "question_answered" do
    let(:mail) { UserMailer.question_answered }

    it "renders the headers" do
      expect(mail.subject).to eq("Question answered")
      expect(mail.to).to eq(["to@example.org"])
      expect(mail.from).to eq(["from@example.com"])
    end

    it "renders the body" do
      expect(mail.body.encoded).to match("Hi")
    end
  end

  describe "answer_accepted" do
    let(:mail) { UserMailer.answer_accepted }

    it "renders the headers" do
      expect(mail.subject).to eq("Answer accepted")
      expect(mail.to).to eq(["to@example.org"])
      expect(mail.from).to eq(["from@example.com"])
    end

    it "renders the body" do
      expect(mail.body.encoded).to match("Hi")
    end
  end

end
