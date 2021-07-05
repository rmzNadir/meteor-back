class UserSerializer < ActiveModel::Serializer
  attributes :id,
             :email,
             :name,
             :last_name,
             :created_at
end
