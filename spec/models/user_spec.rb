# frozen_string_literal: true

require 'rails_helper'

RSpec.describe User, type: :model do
  xdescribe 'バリデーション' do
    subject { FactoryBot.build(:user) }

    it '有効なファクトリを持つこと' do
      expect(subject).to be_valid
    end

    it 'nameが必須であること' do
      subject.name = nil
      expect(subject).not_to be_valid
    end

    it 'nameが一意であること' do
      FactoryBot.create(:user, name: subject.name)
      expect(subject).not_to be_valid
    end

    it 'nameが30文字以内であること' do
      subject.name = 'a' * 31
      expect(subject).not_to be_valid
    end

    it 'nameが英数字とアンダースコアのみ許可されること' do
      subject.name = 'invalid name!'
      expect(subject).not_to be_valid
    end

    it 'passwordが複雑性バリデーションを通過すること' do
      # 複雑性バリデータの仕様に合わせて適切な値を設定してください
      subject.password = 'simple'
      expect(subject).not_to be_valid
    end
  end

  describe 'インスタンスメソッド' do
    let(:user) { User.create!(name: 'testuser', password: 'p@ssW0rd') }
    let(:ranking) do
      Ranking.create!(title: 'Test Ranking', user: user, start_date: Time.current - 1.day,
                      end_date: Time.current + 1.day)
    end
    let(:song) { Song.create!(ranking: ranking, title: 'Test Song', model: 'TestModel') }
    let(:submission) { Submission.create!(user: user, song: song, screen_name: 'tester', score: 100, comment: 'good!') }

    it 'email_required?がfalseを返すこと' do
      expect(user.email_required?).to eq(false)
    end

    it 'email_changed?がfalseを返すこと' do
      expect(user.email_changed?).to eq(false)
    end

    it 'will_save_change_to_email?がfalseを返すこと' do
      expect(user.will_save_change_to_email?).to eq(false)
    end

    describe '#can_edit_song_for_ranking?' do
      it 'アクティブかつ自分が作成者ならtrueを返すこと' do
        expect(user.can_edit_song_for_ranking?(ranking)).to eq(true)
      end

      it '非アクティブならfalseを返すこと' do
        allow(ranking).to receive(:active?).and_return(false)
        expect(user.can_edit_song_for_ranking?(ranking)).to eq(false)
      end

      it '自分が作成者でなければfalseを返すこと' do
        allow(ranking).to receive(:made_by?).with(user).and_return(false)
        expect(user.can_edit_song_for_ranking?(ranking)).to eq(false)
      end
    end

    describe '#can_submit_score?' do
      it 'アクティブかつ未提出ならtrueを返すこと' do
        allow(song.submissions).to receive(:find_by).with(user: user).and_return(nil)
        expect(user.can_submit_score?(song)).to eq(true)
      end

      it '非アクティブならfalseを返すこと' do
        allow(song).to receive(:active?).and_return(false)
        expect(user.can_submit_score?(song)).to eq(false)
      end

      it '既に提出済みならfalseを返すこと' do
        allow(song.submissions).to receive(:find_by).with(user: user).and_return(submission)
        expect(user.can_submit_score?(song)).to eq(false)
      end
    end

    describe '#can_edit_submission?' do
      it 'アクティブかつ自分の提出ならtrueを返すこと' do
        expect(user.can_edit_submission?(submission)).to eq(true)
      end

      it '非アクティブならfalseを返すこと' do
        allow(song).to receive(:active?).and_return(false)
        expect(user.can_edit_submission?(submission)).to eq(false)
      end

      it '自分の提出でなければfalseを返すこと' do
        allow(submission).to receive(:submitted_by?).with(user).and_return(false)
        expect(user.can_edit_submission?(submission)).to eq(false)
      end
    end
  end
end
