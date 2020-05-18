require 'rails_helper'

describe 'Tweets API', type: :request do
  let(:current_user) { create(:user, email: 'user@example.com', password: '12345678') }
  let(:auth_headers) { current_user.create_new_auth_token }

  describe 'GET /api/v1/tweets' do

    context 'when the request is valid' do
    	before do
    		create(:tweet, user_id: current_user.id)
        get '/api/v1/tweets', headers: auth_headers
      end
      it 'returns tweets' do
        expect(response).to have_http_status(200)
        expect(json).not_to be_empty
        expect(json.size).to eq(1)
      end
    end

    context 'when sign in as different user' do
      before do
      	create(:tweet, user_id: current_user.id)
      	user2 = create(:user, email: 'user2@example.com', password: '12345678')
      	user2_headers = user2.create_new_auth_token
        get '/api/v1/tweets', headers: user2_headers
      end
      it 'returns tweets' do
        expect(response).to have_http_status(200)
        expect(json).not_to be_empty
        expect(json.size).to eq(1)
      end
    end

    context 'when the request is invalid' do
      before do
        get '/api/v1/tweets', headers: { }
      end
      it 'shows error message' do
        expect(response).to have_http_status(401)
        expect(json).not_to be_empty
        expect(json).to eq({ 'errors' => ['You need to sign in or sign up before continuing.'] })
      end
    end
  end

  describe 'POST /api/v1/tweets' do

    context 'when the request is valid' do
    	before do
        post '/api/v1/tweets', headers: auth_headers, params: { description: 'create something here' }
      end
      it 'returns newly created tweet' do
      	description = current_user.tweets.first.description
        expect(response).to have_http_status(200)
        expect(json).not_to be_empty
        expect(description).to eq('create something here')
        expect(json).to eq({'messages'=>'Tweet created successfully'})
      end
    end
  end

  describe 'PUT /api/v1/tweets/:id' do

    context 'when the request is valid' do
    	before do
    		tweet = create(:tweet, user_id: current_user.id)
        put "/api/v1/tweets/#{tweet.id}", headers: auth_headers, params: { description: 'update something here' }
      end
      it 'returns updated tweet' do
      	description = current_user.tweets.first.description
        expect(response).to have_http_status(200)
        expect(json).not_to be_empty
        expect(description).to eq('update something here')
        expect(json).to eq({'messages'=>'Tweet updated successfully'})
      end
    end

    context 'when the request is valid and signed in as admin' do
    	before do
    		admin_user = create(:user, email: 'user2@example.com', password: '12345678', admin: 1)
      	admin_headers = admin_user.create_new_auth_token
    		tweet = create(:tweet, user_id: current_user.id)
        put "/api/v1/tweets/#{tweet.id}", headers: admin_headers, params: { description: 'tweet updated by admin' }
      end
      it 'returns tweets' do
        description = current_user.tweets.first.description
        expect(response).to have_http_status(200)
        expect(json).not_to be_empty
        expect(description).to eq('tweet updated by admin')
        expect(json).to eq({'messages'=>'Tweet updated successfully'})
      end
    end

    context 'when the request is valid and signed in as different user and tries to update another user tweet' do
    	before do
    		user2 = create(:user, email: 'user2@example.com', password: '12345678')
      	user2_headers = user2.create_new_auth_token
    		tweet = create(:tweet, user_id: current_user.id)
        put "/api/v1/tweets/#{tweet.id}", headers: user2_headers, params: { description: 'update something here' }
      end
      it 'returns tweets' do
        expect(response).to have_http_status(401)
        expect(json).not_to be_empty
        expect(json).to eq({"errors"=>"Access denied"})
      end
    end
  end

  describe 'DELETE /api/v1/tweets/:id' do

    context 'when the request is valid' do
    	before do
    		tweet = create(:tweet, user_id: current_user.id)
        delete "/api/v1/tweets/#{tweet.id}", headers: auth_headers
      end
      it 'returns updated tweet' do
        expect(response).to have_http_status(200)
        expect(json).not_to be_empty
        expect(json).to eq({'messages'=>'Tweet deleted successfully'})
      end
    end

    context 'when the request is valid and signed in as admin' do
    	before do
    		admin_user = create(:user, email: 'user2@example.com', password: '12345678', admin: 1)
      	admin_headers = admin_user.create_new_auth_token
    		tweet = create(:tweet, user_id: current_user.id)
        delete "/api/v1/tweets/#{tweet.id}", headers: admin_headers
      end
      it 'returns tweets' do
        expect(response).to have_http_status(200)
        expect(json).not_to be_empty
        expect(json).to eq({'messages'=>'Tweet deleted successfully'})
      end
    end

    context 'when the request is valid and signed in as different user' do
    	before do
    		user2 = create(:user, email: 'user2@example.com', password: '12345678')
      	user2_headers = user2.create_new_auth_token
    		tweet = create(:tweet, user_id: current_user.id)
        delete "/api/v1/tweets/#{tweet.id}", headers: user2_headers
      end
      it 'returns tweets' do
        expect(response).to have_http_status(401)
        expect(json).not_to be_empty
        expect(json).to eq({"errors"=>"Access denied"})
      end
    end
  end
end
