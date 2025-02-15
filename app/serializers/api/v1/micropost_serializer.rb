module Api
  module V1
    class MicropostSerializer < BaseSerializer
      attributes(*Micropost.attribute_names.map(&:to_sym))

      belongs_to :user, serializer: Api::V1::UserSerializer do
        include_data(false)
        link(:related) {api_v1_user_path(object.user_id)}
      end

      def picture
        object.picture.url
      end
    end
  end
end
