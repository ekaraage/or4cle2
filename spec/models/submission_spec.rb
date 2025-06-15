# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Submission, type: :model do
  let(:user) { User.create!(name: 'testuser', password: 'p@ssW0rd') }
  let(:ranking) do
    Ranking.create!(title: 'Test Ranking', user: user, start_date: Time.current - 1.day, end_date: Time.current + 1.day)
  end
  let(:song) { Song.create!(ranking: ranking, title: 'Test Song', model: 'TestModel') }

  describe 'バリデーション' do
    it '有効な属性なら有効であること' do
      submission = Submission.new(user: user, song: song, screen_name: 'tester', score: 100, comment: 'good!')
      expect(submission).to be_valid
    end

    it 'screen_nameが空なら無効であること' do
      submission = Submission.new(user: user, song: song, screen_name: nil, score: 100)
      expect(submission).not_to be_valid
      expect(submission.errors[:screen_name]).to include("can't be blank")
    end

    it 'scoreが負の値なら無効であること' do
      submission = Submission.new(user: user, song: song, screen_name: 'tester', score: -1)
      expect(submission).not_to be_valid
      expect(submission.errors[:score]).to include('must be greater than or equal to 0')
    end

    it 'screen_nameが21文字以上なら無効であること' do
      submission = Submission.new(user: user, song: song, screen_name: 'a' * 21, score: 10)
      expect(submission).not_to be_valid
      expect(submission.errors[:screen_name]).to include('is too long (maximum is 20 characters)')
    end

    it 'commentが141文字以上なら無効であること' do
      submission = Submission.new(user: user, song: song, screen_name: 'tester', score: 10, comment: 'a' * 141)
      expect(submission).not_to be_valid
      expect(submission.errors[:comment]).to include('is too long (maximum is 140 characters)')
    end
  end

  describe '#submitted_by?' do
    it 'userが同じならtrueを返すこと' do
      submission = Submission.new(user: user, song: song, screen_name: 'tester', score: 100)
      expect(submission.submitted_by?(user)).to be true
    end

    it 'userが異なればfalseを返すこと' do
      other_user = User.create!(name: 'otheruser', password: 'p@ssW0rd')
      submission = Submission.new(user: user, song: song, screen_name: 'tester', score: 100)
      expect(submission.submitted_by?(other_user)).to be false
    end
  end

  xdescribe '画像のバリデーション' do
    it '画像のバリデーションは後で実装する'
  end
end
