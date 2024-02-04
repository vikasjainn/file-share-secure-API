class UsersController < ApplicationController
    # before_action :authorize_request, except: :create
    # before_action :find_user, only: [:show, :destroy]
    # validates :password, presence: true, length: { minimum: 6 }, if: :skip_validations?

    

    def create
        @user = User.new(user_params)
        if @user.save
            render json: @user, status: :created
        else
            render json: { errors: @user.errors.full_messages },
                status: :unprocessable_entity
        end
    end


    def index
        @users = User.all
        render json: @users, status: :ok
    end
    
    def show
        if @user == current_user
            render json: @user, show_posts: true, status: :ok
        else
            render json: { error: 'Unauthorized' }, status: :unauthorized
        end
    end


    def destroy
        if @user = current_user
            @user.destroy
            head :no_content
        else
            render json: { error: 'Unauthorized' }, status: :unauthorized
        end
    end


    private
    def user_params
        params.permit( :username, :email, :password, :password_confirmation )
    end

    def find_user
        @user = User.find_by(id: params[:id])
        unless @user
            render json: { error: 'User not found' }, status: :not_found
        end
    end
   
end
