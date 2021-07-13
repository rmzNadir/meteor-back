class UserSerializerLight < ActiveModel::Serializer
  attributes :id,
             :name,
             :last_name
end
