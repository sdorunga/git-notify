class ContributorPreferences
  include Mongoid::Document

  field :git_id, type: String
  field :name, type: String
  field :slack_username, type: String
  field :notify, type: Boolean, default: false
  field :followed_repos, type: Array, default: []

  def whitelisted_fields
    fields.keys.reject { |key| key == "_id" }
  end
end
