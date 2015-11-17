class FlagSerializer < ActiveModel::Serializer
  attributes :id, :longitude, :latitude, :radius, :created_at, :updated_at
end
