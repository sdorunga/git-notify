class Repository
  attr_reader :id

  def initialize(id:)
    @id = id
    @repository = Octokit.repositories.detect { |repo| repo.id == @id }
    @repository_preferences = RepositoryPreferences.find_or_create_by(git_id: id)
    @repository_preferences.update_attributes(name: @repository[:name])
  end

  def notifiable_contributors
    contributor_data.map { |contributor| Contributor.new(contributor) }.select(:notify?)
  end

  def top_contributors
    return [] unless notify?
    notifiable_contributors.sort_by(&:contributions).
                 reverse.
                 take(contributors_pool).
                 sample(contributors_to_invoke)
  end

  private

  def notify?
    @repository_preferences.notify?
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

