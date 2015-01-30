require_relative 'spec_helper'

describe RepositoryPreferences do
  describe "#notify" do
    it 'defaults the active field to false' do
      expect(subject.active).to eq(false)
    end
  end

  describe "#followed_repos" do
    it 'defaults subscribers field to an empty array' do
      expect(subject.subscribers).to eq([])
    end
  end

  describe "#whitelisted_fields" do
    it 'returns a list of all its fields without the _id' do
      expect(subject.whitelisted_fields).to eq(%w(git_id name active subscribers))
    end
  end
end

