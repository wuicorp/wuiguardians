class WuiSerializer < ActiveModel::Serializer
  attributes :id, :wui_type, :status, :updated_at, :vehicle,
             :latitude, :longitude
end
