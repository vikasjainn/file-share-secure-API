class AuthenticationController < ApplicationController
    before_action :authorize_request, except: :login

    def login
        @user = User.find_by_email(params[:email])
        # if @user && @user.authenticate(params[:password])
        # &. (safe navigation) checkes if LHS is nil, if not, then performs the RHS (method call, property access, etc)
        if @user&.authenticate(params[:password])
            token = JsonWebToken.encode(user_id: @user.id)
            time = Time.now + 24.hours.to_i
            render json: { token: token, exp: time.strftime("%m-%d-%Y %H:%M"),
                            username: @user.username }, status: :ok
        else
            render json: { error: 'unauthorized' }, status: :unauthorized
        end
    end

    def logout
        render json: { message: 'Logged out successfully' }, status: :ok
    end

    private
    def login_params
        params.permit(:email, :password)
    end
end
