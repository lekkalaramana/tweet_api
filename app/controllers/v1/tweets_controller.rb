class V1::TweetsController < ApplicationController
	load_and_authorize_resource
	before_action :authenticate_user!
	before_action :set_tweet, only: [:show, :edit, :update, :destroy]

  def index
    @tweets = Tweet.order('created_at desc')
    render json: @tweets, status: :ok
  end

  def create
    @tweet = current_user.tweets.create(tweet_params)
    render_message(I18n.t('create.success'), 200)
  end

  def update
    @tweet.update(tweet_params)
    render_message(I18n.t('update.success'), 200)
  end

  def destroy
    @tweet.destroy
    render_message(I18n.t('destroy.success'), 200)
  end

  private

  def render_message(msg, status)
  	render json: { 'messages' => msg }, status: status
  end

  def set_tweet
    @tweet = Tweet.find(params[:id])
  end

  def tweet_params
    params.permit(:description)
  end
end
