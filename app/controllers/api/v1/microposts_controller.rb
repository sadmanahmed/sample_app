module Api
  module V1
      class MicropostsController < BaseController
      before_action :load_resource

      def index
        auth_microposts = policy_scope(@microposts)

        render json: auth_microposts.collection,
          each_serializer: MicropostSerializer,
          adapter: :json_api,
          fields: {micropost: auth_microposts.fields(params[:fields])},
          meta: meta_attributes(auth_microposts.collection)
      end

      def show
        auth_micropost = authorize_with_permissions(@micropost)

        render json: auth_micropost.record,
          serializer: MicropostSerializer,
          adapter: :json_api,
          fields: {micropost: auth_micropost.fields}
      end

      def create
        auth_micropost = authorize_with_permissions(@micropost)

        if @micropost.save
          render json: auth_micropost.record,
            serializer: MicropostSerializer,
          adapter: :json_api,
            fields: {mircopost: auth_micropost.fields}, status: 201
        else
          invalid_resource!(@micropost.errors)
        end
      end

      def update
        auth_micropost = authorize_with_permissions(@micropost, :update?)

        if @micropost.update(update_params)
          render json: auth_micropost.record,
            serializer: MicropostSerializer,
          adapter: :json_api,
            micropost: {user: auth_micropost.fields}
        else
          invalid_resource!(@micropost.errors)
        end
      end

      def destroy
        auth_micropost = authorize_with_permissions(@micropost, :destroy?)

        @micropost.destroy!

        render json: auth_micropost.record,
          serializer: MicropostSerializer,
          adapter: :json_api,
          micropost: {user: auth_micropost.fields}
      end

      private
        def load_resource
          case params[:action].to_sym
          when :index
            @microposts = paginate(apply_filters(Micropost.all, params))
          when :create
            @micropost = Micropost.new(create_params)
          when :show, :update, :destroy
            @micropost = Micropost.find(params[:id])
          end
        end

        def create_params
          prms = normalized_params.permit(
            :content, :picture, :user_id
          )
          if prms[:user_id].nil? && params[:action].to_sym == :create
            prms[:user_id] = current_user&.id
          end

          return prms
        end

        def update_params
          create_params
        end

        def normalized_params
          ActionController::Parameters.new(
             ActiveModelSerializers::Deserialization.jsonapi_parse(params)
          )
        end
    end
  end
end
