class RepositoryPreferences
  include Mongoid::Document

  field :git_id, type: String
  field :name, type: String
  field :active, type: Boolean, default: false
  field :subscribers, type: Array

  def whitelisted_fields
    fields.keys.reject { |key| key == "_id" }
  end
end

