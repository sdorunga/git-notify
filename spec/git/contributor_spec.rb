require 'spec_helper'

describe Contributor do
  def pull_request_fixture
    Oj.load(File.read(File.join(__dir__, "../fixtures/pull_request_open.json")), symbol_keys: true)
  end

  let(:payload) do
    pull_request_fixture[:sender]
  end

  let(:notification_toggle) { true }
  let(:user_name)           { "git name" }
  let(:slack_username)      { "slack username" }
  let(:followed_repos)      { ["first_repo", "second repo"] }
  let(:contributor_preferences) do
    ContributorPreferences.new(
      name:           user_name,
      notify:         notification_toggle,
      slack_username: slack_username,
      followed_repos: followed_repos
    )
  end

  subject { described_class.new(payload) }

  before do
    allow(ContributorPreferences).to receive(:find_or_create_by).and_return(contributor_preferences)
  end

  describe "#new" do
    it 'calls out to ContributorPreferences' do
      expect(ContributorPreferences).to receive(:find_or_create_by).with({ git_id: payload[:id] })
      subject
    end
  end

  describe "#notify?" do
    it 'delegates to the contributor preferences notify' do
      expect(subject.notify?).to eq(notification_toggle)
    end
  end

  describe "#followed_repos" do
    it 'delegates to the contributor preferences followed_repos' do
      expect(subject.followed_repos).to eq(followed_repos)
    end
  end

  describe "#slack_username" do
    it 'delegates to the contributor preferences slack_username' do
      expect(subject.slack_username).to eq(slack_username)
    end
  end
end
