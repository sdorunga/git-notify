require 'dotenv'
Dotenv.load

#require 'newrelic_rpm'
require 'octokit'
require 'sinatra'
require 'mongoid'
require 'slack-notifier'
require 'oj'
require 'pry'
require 'slim'
require_relative 'git/pull_request'
require_relative 'git/contributor'
require_relative 'git/repository'
require_relative 'notifiers/slack'
require_relative 'repository_preferences'
require_relative 'contributor_preferences'

Octokit.configure do |c|
  c.login = ENV.fetch("GIT_USERNAME")
  c.password = ENV.fetch("GIT_PASSWORD")
end

Mongoid.load!("mongoid.yml")

class MyApp < Sinatra::Application
  post '/webhooks' do
    request.body.rewind
    payload = Oj.load(request.body.read, symbol_keys: true)
    repository_id = payload[:repository][:id]
    repository = Git::Repository.new(id: repository_id)
    pr = Git::PullRequest.new(payload[:pull_request])
    top_contributors = repository.top_contributors
    subscribers = repository.subscribers
    binding.pry
    review_team = (top_contributors + pr.mentioned_users + subscribers).uniq {|contributor| contributor.user_name }
    review_team.each { |contributor| Notifiers::Slack.new(slack_username: contributor.slack_username, pr_number: pr.number, pr_url: pr.url, owner_username: pr.user.user_name).notify }

    status 200
  end

  get '/repositories' do
    contributor_preferences = ContributorPreferences.all
    repositories = RepositoryPreferences.all
    slim :repositories, locals: { preferences: contributor_preferences.to_a, repositories: repositories.to_a }
  end

  get '/repositories/:repository_id' do
    repository = Git::Repository.new(id: params[:repository_id].to_i)
    slim :repository, locals: { repository: repository, contributors: repository.contributors }
  end

  post '/repositories/:repository_id' do
    preferences = RepositoryPreferences.find_by(git_id: params[:repository_id].to_i)
    whitelisted_params = preferences.whitelisted_fields.reduce({}) { |hash, field| hash[field.to_s] = params[field] if params[field]; hash }
    preferences.update_attributes(whitelisted_params)
    redirect "/repositories"
  end

  post "/repository-subscriptions/:repository_id/contributors/:contributor_id" do
    contributor_preference = ContributorPreferences.find_by(git_id: params[:contributor_id])
    unless contributor_preference.followed_repos.include?(params[:repository_id])
      contributor_preference.followed_repos << params[:repository_id]
      contributor_preference.save!
    end
    redirect "/repositories/#{params[:repository_id]}"
  end

  delete "/repository-subscriptions/:repository_id/contributors/:contributor_id" do
    contributor_preference = ContributorPreferences.find_by(git_id: params[:contributor_id])
    if contributor_preference.followed_repos.include?(params[:repository_id])
      contributor_preference.followed_repos.delete(params[:repository_id])
      contributor_preference.save!
    end
    redirect "/repositories/#{params[:repository_id]}"
  end

  get '/contributor-preferences' do
    contributor_preferences = ContributorPreferences.all
    slim :index, locals: { preferences: contributor_preferences.to_a }
  end

  post '/contributor-preferences/:git_id' do
    contributor_preferences = ContributorPreferences.find_by(git_id: params[:git_id])
    whitelisted_params = contributor_preferences.whitelisted_fields.reduce({}) { |hash, field| hash[field.to_s] = params[field] if params[field]; hash }
    contributor_preferences.update_attributes!(whitelisted_params)
    redirect '/contributor-preferences'
  end
end
