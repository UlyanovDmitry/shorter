class LinkSerializer < ActiveModel::Serializer
  include Rails.application.routes.url_helpers
  attributes :id, :destination_url, :short_url

  def id
    object.unique_key
  end

  def destination_url
    CGI.unescape object.url
  end

  def short_url
    link_path(object)
  end
end
