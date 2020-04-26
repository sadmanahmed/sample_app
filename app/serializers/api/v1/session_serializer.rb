
module Api
  module V1
    class SessionSerializer < BaseSerializer
      type :session

      attributes :email, :token, :user_id

      has_one :user, serializer: UserSerializer do
        link(:self) {api_v1_user_path(object.id)}
        link(:related) {api_v1_user_path(object.id)}

        object
      end

      def user
        object
      end

      def user_id
        object.id
      end

      def token
        object.token
      end

      def email
        object.email
      end
    end
  end
end
