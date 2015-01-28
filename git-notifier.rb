require 'dotenv'
Dotenv.load

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

Mongoid.load!("mongoid.yml", :development)

class MyApp < Sinatra::Application
  string = <<-EOS
{
  "action": "opened",
  "number": 1,
  "pull_request": {
    "url": "https://api.github.com/repos/sdorunga1/bogus_library/pulls/1",
    "id": 27921626,
    "html_url": "https://github.com/sdorunga1/bogus_library/pull/1",
    "diff_url": "https://github.com/sdorunga1/bogus_library/pull/1.diff",
    "patch_url": "https://github.com/sdorunga1/bogus_library/pull/1.patch",
    "issue_url": "https://api.github.com/repos/sdorunga1/bogus_library/issues/1",
    "number": 1,
    "state": "open",
    "locked": false,
    "title": "Add whitespace",
    "user": {
      "login": "sdorunga1",
      "id": 950333,
      "avatar_url": "https://avatars.githubusercontent.com/u/950333?v=3",
      "gravatar_id": "",
      "url": "https://api.github.com/users/sdorunga1",
      "html_url": "https://github.com/sdorunga1",
      "followers_url": "https://api.github.com/users/sdorunga1/followers",
      "following_url": "https://api.github.com/users/sdorunga1/following{/other_user}",
      "gists_url": "https://api.github.com/users/sdorunga1/gists{/gist_id}",
      "starred_url": "https://api.github.com/users/sdorunga1/starred{/owner}{/repo}",
      "subscriptions_url": "https://api.github.com/users/sdorunga1/subscriptions",
      "organizations_url": "https://api.github.com/users/sdorunga1/orgs",
      "repos_url": "https://api.github.com/users/sdorunga1/repos",
      "events_url": "https://api.github.com/users/sdorunga1/events{/privacy}",
      "received_events_url": "https://api.github.com/users/sdorunga1/received_events",
      "type": "User",
      "site_admin": false
    },
    "body": "Test pull request. Hi @sdorunga-sb ",
    "created_at": "2015-01-23T12:56:08Z",
    "updated_at": "2015-01-23T12:56:08Z",
    "closed_at": null,
    "merged_at": null,
    "merge_commit_sha": null,
    "assignee": null,
    "milestone": null,
    "commits_url": "https://api.github.com/repos/sdorunga1/bogus_library/pulls/1/commits",
    "review_comments_url": "https://api.github.com/repos/sdorunga1/bogus_library/pulls/1/comments",
    "review_comment_url": "https://api.github.com/repos/sdorunga1/bogus_library/pulls/comments/{number}",
    "comments_url": "https://api.github.com/repos/sdorunga1/bogus_library/issues/1/comments",
    "statuses_url": "https://api.github.com/repos/sdorunga1/bogus_library/statuses/6691c6ea558c93c4bec5f3c93c5e87b8162ad872",
    "head": {
      "label": "sdorunga1:bogus",
      "ref": "bogus",
      "sha": "6691c6ea558c93c4bec5f3c93c5e87b8162ad872",
      "user": {
        "login": "sdorunga1",
        "id": 950333,
        "avatar_url": "https://avatars.githubusercontent.com/u/950333?v=3",
        "gravatar_id": "",
        "url": "https://api.github.com/users/sdorunga1",
        "html_url": "https://github.com/sdorunga1",
        "followers_url": "https://api.github.com/users/sdorunga1/followers",
        "following_url": "https://api.github.com/users/sdorunga1/following{/other_user}",
        "gists_url": "https://api.github.com/users/sdorunga1/gists{/gist_id}",
        "starred_url": "https://api.github.com/users/sdorunga1/starred{/owner}{/repo}",
        "subscriptions_url": "https://api.github.com/users/sdorunga1/subscriptions",
        "organizations_url": "https://api.github.com/users/sdorunga1/orgs",
        "repos_url": "https://api.github.com/users/sdorunga1/repos",
        "events_url": "https://api.github.com/users/sdorunga1/events{/privacy}",
        "received_events_url": "https://api.github.com/users/sdorunga1/received_events",
        "type": "User",
        "site_admin": false
      },
      "repo": {
        "id": 22906439,
        "name": "bogus_library",
        "full_name": "sdorunga1/bogus_library",
        "owner": {
          "login": "sdorunga1",
          "id": 950333,
          "avatar_url": "https://avatars.githubusercontent.com/u/950333?v=3",
          "gravatar_id": "",
          "url": "https://api.github.com/users/sdorunga1",
          "html_url": "https://github.com/sdorunga1",
          "followers_url": "https://api.github.com/users/sdorunga1/followers",
          "following_url": "https://api.github.com/users/sdorunga1/following{/other_user}",
          "gists_url": "https://api.github.com/users/sdorunga1/gists{/gist_id}",
          "starred_url": "https://api.github.com/users/sdorunga1/starred{/owner}{/repo}",
          "subscriptions_url": "https://api.github.com/users/sdorunga1/subscriptions",
          "organizations_url": "https://api.github.com/users/sdorunga1/orgs",
          "repos_url": "https://api.github.com/users/sdorunga1/repos",
          "events_url": "https://api.github.com/users/sdorunga1/events{/privacy}",
          "received_events_url": "https://api.github.com/users/sdorunga1/received_events",
          "type": "User",
          "site_admin": false
        },
        "private": false,
        "html_url": "https://github.com/sdorunga1/bogus_library",
        "description": "",
        "fork": false,
        "url": "https://api.github.com/repos/sdorunga1/bogus_library",
        "forks_url": "https://api.github.com/repos/sdorunga1/bogus_library/forks",
        "keys_url": "https://api.github.com/repos/sdorunga1/bogus_library/keys{/key_id}",
        "collaborators_url": "https://api.github.com/repos/sdorunga1/bogus_library/collaborators{/collaborator}",
        "teams_url": "https://api.github.com/repos/sdorunga1/bogus_library/teams",
        "hooks_url": "https://api.github.com/repos/sdorunga1/bogus_library/hooks",
        "issue_events_url": "https://api.github.com/repos/sdorunga1/bogus_library/issues/events{/number}",
        "events_url": "https://api.github.com/repos/sdorunga1/bogus_library/events",
        "assignees_url": "https://api.github.com/repos/sdorunga1/bogus_library/assignees{/user}",
        "branches_url": "https://api.github.com/repos/sdorunga1/bogus_library/branches{/branch}",
        "tags_url": "https://api.github.com/repos/sdorunga1/bogus_library/tags",
        "blobs_url": "https://api.github.com/repos/sdorunga1/bogus_library/git/blobs{/sha}",
        "git_tags_url": "https://api.github.com/repos/sdorunga1/bogus_library/git/tags{/sha}",
        "git_refs_url": "https://api.github.com/repos/sdorunga1/bogus_library/git/refs{/sha}",
        "trees_url": "https://api.github.com/repos/sdorunga1/bogus_library/git/trees{/sha}",
        "statuses_url": "https://api.github.com/repos/sdorunga1/bogus_library/statuses/{sha}",
        "languages_url": "https://api.github.com/repos/sdorunga1/bogus_library/languages",
        "stargazers_url": "https://api.github.com/repos/sdorunga1/bogus_library/stargazers",
        "contributors_url": "https://api.github.com/repos/sdorunga1/bogus_library/contributors",
        "subscribers_url": "https://api.github.com/repos/sdorunga1/bogus_library/subscribers",
        "subscription_url": "https://api.github.com/repos/sdorunga1/bogus_library/subscription",
        "commits_url": "https://api.github.com/repos/sdorunga1/bogus_library/commits{/sha}",
        "git_commits_url": "https://api.github.com/repos/sdorunga1/bogus_library/git/commits{/sha}",
        "comments_url": "https://api.github.com/repos/sdorunga1/bogus_library/comments{/number}",
        "issue_comment_url": "https://api.github.com/repos/sdorunga1/bogus_library/issues/comments/{number}",
        "contents_url": "https://api.github.com/repos/sdorunga1/bogus_library/contents/{+path}",
        "compare_url": "https://api.github.com/repos/sdorunga1/bogus_library/compare/{base}...{head}",
        "merges_url": "https://api.github.com/repos/sdorunga1/bogus_library/merges",
        "archive_url": "https://api.github.com/repos/sdorunga1/bogus_library/{archive_format}{/ref}",
        "downloads_url": "https://api.github.com/repos/sdorunga1/bogus_library/downloads",
        "issues_url": "https://api.github.com/repos/sdorunga1/bogus_library/issues{/number}",
        "pulls_url": "https://api.github.com/repos/sdorunga1/bogus_library/pulls{/number}",
        "milestones_url": "https://api.github.com/repos/sdorunga1/bogus_library/milestones{/number}",
        "notifications_url": "https://api.github.com/repos/sdorunga1/bogus_library/notifications{?since,all,participating}",
        "labels_url": "https://api.github.com/repos/sdorunga1/bogus_library/labels{/name}",
        "releases_url": "https://api.github.com/repos/sdorunga1/bogus_library/releases{/id}",
        "created_at": "2014-08-13T07:19:03Z",
        "updated_at": "2014-08-13T07:19:22Z",
        "pushed_at": "2015-01-23T12:55:56Z",
        "git_url": "git://github.com/sdorunga1/bogus_library.git",
        "ssh_url": "git@github.com:sdorunga1/bogus_library.git",
        "clone_url": "https://github.com/sdorunga1/bogus_library.git",
        "svn_url": "https://github.com/sdorunga1/bogus_library",
        "homepage": null,
        "size": 152,
        "stargazers_count": 0,
        "watchers_count": 0,
        "language": "Ruby",
        "has_issues": true,
        "has_downloads": true,
        "has_wiki": true,
        "has_pages": false,
        "forks_count": 0,
        "mirror_url": null,
        "open_issues_count": 1,
        "forks": 0,
        "open_issues": 1,
        "watchers": 0,
        "default_branch": "master"
      }
    },
    "base": {
      "label": "sdorunga1:master",
      "ref": "master",
      "sha": "1cd89889f88e0e002664a62e7766ca7f14abc443",
      "user": {
        "login": "sdorunga1",
        "id": 950333,
        "avatar_url": "https://avatars.githubusercontent.com/u/950333?v=3",
        "gravatar_id": "",
        "url": "https://api.github.com/users/sdorunga1",
        "html_url": "https://github.com/sdorunga1",
        "followers_url": "https://api.github.com/users/sdorunga1/followers",
        "following_url": "https://api.github.com/users/sdorunga1/following{/other_user}",
        "gists_url": "https://api.github.com/users/sdorunga1/gists{/gist_id}",
        "starred_url": "https://api.github.com/users/sdorunga1/starred{/owner}{/repo}",
        "subscriptions_url": "https://api.github.com/users/sdorunga1/subscriptions",
        "organizations_url": "https://api.github.com/users/sdorunga1/orgs",
        "repos_url": "https://api.github.com/users/sdorunga1/repos",
        "events_url": "https://api.github.com/users/sdorunga1/events{/privacy}",
        "received_events_url": "https://api.github.com/users/sdorunga1/received_events",
        "type": "User",
        "site_admin": false
      },
      "repo": {
        "id": 22906439,
        "name": "bogus_library",
        "full_name": "sdorunga1/bogus_library",
        "owner": {
          "login": "sdorunga1",
          "id": 950333,
          "avatar_url": "https://avatars.githubusercontent.com/u/950333?v=3",
          "gravatar_id": "",
          "url": "https://api.github.com/users/sdorunga1",
          "html_url": "https://github.com/sdorunga1",
          "followers_url": "https://api.github.com/users/sdorunga1/followers",
          "following_url": "https://api.github.com/users/sdorunga1/following{/other_user}",
          "gists_url": "https://api.github.com/users/sdorunga1/gists{/gist_id}",
          "starred_url": "https://api.github.com/users/sdorunga1/starred{/owner}{/repo}",
          "subscriptions_url": "https://api.github.com/users/sdorunga1/subscriptions",
          "organizations_url": "https://api.github.com/users/sdorunga1/orgs",
          "repos_url": "https://api.github.com/users/sdorunga1/repos",
          "events_url": "https://api.github.com/users/sdorunga1/events{/privacy}",
          "received_events_url": "https://api.github.com/users/sdorunga1/received_events",
          "type": "User",
          "site_admin": false
        },
        "private": false,
        "html_url": "https://github.com/sdorunga1/bogus_library",
        "description": "",
        "fork": false,
        "url": "https://api.github.com/repos/sdorunga1/bogus_library",
        "forks_url": "https://api.github.com/repos/sdorunga1/bogus_library/forks",
        "keys_url": "https://api.github.com/repos/sdorunga1/bogus_library/keys{/key_id}",
        "collaborators_url": "https://api.github.com/repos/sdorunga1/bogus_library/collaborators{/collaborator}",
        "teams_url": "https://api.github.com/repos/sdorunga1/bogus_library/teams",
        "hooks_url": "https://api.github.com/repos/sdorunga1/bogus_library/hooks",
        "issue_events_url": "https://api.github.com/repos/sdorunga1/bogus_library/issues/events{/number}",
        "events_url": "https://api.github.com/repos/sdorunga1/bogus_library/events",
        "assignees_url": "https://api.github.com/repos/sdorunga1/bogus_library/assignees{/user}",
        "branches_url": "https://api.github.com/repos/sdorunga1/bogus_library/branches{/branch}",
        "tags_url": "https://api.github.com/repos/sdorunga1/bogus_library/tags",
        "blobs_url": "https://api.github.com/repos/sdorunga1/bogus_library/git/blobs{/sha}",
        "git_tags_url": "https://api.github.com/repos/sdorunga1/bogus_library/git/tags{/sha}",
        "git_refs_url": "https://api.github.com/repos/sdorunga1/bogus_library/git/refs{/sha}",
        "trees_url": "https://api.github.com/repos/sdorunga1/bogus_library/git/trees{/sha}",
        "statuses_url": "https://api.github.com/repos/sdorunga1/bogus_library/statuses/{sha}",
        "languages_url": "https://api.github.com/repos/sdorunga1/bogus_library/languages",
        "stargazers_url": "https://api.github.com/repos/sdorunga1/bogus_library/stargazers",
        "contributors_url": "https://api.github.com/repos/sdorunga1/bogus_library/contributors",
        "subscribers_url": "https://api.github.com/repos/sdorunga1/bogus_library/subscribers",
        "subscription_url": "https://api.github.com/repos/sdorunga1/bogus_library/subscription",
        "commits_url": "https://api.github.com/repos/sdorunga1/bogus_library/commits{/sha}",
        "git_commits_url": "https://api.github.com/repos/sdorunga1/bogus_library/git/commits{/sha}",
        "comments_url": "https://api.github.com/repos/sdorunga1/bogus_library/comments{/number}",
        "issue_comment_url": "https://api.github.com/repos/sdorunga1/bogus_library/issues/comments/{number}",
        "contents_url": "https://api.github.com/repos/sdorunga1/bogus_library/contents/{+path}",
        "compare_url": "https://api.github.com/repos/sdorunga1/bogus_library/compare/{base}...{head}",
        "merges_url": "https://api.github.com/repos/sdorunga1/bogus_library/merges",
        "archive_url": "https://api.github.com/repos/sdorunga1/bogus_library/{archive_format}{/ref}",
        "downloads_url": "https://api.github.com/repos/sdorunga1/bogus_library/downloads",
        "issues_url": "https://api.github.com/repos/sdorunga1/bogus_library/issues{/number}",
        "pulls_url": "https://api.github.com/repos/sdorunga1/bogus_library/pulls{/number}",
        "milestones_url": "https://api.github.com/repos/sdorunga1/bogus_library/milestones{/number}",
        "notifications_url": "https://api.github.com/repos/sdorunga1/bogus_library/notifications{?since,all,participating}",
        "labels_url": "https://api.github.com/repos/sdorunga1/bogus_library/labels{/name}",
        "releases_url": "https://api.github.com/repos/sdorunga1/bogus_library/releases{/id}",
        "created_at": "2014-08-13T07:19:03Z",
        "updated_at": "2014-08-13T07:19:22Z",
        "pushed_at": "2015-01-23T12:55:56Z",
        "git_url": "git://github.com/sdorunga1/bogus_library.git",
        "ssh_url": "git@github.com:sdorunga1/bogus_library.git",
        "clone_url": "https://github.com/sdorunga1/bogus_library.git",
        "svn_url": "https://github.com/sdorunga1/bogus_library",
        "homepage": null,
        "size": 152,
        "stargazers_count": 0,
        "watchers_count": 0,
        "language": "Ruby",
        "has_issues": true,
        "has_downloads": true,
        "has_wiki": true,
        "has_pages": false,
        "forks_count": 0,
        "mirror_url": null,
        "open_issues_count": 1,
        "forks": 0,
        "open_issues": 1,
        "watchers": 0,
        "default_branch": "master"
      }
    },
    "_links": {
      "self": {
        "href": "https://api.github.com/repos/sdorunga1/bogus_library/pulls/1"
      },
      "html": {
        "href": "https://github.com/sdorunga1/bogus_library/pull/1"
      },
      "issue": {
        "href": "https://api.github.com/repos/sdorunga1/bogus_library/issues/1"
      },
      "comments": {
        "href": "https://api.github.com/repos/sdorunga1/bogus_library/issues/1/comments"
      },
      "review_comments": {
        "href": "https://api.github.com/repos/sdorunga1/bogus_library/pulls/1/comments"
      },
      "review_comment": {
        "href": "https://api.github.com/repos/sdorunga1/bogus_library/pulls/comments/{number}"
      },
      "commits": {
        "href": "https://api.github.com/repos/sdorunga1/bogus_library/pulls/1/commits"
      },
      "statuses": {
        "href": "https://api.github.com/repos/sdorunga1/bogus_library/statuses/6691c6ea558c93c4bec5f3c93c5e87b8162ad872"
      }
    },
    "merged": false,
    "mergeable": null,
    "mergeable_state": "unknown",
    "merged_by": null,
    "comments": 0,
    "review_comments": 0,
    "commits": 1,
    "additions": 1,
    "deletions": 1,
    "changed_files": 1
  },
  "repository": {
    "id": 22906439,
    "name": "bogus_library",
    "full_name": "sdorunga1/bogus_library",
    "owner": {
      "login": "sdorunga1",
      "id": 950333,
      "avatar_url": "https://avatars.githubusercontent.com/u/950333?v=3",
      "gravatar_id": "",
      "url": "https://api.github.com/users/sdorunga1",
      "html_url": "https://github.com/sdorunga1",
      "followers_url": "https://api.github.com/users/sdorunga1/followers",
      "following_url": "https://api.github.com/users/sdorunga1/following{/other_user}",
      "gists_url": "https://api.github.com/users/sdorunga1/gists{/gist_id}",
      "starred_url": "https://api.github.com/users/sdorunga1/starred{/owner}{/repo}",
      "subscriptions_url": "https://api.github.com/users/sdorunga1/subscriptions",
      "organizations_url": "https://api.github.com/users/sdorunga1/orgs",
      "repos_url": "https://api.github.com/users/sdorunga1/repos",
      "events_url": "https://api.github.com/users/sdorunga1/events{/privacy}",
      "received_events_url": "https://api.github.com/users/sdorunga1/received_events",
      "type": "User",
      "site_admin": false
    },
    "private": false,
    "html_url": "https://github.com/sdorunga1/bogus_library",
    "description": "",
    "fork": false,
    "url": "https://api.github.com/repos/sdorunga1/bogus_library",
    "forks_url": "https://api.github.com/repos/sdorunga1/bogus_library/forks",
    "keys_url": "https://api.github.com/repos/sdorunga1/bogus_library/keys{/key_id}",
    "collaborators_url": "https://api.github.com/repos/sdorunga1/bogus_library/collaborators{/collaborator}",
    "teams_url": "https://api.github.com/repos/sdorunga1/bogus_library/teams",
    "hooks_url": "https://api.github.com/repos/sdorunga1/bogus_library/hooks",
    "issue_events_url": "https://api.github.com/repos/sdorunga1/bogus_library/issues/events{/number}",
    "events_url": "https://api.github.com/repos/sdorunga1/bogus_library/events",
    "assignees_url": "https://api.github.com/repos/sdorunga1/bogus_library/assignees{/user}",
    "branches_url": "https://api.github.com/repos/sdorunga1/bogus_library/branches{/branch}",
    "tags_url": "https://api.github.com/repos/sdorunga1/bogus_library/tags",
    "blobs_url": "https://api.github.com/repos/sdorunga1/bogus_library/git/blobs{/sha}",
    "git_tags_url": "https://api.github.com/repos/sdorunga1/bogus_library/git/tags{/sha}",
    "git_refs_url": "https://api.github.com/repos/sdorunga1/bogus_library/git/refs{/sha}",
    "trees_url": "https://api.github.com/repos/sdorunga1/bogus_library/git/trees{/sha}",
    "statuses_url": "https://api.github.com/repos/sdorunga1/bogus_library/statuses/{sha}",
    "languages_url": "https://api.github.com/repos/sdorunga1/bogus_library/languages",
    "stargazers_url": "https://api.github.com/repos/sdorunga1/bogus_library/stargazers",
    "contributors_url": "https://api.github.com/repos/sdorunga1/bogus_library/contributors",
    "subscribers_url": "https://api.github.com/repos/sdorunga1/bogus_library/subscribers",
    "subscription_url": "https://api.github.com/repos/sdorunga1/bogus_library/subscription",
    "commits_url": "https://api.github.com/repos/sdorunga1/bogus_library/commits{/sha}",
    "git_commits_url": "https://api.github.com/repos/sdorunga1/bogus_library/git/commits{/sha}",
    "comments_url": "https://api.github.com/repos/sdorunga1/bogus_library/comments{/number}",
    "issue_comment_url": "https://api.github.com/repos/sdorunga1/bogus_library/issues/comments/{number}",
    "contents_url": "https://api.github.com/repos/sdorunga1/bogus_library/contents/{+path}",
    "compare_url": "https://api.github.com/repos/sdorunga1/bogus_library/compare/{base}...{head}",
    "merges_url": "https://api.github.com/repos/sdorunga1/bogus_library/merges",
    "archive_url": "https://api.github.com/repos/sdorunga1/bogus_library/{archive_format}{/ref}",
    "downloads_url": "https://api.github.com/repos/sdorunga1/bogus_library/downloads",
    "issues_url": "https://api.github.com/repos/sdorunga1/bogus_library/issues{/number}",
    "pulls_url": "https://api.github.com/repos/sdorunga1/bogus_library/pulls{/number}",
    "milestones_url": "https://api.github.com/repos/sdorunga1/bogus_library/milestones{/number}",
    "notifications_url": "https://api.github.com/repos/sdorunga1/bogus_library/notifications{?since,all,participating}",
    "labels_url": "https://api.github.com/repos/sdorunga1/bogus_library/labels{/name}",
    "releases_url": "https://api.github.com/repos/sdorunga1/bogus_library/releases{/id}",
    "created_at": "2014-08-13T07:19:03Z",
    "updated_at": "2014-08-13T07:19:22Z",
    "pushed_at": "2015-01-23T12:55:56Z",
    "git_url": "git://github.com/sdorunga1/bogus_library.git",
    "ssh_url": "git@github.com:sdorunga1/bogus_library.git",
    "clone_url": "https://github.com/sdorunga1/bogus_library.git",
    "svn_url": "https://github.com/sdorunga1/bogus_library",
    "homepage": null,
    "size": 152,
    "stargazers_count": 0,
    "watchers_count": 0,
    "language": "Ruby",
    "has_issues": true,
    "has_downloads": true,
    "has_wiki": true,
    "has_pages": false,
    "forks_count": 0,
    "mirror_url": null,
    "open_issues_count": 1,
    "forks": 0,
    "open_issues": 1,
    "watchers": 0,
    "default_branch": "master"
  },
  "sender": {
    "login": "sdorunga1",
    "id": 950333,
    "avatar_url": "https://avatars.githubusercontent.com/u/950333?v=3",
    "gravatar_id": "",
    "url": "https://api.github.com/users/sdorunga1",
    "html_url": "https://github.com/sdorunga1",
    "followers_url": "https://api.github.com/users/sdorunga1/followers",
    "following_url": "https://api.github.com/users/sdorunga1/following{/other_user}",
    "gists_url": "https://api.github.com/users/sdorunga1/gists{/gist_id}",
    "starred_url": "https://api.github.com/users/sdorunga1/starred{/owner}{/repo}",
    "subscriptions_url": "https://api.github.com/users/sdorunga1/subscriptions",
    "organizations_url": "https://api.github.com/users/sdorunga1/orgs",
    "repos_url": "https://api.github.com/users/sdorunga1/repos",
    "events_url": "https://api.github.com/users/sdorunga1/events{/privacy}",
    "received_events_url": "https://api.github.com/users/sdorunga1/received_events",
    "type": "User",
    "site_admin": false
  }
}
EOS

  post '/webhooks' do
    request = Oj.load(string, symbol_keys: true)
    repository_id = request[:repository][:id]
    repository = Repository.new(id: repository_id)
    pr = Git::PullRequest.new(request[:pull_request])
    top_contributors = repository.top_contributors
    subscribers = repository.subscribers
    review_team = (top_contributors + pr.mentioned_users + subscribers).uniq {|contributor| contributor.preferences[:name] }
    review_team.each { |contributor| Notifiers::Slack.new(username: contributor.user_name, pr: pr).notify }

    status 200
  end

  get '/repositories' do
    contributor_preferences = ContributorPreferences.all
    repositories = RepositoryPreferences.all
    slim :repositories, locals: { preferences: contributor_preferences.to_a, repositories: repositories.to_a }
  end

  get '/repositories/:repository_id' do
    repository = Repository.new(id: params[:repository_id].to_i)
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
    whitelisted_params = contributor_preferences.whitelisted_fields.reduce({}) { |hash, field| hash[field.to_s] = params[field]; hash }
    contributor_preferences.update_attributes!(whitelisted_params)
    redirect '/contributor-preferences'
  end
end
