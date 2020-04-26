module Api
  module V1
      class FollowingsController < BaseController
      before_action :load_resource

      def index
        auth_followings = policy_scope(@followings)

        render json: auth_followings.collection,
          each_serializer: UserSerializer,
          adapter: :json_api,
          fields: {users: auth_followings.fields(params[:fields]).concat(
            [:microposts, :followers, :followings]
          )},
          include: [],
          meta: meta_attributes(auth_followings.collection)
      end

      #follow a user
      def create
        auth_following = FollowingPolicy.new(current_user, @relationship).create?

        @relationship.save!

        render json: auth_following.record, serializer: UserSerializer,
          adapter: :json_api
      end

      #unfollow a user
      def destroy
        auth_following = FollowingPolicy.new(current_user, @relationship).destroy?

        @relationship.destroy!

        render json: auth_following.record, serializer: UserSerializer,
          adapter: :json_api
      end

      private
      def load_resource
        case params[:action].to_sym
        when :index
          @followings = paginate(
            apply_filters(User.find(params[:user_id]).following, params)
          )
        when :create
          @relationship = Relationship.new(
            follower_id: params[:user_id],
            followed_id: params[:id]
          )
        when :destroy
          @relationship = Relationship.find_by!(
            follower_id: params[:user_id],
            followed_id: params[:id]
          )
        end
      end
    end
  end
end
