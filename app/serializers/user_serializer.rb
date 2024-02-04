class UserSerializer < ActiveModel::Serializer
  attributes :id, :username, :email, :post_count
  
  # Render in show user action only
  has_many :posts, if: -> { @instance_options[:show_posts]}

  def post_count
    object.posts.count
  end
end
