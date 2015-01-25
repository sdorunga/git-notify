class Repository
  def initialize(id:)
    @id = id
    @repository = Octokit.repositories.detect { |repo| repo.id == @id }
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

