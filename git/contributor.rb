class Contributor
  attr_reader :user_id, :user_name, :contributions

  def initialize(payload)
    @user_id       = payload[:id]
    @user_name     = payload[:login]
    @contributions = payload[:contributions]
    create_preferences
  end

  def create_preferences
    if preference_storage.slack_username
      preference_storage.update_attributes({ name: @user_name })
    else
      preference_storage.update_attributes({ name: @user_name, slack_username: @user_name })
    end
  end

  def notify?
    preferences[:notify]
  end

  def followed_repos
    preferences[:followed_repos] || []
  end

  def slack_username
    preferences[:slack_username] || []
  end

  def preferences
    {
      name:           preference_storage.name,
      notify:         preference_storage.notify,
      slack_username: preference_storage.slack_username,
      followed_repos: preference_storage.followed_repos
    }
  end

  private

  def preference_storage
    @preference_storage ||= ContributorPreferences.find_or_create_by(git_id: user_id)
  end
end
