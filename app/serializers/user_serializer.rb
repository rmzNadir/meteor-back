class UserSerializer < ActiveModel::Serializer
  include Rails.application.routes.url_helpers
  attributes :id,
             :role,
             :email,
             :name,
             :last_name,
             :created_at,
             :image

  def image
    return unless object.image.attached?

    {
      id: object.image.id,
      filename: object.image.blob.filename,
      content_type: object.image.blob.content_type,
      url: url_for(object.image),
      created_at: object.image.created_at
    }
  end
end
