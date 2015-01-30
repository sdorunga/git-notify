module Notifiers
  class Slack

    attr_reader :pr, :username, :pr_number, :pr_url, :owner_username

    def initialize(slack_username:, pr_number:, pr_url:, owner_username:)
      @username       = slack_username
      @pr_number      = pr_number
      @pr_url         = pr_url
      @owner_username = owner_username
      @pr             = pr
      @slack = ::Slack::Notifier.new(webhook_url)
      @slack.username = "git-notifier"
      @slack.channel = "@#{username}"
    end


    def notify
      @slack.ping message
    end

    def message
      "Hi #{username}!\nYou were tagged in PR ##{pr_number} by @#{owner_username} at #{pr_url}"
    end

    private

    def webhook_url
      ENV.fetch("SLACK_WEBHOOK_URL")
    end
  end
end
