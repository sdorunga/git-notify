require 'spec_helper'
require 'rspec/expectations'

def pull_request_fixture
  Oj.load(File.read(File.join(__dir__, "../fixtures/pull_request_open.json")), symbol_keys: true)
end

module Git
  describe PullRequest do
    let(:payload) { pull_request_fixture[:pull_request] }
  
    subject { described_class.new(payload) }
  
    describe "#url" do
      it 'is equal to the payload url' do
        expect(subject.url).to eq(payload[:url])
      end
    end

    describe "#number" do
      it 'is equal to the payload number' do
        expect(subject.number).to eq(payload[:number])
      end
    end

    describe "#title" do
      it 'is equal to the payload title' do
        expect(subject.title).to eq(payload[:title])
      end
    end

    describe "#body" do
      it 'is equal to the payload body' do
        expect(subject.body).to eq(payload[:body])
      end
    end

    describe "#user" do
      it 'returns a new contributor based on the user in the payload' do
        expect(Contributor).to receive(:new).with(payload[:user])

        subject.user
      end
    end

    describe "#repository" do
      it 'returns a new repository by the repo id for the base of the merge in the PR' do
        expect(Repository).to receive(:new).with(id: payload[:base][:repo][:id])

        subject.repository
      end
    end

    describe "#mentioned_users" do
      it 'parses the user names from the PR body and returns the correct users' do
        expect(subject.mentioned_users.map(&:user_name)).to eq(["sdorunga-sb"])
      end
    end
  end
end
