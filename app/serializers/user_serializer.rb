class UserSerializer < ActiveModel::Serializer
  attributes :id,
             :role,
             :email,
             :name,
             :last_name,
             :created_at
end
