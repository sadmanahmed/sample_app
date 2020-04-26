module Api
  module V1

    class RootController < BaseController

      def options
        return head :ok
      end
    end
  end
end
