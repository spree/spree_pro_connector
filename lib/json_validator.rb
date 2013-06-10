class JsonValidator < ActiveModel::EachValidator
  def validate_each object, attribute, value
    JSON.parse value if value.present?
  rescue JSON::ParserError
    object.errors[attribute] << I18n.t(:invalid, scope: "activerecord.errors.messages")
  end
end
