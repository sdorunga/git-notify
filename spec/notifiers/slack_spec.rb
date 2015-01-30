module Notifiers
  describe Slack do
  
    let(:notifier) { double("Slack::Notifier", "username=" => nil, "channel=" => nil, ping: nil) }
    let(:slack_username) { "Joe" }
    let(:pr_number) { "2" }
    let(:pr_url) { "http://url.com" }
    let(:owner_username) { "Alan" }
    subject do
      described_class.new(
        slack_username: slack_username,
        pr_number: pr_number,
        pr_url: pr_url,
        owner_username: owner_username
      )
    end

    before do
      allow(::Slack::Notifier).to receive(:new).and_return(notifier)
    end

    describe "#notify" do
      let(:expected_message) { "Hi #{slack_username}!\nYou were tagged in PR ##{pr_number} by @#{owner_username} at #{pr_url}" }

      it 'calls ping on a Slack::Notifier with the correct message' do
        expect(notifier).to receive(:ping).with(expected_message)

        subject.notify
      end
    end

    describe "#new" do
      it 'sets the name of the slack bot to git-notifier' do
        expect(notifier).to receive("username=").with("git-notifier")

        subject
      end

      it 'sets the channel to ping to the slack username of the target' do
        expect(notifier).to receive("channel=").with("@#{slack_username}")

        subject
      end
    end
  end
end
