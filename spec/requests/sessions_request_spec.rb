# frozen_string_literal: true

require 'rails_helper'

describe 'User Authentication API', type: :request do
  describe 'POST /api/auth/sign_in' do
    let(:user) { create(:user, email: 'user@example.com', password: '12345678') }

    context 'when the request is valid' do
      before { post '/api/auth/sign_in', params: { email: user.email, password: user.password } }
      it 'signs in and returns the user' do
        expect(response).to have_http_status(200)
        expect(json).not_to be_empty
        expect(json).to eq({"messages"=>"Signed_in successfully"})
        expect_header('uid', user.email)
        expect_header_contains('access-token', "#{response.headers['access-token']}")
        expect_header_contains('client', "#{response.headers['client']}")
      end
    end

    context 'when the request is invalid' do
      before { post '/api/auth/sign_in', params: { email: user.email, password: 'wrong' } }
      it 'returns status code 401' do
        expect(response).to have_http_status(401)
      end
      it 'returns an error message' do
        expect(json).not_to be_empty
        expect(json).to eq({"errors"=>"Invalid email or password."})
      end
    end
  end

  describe 'GET /api/auth/validate_token' do
    let(:current_user) { create(:user, email: 'user@example.com', password: '12345678') }
    let(:auth_headers) { current_user.create_new_auth_token }

    context 'when the request is valid and user is present' do
      before do
        get '/api/auth/validate_token', headers: auth_headers
      end
      it 'returns that user with 200' do
        expect(json).not_to be_empty
        expect(response).to have_http_status(200)
      end
    end

    context 'when the request is valid and user is present' do
      before do
        get '/api/auth/validate_token', headers: auth_headers
      end
      it 'returns that user with 200' do
        expect(json).not_to be_empty
        expect(response).to have_http_status(200)
      end
    end
  end

end
