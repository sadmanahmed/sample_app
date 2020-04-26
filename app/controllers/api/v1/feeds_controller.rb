module Api
  module V1

    class FeedsController < BaseController
      before_action :load_resource

      def show
        auth_microposts = policy_scope(@feed)

        render json: auth_microposts.collection,
          each_serializer: MicropostSerializer,
          fields: {micropost: auth_microposts.fields(params[:fields])},
          meta: meta_attributes(auth_microposts.collection),
          adapter: :json_api
      end

      private
        def load_resource
          case params[:action].to_sym
          when :show
            @feed = paginate(User.find(params[:user_id]).feed)
          end
        end
    end
  end
end
