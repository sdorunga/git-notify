class Contributor
  attr_reader :user_id, :user_name, :contributions

  def initialize(payload)
    @user_id       = payload[:id]
    @user_name     = payload[:login]
    @contributions = payload[:contributions]
    create_preferences
  end

  def create_preferences
    preference_storage.update_attributes({ name: @user_name })
  end

  def notify?
    preferences[:notify]
  end

  def followed_repos
    preferences[:followed_repos] || []
  end

  def preferences
    {
      name:           preference_storage.name,
      notify:         preference_storage.notify,
      followed_repos: preference_storage.followed_repos
    }
  end

  private

  def preference_storage
    @preference_storage ||= ContributorPreferences.find_or_create_by(git_id: user_id)
  end
end
