class ContributorPreferences
  include Mongoid::Document

  field :git_id, type: String
  field :name, type: String
  field :notify, type: Boolean
  field :followed_repos, type: Array, default: []

  def whitelisted_fields
    fields.keys.reject { |key| key == "_id" }
  end
end
