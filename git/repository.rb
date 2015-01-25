class Repository
  attr_reader :id
  def initialize(id:)
    @id = id
    @repository = Octokit.repositories.detect { |repo| repo.id == @id }
    @repository_preferences = RepositoryPreferences.find_or_create_by(git_id: id)
    @repository_preferences.update_attributes(name: @repository[:name])
  end

  def contributors
    contributor_data.map { |contributor| Contributor.new(contributor) }
  end

  def top_contributors
    contributors.sort_by(&:contributions).
                 reverse.
                 take(5)
  end

  private

  def contributor_data
    @contributor_data ||= @repository.rels[:contributors].get.data
  end
end

