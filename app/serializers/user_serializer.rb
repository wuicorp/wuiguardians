class UserSerializer < ActiveModel::Serializer
  attributes :id, :email, :name, :vehicles
end
