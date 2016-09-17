class PictureSerializer < ActiveModel::Serializer
  attributes :url, :type

  def type
    object.picture_type
  end
end
