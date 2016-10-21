class UserSerializer < ActiveModel::Serializer
  attributes :woo_id, :first_name, :last_name, :profile_picture_url, :cover_picture_url
end
