require 'spec_helper'
require 'rspec/expectations'

module Git
  def pull_request_fixture
    Oj.load(File.read(File.join(__dir__, "../fixtures/pull_request_open.json")), symbol_keys: true)
  end

  describe Repository do
    let(:repo_id) { pull_request_fixture[:repository][:id] }

    subject { described_class.new(id: repo_id) }

    describe "#contributors" do
      it 'returns a list of all contributors' do
        expect(subject.contributors.map(&:user_name)).to eq(["sdorunga-sb", "sdorunga1"])
      end
    end

    describe "#notifiable_contributors" do
      before do
        subject.contributors.each { |contributor| ContributorPreferences.find_by(git_id: contributor.user_id).update_attributes(notify: false) }
        ContributorPreferences.find_by(git_id: subject.contributors.last.user_id).update_attributes(notify: true)
      end
      it 'returns a list of all contributors that have elected to be notified' do
        expect(subject.notifiable_contributors.map(&:user_name)).to eq(["sdorunga1"])
      end
    end

    describe "#subscribers" do
      it 'returns a list of all contributors that have subscribed to the repo and chose to be notified' do
        expect(subject.subscribers.map(&:user_name)).to eq(["sdorunga1"])
      end
    end

    describe "#top_contributors" do
      context "when the repository is active" do
        before do
          subject.preferences.active = true
        end

        it 'returns a list of the top contributors that have subscribed to the repo and chose to be notified' do
          expect(subject.subscribers.map(&:user_name)).to eq(["sdorunga1"])
        end
      end

      context "when the repository is not active" do
        before do
          subject.preferences.active = false
        end

        it 'returns an empty array' do
          expect(subject.subscribers.map(&:user_name)).to eq([])
        end
      end
    end
  end
end
