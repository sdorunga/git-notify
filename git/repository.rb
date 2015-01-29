class Repository
  attr_reader :id, :preferences

  def initialize(id:)
    @id = id
    @repository = Octokit.repositories.detect { |repo| repo.id == @id }
    @preferences = RepositoryPreferences.find_or_create_by(git_id: id)
    @preferences.update_attributes(name: @repository[:name])
  end

  def name
    preferences.name
  end

  def contributors
    @contributors ||= contributor_data.map { |contributor| Contributor.new(contributor) }
  end

  def notifiable_contributors
    contributors.select(&:notify?)
  end

  def top_contributors
    return [] unless notify?
    notifiable_contributors.sort_by(&:contributions).
                 reverse.
                 take(contributors_pool).
                 sample(contributors_to_invoke)
  end

  def subscribers
    subscriber_ids = ContributorPreferences.all(followed_repos: id.to_s, notify: true).pluck(:git_id)
    contributors.select { |contributor| subscriber_ids.include?(contributor.user_id.to_s) }
  end

  private

  def notify?
    @preferences.active
  end

  def contributor_data
    @contributor_data ||= @repository.rels[:contributors].get.data
  end

  def contributors_pool
    ENV.fetch("CONTRIBUTORS_POOL").to_i
  end

  def contributors_to_invoke
    ENV.fetch("CONTRIBUTORS_TO_INVOKE").to_i
  end
end

