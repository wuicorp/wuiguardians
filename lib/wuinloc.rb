require 'wuinloc/support'
require 'wuinloc/service'

module Wuinloc
  class << self
    attr_accessor :site, :client_id, :client_secret
  end
end
