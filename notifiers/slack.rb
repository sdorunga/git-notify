module Notifiers
  class Slack

    attr_reader :pr, :username

    def initialize(slack_username:, pr:)
      @username = slack_username
      @pr = pr
      @slack = ::Slack::Notifier.new(webhook_url)
      @slack.username = "git-notifier"
      @slack.channel = "@#{username}"
    end


    def notify
      @slack.ping message
    end

    def message
      "Hi #{username}!\nYou were tagged in PR ##{pr.number} by @#{pr.user.user_name} at #{pr.url}"
    end

    def webhook_url
      ENV.fetch("SLACK_WEBHOOK_URL")
    end
  end
end
