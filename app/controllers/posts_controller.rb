class PostsController < ApplicationController
    before_action :authorize_request
    before_action :find_post, except: [:create, :index]

    def create
        @post = current_user.posts.new(post_params)
        if @post.save
            @post.file.attach(params[:file])
            render json: @post, status: :ok
        else
            render json: { errors: @post.errors.full_messages }, status: :unprocessable_entity
        end
    end

    def index
        @posts = current_user.posts
        render json: @posts, status: :ok
    end
    
    def show
        render json: @post, status: :ok
    end

    def destroy
        @post.destroy
        head :no_content
    end
    
    private
        def find_post
            @post = current_user.posts.find_by(id: params[:id])
            if @post
                return @post
            else
                render json: { errors: 'Post not found' }, status: :not_found
            end
        end

        def post_params
            params.require(:post).permit(:title, :file)
        end     
end
