class SessionsController < DeviseTokenAuth::SessionsController

	def create
		user = User.find_for_database_authentication(email: user_params[:email])
		if user&.valid_password?(user_params[:password])
			response.headers.merge!(user.create_new_auth_token)
			render json: { 'messages' => I18n.t('sessions.signed_in') }, status: :ok
		else
			render json: { 'errors' => I18n.t('sessions.invalid_email_or_password') }, status: 401
		end
	end

	private

	def user_params
		params.permit(:email, :password)
	end
end