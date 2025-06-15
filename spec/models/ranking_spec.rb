# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Ranking, type: :model do
  let(:user) { User.create!(name: 'testuser', password: 'p@ssW0rd') }
  let(:other_user) { User.create!(name: 'otheruser', password: 'p@ssW0rd') }
  let(:start_date) { Time.current - 1.day }
  let(:end_date) { Time.current + 1.day }
  let(:ranking) do
    Ranking.create!(title: 'Test Ranking', start_date: start_date, end_date: end_date, detail: 'detail', user: user)
  end

  describe '#formatted_date' do
    it '開始日と終了日を正しいフォーマットで返すこと' do
      expect(ranking.formatted_date).to eq("#{start_date.strftime('%Y/%m/%d %H:%M')} ~ #{end_date.strftime('%Y/%m/%d %H:%M')}")
    end

    it 'start_dateまたはend_dateがnilの場合はエラーになること' do
      ranking.start_date = nil
      expect { ranking.formatted_date }.to raise_error(NoMethodError)
    end
  end

  describe '#active?' do
    it '現在時刻が期間内ならtrueを返すこと' do
      expect(ranking.active?).to be true
    end

    it '現在時刻が期間外ならfalseを返すこと' do
      ranking.start_date = Time.current - 3.days
      ranking.end_date = Time.current - 2.days
      expect(ranking.active?).to be false
    end
  end

  describe '#made_by?' do
    it '作成者が一致する場合trueを返すこと' do
      expect(ranking.made_by?(user)).to be true
    end

    it '作成者が一致しない場合falseを返すこと' do
      expect(ranking.made_by?(other_user)).to be false
    end

    it '引数がnilの場合falseを返すこと' do
      expect(ranking.made_by?(nil)).to be false
    end
  end
end
