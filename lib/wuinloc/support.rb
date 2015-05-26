module Wuinloc
  module Support
    def wuinloc_service
      @wuinloc_service ||= Wuinloc::Service.new
    end
  end
end
