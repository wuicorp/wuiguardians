class Wui < ActiveRecord::Base
  belongs_to :owner, class_name: 'User'
  belongs_to :receiver, class_name: 'User'
end
