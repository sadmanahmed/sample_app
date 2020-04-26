module Api
  module V1
    class UsersController < BaseController
      before_action :load_resource
      #skip_before_action :authenticate_user!, only: [:index, :show, :create, :activate]
      #before_action :authenticate_user, only: [:index, :show]

      def index
        auth_users = policy_scope(@users)
         #binding.pry
        render json: auth_users.collection,
          each_serializer: UserSerializer,
          fields: {user: auth_users.fields(params[:fields])},
          meta: meta_attributes(auth_users.collection),
          adapter: :json_api
      end

      def show
        auth_user = authorize_with_permissions(@user)

        render json: auth_user.record, serializer: UserSerializer,adapter: :json_api,
          fields: {user: auth_user.fields}
      end

      def create
        auth_user = authorize_with_permissions(@user)

        if @user.save && @user.send_activation_email && @user.activate
          render json: auth_user.record, serializer: UserSerializer,
            fields: {user: auth_user.fields}, status: 201, scope: @user , adapter: :json_api
        else
          invalid_resource!(@user.errors)
        end
      end

      def update
        auth_user = authorize_with_permissions(@user, :update?)

        if @user.update(update_params)
          render json: auth_user.record, serializer: UserSerializer , adapter: :json_api,
            fields: {user: auth_user.fields}
        else
          invalid_resource!(@user.errors)
        end
      end

      def destroy
        auth_user = authorize_with_permissions(@user, :destroy?)

        @user.destroy!

        render json: auth_user.record, serializer: UserSerializer, adapter: :json_api,
          fields: {user: auth_user.fields}
      end

      def activate
        auth_user = authorize_with_permissions(@user, :activate?)

        if @user.authenticated?(:activation, params[:token])
          render json: auth_user.record, serializer: UserSerializer, adapter: :json_api,
            fields: {user: auth_user.fields}, status: 200, scope: @user
        else
          not_found!
        end
      end

      private
        def load_resource
          case params[:action].to_sym
          when :index
            @users = paginate(apply_filters(User.all, params))
          when :create
            @user = User.new(create_params)
          when :show, :update, :destroy
            @user = User.find(params[:id])
          when :activate
            @user = User.find_by!(email: params[:email])
          end
        end

        def create_params
          normalized_params.permit(
            :email, :password, :password_confirmation, :name
          )
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
