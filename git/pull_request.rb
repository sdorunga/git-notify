module Git
  class PullRequest
    attr_reader :url, :number, :title, :body
    def initialize(payload)
      @url        = payload[:url]
      @number     = payload[:number]
      @title      = payload[:title]
      @user       = payload[:user]
      @body       = payload[:body]
      @repository = payload[:base][:repo]
    end

    def user
      Contributor.new(@user)
    end

    def repository
      Repository.new(id: @repository[:id])
    end

    def mentioned_users
      body.scan(/@([\w+-]+)/).flatten
    end
  end
end
