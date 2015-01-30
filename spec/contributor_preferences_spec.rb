require_relative 'spec_helper'

describe ContributorPreferences do
  describe "#notify" do
    it 'defaults the notify field to false' do
      expect(subject.notify).to eq(false)
    end
  end

  describe "#followed_repos" do
    it 'defaults followed_repos field to an empty array' do
      expect(subject.followed_repos).to eq([])
    end
  end

  describe "#whitelisted_fields" do
    it 'returns a list of all its fields without the _id' do
      expect(subject.whitelisted_fields).to eq(%w(git_id name slack_username notify followed_repos))
    end
  end
end
