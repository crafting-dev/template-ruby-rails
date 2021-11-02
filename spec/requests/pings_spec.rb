# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Pings', type: :request do
  describe 'GET /ping' do
    it 'returns http success' do
      get '/ping?ping=hello'
      expect(response).to have_http_status(:success)
    end
  end
end
