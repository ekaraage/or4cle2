# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Song, type: :model do
  let(:user) { User.create!(name: 'testuser', password: 'p@ssW0rd') }
  let(:start_date) { Time.current - 1.day }
  let(:end_date) { Time.current + 1.day }
  let(:ranking) { Ranking.create!(title: 'Test Ranking', user: user, start_date: start_date, end_date: end_date) }

  describe 'バリデーション' do
    it '有効な属性なら有効であること' do
      song = Song.new(ranking: ranking, title: 'Test Song', model: 'TestModel')
      expect(song).to be_valid
    end

    it 'titleが空なら無効であること' do
      song = Song.new(ranking: ranking, title: nil, model: 'TestModel')
      expect(song).not_to be_valid
      expect(song.errors[:title]).to include("can't be blank")
    end

    it 'modelが31文字以上なら無効であること' do
      song = Song.new(ranking: ranking, title: 'Test Song', model: 'a' * 31)
      expect(song).not_to be_valid
      expect(song.errors[:model]).to include('is too long (maximum is 30 characters)')
    end
  end

  describe '#added_by?' do
    it 'rankingのuserと同じuserならtrueを返すこと' do
      song = Song.new(ranking: ranking, title: 'Test Song', model: 'TestModel')
      expect(song.added_by?(user)).to be true
    end

    it 'rankingのuserと異なるuserならfalseを返すこと' do
      other_user = User.create!(name: 'otheruser', password: 'p@ssW0rd')
      song = Song.new(ranking: ranking, title: 'Test Song', model: 'TestModel')
      expect(song.added_by?(other_user)).to be false
    end
  end
end
