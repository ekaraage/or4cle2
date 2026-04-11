# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Rankings', type: :request do
  let(:user) { User.create!(name: 'testuser', password: 'p@ssW0rd_123') }
  let(:other_user) { User.create!(name: 'otheruser', password: 'p@ssW0rd_123') }
  let(:ranking) { Ranking.create!(title: 'Test Ranking', start_date: Time.current, end_date: Time.current + 1.day, user: user) }

  describe 'GET /rankings' do
    it 'success が返る' do
      get rankings_path
      expect(response).to have_http_status(:success)
    end
  end

  describe 'GET /rankings/new' do
    context 'ログインしているとき' do
      before { sign_in user }

      it 'success が返る' do
        get new_ranking_path
        expect(response).to have_http_status(:success)
      end
    end

    context 'ログインしていないとき' do
      it 'ログインページにリダイレクトされる' do
        get new_ranking_path
        expect(response).to redirect_to(new_user_session_path)
      end
    end
  end

  describe 'POST /rankings' do
    let(:valid_params) { { ranking: { title: 'New Ranking', start_date: Time.current, end_date: Time.current + 1.day } } }

    context 'ログインしているとき' do
      before { sign_in user }

      it '新しいランキングが作成され、ランキングにリダイレクトされる' do
        expect do
          post rankings_path, params: valid_params
        end.to change(Ranking, :count).by(1)
        expect(response).to redirect_to(ranking_songs_path(Ranking.last))
      end

      it 'パラメータが無効なときはエラーを表示する' do
        post rankings_path, params: { ranking: { title: '' } }
        expect(response).to have_http_status(:success) # renders :new
        expect(response.body).to include('field_with_errors')
      end

      it 'タイトルが81文字以上のときはエラーを表示する' do
        post rankings_path, params: { ranking: { title: 'a' * 81, start_date: Time.current, end_date: Time.current + 1.day } }
        expect(response).to have_http_status(:success) # renders :new
        expect(response.body).to include('field_with_errors')
      end

      it 'タイトルが80文字以内のときは成功する' do
        expect do
          post rankings_path, params: { ranking: { title: 'a' * 80, start_date: Time.current, end_date: Time.current + 1.day } }
        end.to change(Ranking, :count).by(1)
      end
    end
  end

  describe 'GET /rankings/:id/edit' do
    context 'ランキングの作成者であるとき' do
      before { sign_in user }

      it 'success を返す' do
        get edit_ranking_path(ranking)
        expect(response).to have_http_status(:success)
      end
    end

    context 'ランキングの作者ではないとき' do
      before { sign_in other_user }

      it '404 が返る' do
        get edit_ranking_path(ranking)
        expect(response).to have_http_status(:not_found)
      end
    end
  end

  describe 'PATCH /rankings/:id' do
    context 'ランキングの作成者であるとき' do
      before { sign_in user }

      it 'ランキングをアップデートしてリダイレクトする' do
        patch ranking_path(ranking), params: { ranking: { title: 'Updated Title' } }
        expect(ranking.reload.title).to eq('Updated Title')
        expect(response).to redirect_to(rankings_path)
      end
    end
  end

  describe 'DELETE /rankings/:id' do
    before { ranking } # ensure it exists

    context 'ランキングの作成者であるとき' do
      before { sign_in user }

      it 'ランキングを消去して、ランキング一覧にリダイレクトされる' do
        expect do
          delete ranking_path(ranking)
        end.to change(Ranking, :count).by(-1)
        expect(response).to redirect_to(rankings_path)
      end
    end
  end
end
