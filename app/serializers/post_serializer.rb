class PostSerializer < ActiveModel::Serializer
  include Rails.application.routes.url_helpers
  
  
  attributes :id, :title, :username, :file_url

  def username
    object.user.username
  end

  def file_url
    if object.file.attached?
      rails_blob_path(object.file, only_path: true)
    end
  end
end
