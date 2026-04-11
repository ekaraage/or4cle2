# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Submissions', type: :request do
  let(:user) { User.create!(name: 'testuser', password: 'p@ssW0rd_123') }
  let(:other_user) { User.create!(name: 'otheruser', password: 'p@ssW0rd_123') }
  let(:ranking) { Ranking.create!(title: 'Test Ranking', start_date: Time.current - 1.day, end_date: Time.current + 1.day, user: user) }
  let(:song) { Song.create!(title: 'Test Song', model: 'Test Model', ranking: ranking) }
  let(:submission) { Submission.create!(song: song, user: user, score: 100, screen_name: 'testuser') }

  describe 'GET /rankings/:ranking_id/songs/:song_id/submissions' do
    it 'success を返す' do
      get ranking_song_submissions_path(ranking, song)
      expect(response).to have_http_status(:success)
    end
  end

  describe 'GET /rankings/:ranking_id/songs/:song_id/submissions/:id' do
    it 'success を返す' do
      get ranking_song_submission_path(ranking, song, submission)
      expect(response).to have_http_status(:success)
    end
  end

  describe 'POST /rankings/:ranking_id/songs/:song_id/submissions' do
    let(:valid_params) { { submission: { score: 200, screen_name: 'newuser', comment: 'nice song' } } }

    context 'ログインしているとき' do
      before { sign_in other_user }

      it '新しい提出が作成され、提出一覧にリダイレクトされる' do
        expect do
          post ranking_song_submissions_path(ranking, song), params: valid_params
        end.to change(Submission, :count).by(1)
        expect(response).to redirect_to(ranking_song_submissions_path(ranking, song))
      end

      it 'スコアが負のときはエラーを表示する' do
        post ranking_song_submissions_path(ranking, song), params: { submission: { score: -1, screen_name: 'user' } }
        expect(response).to have_http_status(:success) # renders :new
        expect(response.body).to include('field_with_errors')
      end

      it '表示名が21文字以上のときはエラーを表示する' do
        post ranking_song_submissions_path(ranking, song), params: { submission: { score: 100, screen_name: 'a' * 21 } }
        expect(response).to have_http_status(:success) # renders :new
        expect(response.body).to include('field_with_errors')
      end

      it '表示名が20文字以内のときは成功する' do
        expect do
          post ranking_song_submissions_path(ranking, song), params: { submission: { score: 100, screen_name: 'a' * 20 } }
        end.to change(Submission, :count).by(1)
      end
    end

    context 'すでに提出済みのとき' do
      before { sign_in user }
      before { submission } # user already has a submission

      it '提出は作成されず、提出一覧にリダイレクトされる' do
        expect do
          post ranking_song_submissions_path(ranking, song), params: valid_params
        end.not_to change(Submission, :count)
        expect(response).to redirect_to(ranking_song_submissions_path(ranking, song))
      end
    end
  end

  describe 'PATCH /rankings/:ranking_id/songs/:id/submissions/:id' do
    before { sign_in user }

    it '提出をアップデートしてリダイレクトする' do
      patch ranking_song_submission_path(ranking, song, submission), params: { submission: { score: 150 } }
      expect(submission.reload.score).to eq(150)
      expect(response).to redirect_to(ranking_song_submissions_path(ranking, song))
    end
  end

  describe 'DELETE /rankings/:ranking_id/songs/:id/submissions/:id' do
    before { submission }
    before { sign_in user }

    it '提出を消去してリダイレクトする' do
      expect do
        delete ranking_song_submission_path(ranking, song, submission)
      end.to change(Submission, :count).by(-1)
      expect(response).to redirect_to(ranking_song_submissions_path(ranking, song))
    end
  end

  describe 'GET /rankings/:ranking_id/songs/:song_id/submissions/export_csv' do
    before { sign_in user }

    it 'CSVをダウンロードする' do
      get export_csv_ranking_song_submissions_path(ranking, song, format: :csv)
      expect(response).to have_http_status(:success)
      expect(response.header['Content-Type']).to include('text/csv')
    end
  end
end
