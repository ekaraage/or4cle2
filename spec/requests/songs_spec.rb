# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Songs', type: :request do
  let(:user) { User.create!(name: 'testuser', password: 'p@ssW0rd_123') }
  let(:other_user) { User.create!(name: 'otheruser', password: 'p@ssW0rd_123') }
  let(:ranking) { Ranking.create!(title: 'Test Ranking', start_date: Time.current - 1.day, end_date: Time.current + 1.day, user: user) }
  let(:song) { Song.create!(title: 'Test Song', model: 'Test Model', ranking: ranking) }

  describe 'GET /rankings/:ranking_id/songs' do
    it 'success を返す' do
      get ranking_songs_path(ranking)
      expect(response).to have_http_status(:success)
    end
  end

  describe 'POST /rankings/:ranking_id/songs' do
    let(:valid_params) { { song: { title: 'New Song', model: 'New Model' } } }

    context 'ログインしているとき' do
      before { sign_in user }

      it '新しい曲が作成され、曲一覧にリダイレクトされる' do
        expect do
          post ranking_songs_path(ranking), params: valid_params
        end.to change(Song, :count).by(1)
        expect(response).to redirect_to(ranking_songs_path(ranking))
      end

      it '機種名が31文字以上のときはエラーを表示する' do
        post ranking_songs_path(ranking), params: { song: { title: 'New Song', model: 'a' * 31 } }
        expect(response).to have_http_status(:success) # renders :new
        expect(response.body).to include('field_with_errors')
      end

      it '機種名が30文字以内のときは成功する' do
        expect do
          post ranking_songs_path(ranking), params: { song: { title: 'New Song', model: 'a' * 30 } }
        end.to change(Song, :count).by(1)
      end
    end
  end

  describe 'PATCH /rankings/:ranking_id/songs/:id' do
    before { sign_in user }

    it '曲をアップデートしてリダイレクトする' do
      patch ranking_song_path(ranking, song), params: { song: { title: 'Updated Song' } }
      expect(song.reload.title).to eq('Updated Song')
      expect(response).to redirect_to(ranking_songs_path(ranking))
    end
  end

  describe 'DELETE /rankings/:ranking_id/songs/:id' do
    before { song }
    before { sign_in user }

    it '曲を消去してリダイレクトする' do
      expect do
        delete ranking_song_path(ranking, song)
      end.to change(Song, :count).by(-1)
      expect(response).to redirect_to(ranking_songs_path(ranking))
    end
  end

  describe 'GET /rankings/:ranking_id/songs/export_csv' do
    before { sign_in user }

    it 'CSVをダウンロードする' do
      get export_csv_ranking_songs_path(ranking)
      expect(response).to have_http_status(:success)
      expect(response.header['Content-Type']).to include('application/zip')
    end
  end
end
