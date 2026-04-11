# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Homes', type: :request do
  describe 'GET /' do
    it 'returns http success' do
      get root_path
      expect(response).to have_http_status(:success)
    end
  end

  describe 'GET /faqs' do
    it 'returns http success' do
      get faqs_path
      expect(response).to have_http_status(:success)
    end
  end

  describe 'GET /release_notes' do
    it 'returns http success' do
      get release_notes_path
      expect(response).to have_http_status(:success)
    end
  end
end
