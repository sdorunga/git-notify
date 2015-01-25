require 'octokit'
require 'sinatra'
require 'mongoid'
require 'slack-notifier'
require 'oj'
require 'pry'
require 'slim'

Octokit.configure do |c|
  c.login = 'sdorunga-sb'
  c.password = 'Student3230'
end

Mongoid.load!("mongoid.yml", :development)

class MyApp < Sinatra::Base
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
  class Repository
    def initialize(id:)
      @id = id
      @repository = Octokit.repositories.detect { |repo| repo.id == @id }
    end

    def contributors
      contributor_data.map { |contributor| Contributor.new(contributor) }
    end

    private

    def contributor_data
      @contributor_data ||= @repository.rels[:contributors].get.data
    end
  end

  class Contributor
    attr_reader :user_id, :user_name, :contributions

    def initialize(payload)
      @user_id       = payload[:id]
      @user_name     = payload[:name]
      @contributions = payload[:contributions]

    end

    def preferences
      {
        name:           @preference_storage.name,
        notify:         @preference_storage.notify,
        followed_repos: @preference_storage.name
      }
    end

    private

    def preference_storage
      @preference_storage ||= ContributorPreferences.where(git_id: user_id)
    end
  end

  module Notifiers
    class Slack

      attr_reader :user

      def initialize(user:)
        @user = user
        @slack = ::Slack::Notifier.new(webhook_url)
        @slack.username = "git-notifier"
        @slack.channel = "@sdorunga"
      end


      def notify
        @slack.ping "Hello World"
      end

      def webhook_url
        "https://hooks.slack.com/services/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"
      end
    end
  end

  class ContributorPreferences
    include Mongoid::Document

    field :git_id, type: String
    field :name, type: String
    field :notify, type: Boolean
    field :followed_repos, type: Array

    def whitelisted_fields
      fields.keys.reject { |key| key == "_id" }
    end
  end

  request_id = Oj.load(string)["repository"]["id"]
  repository = Repository.new(id: request_id)
  top_contributors = repository.contributors.sort_by(&:contributions).
                                             reverse.
                                             take(5)
  top_contributors.each { |contributor| Notifiers::Slack.new(user: contributor.user_name).notify }
  #repository = Octokit.repositories.detect { |repo| repo.id == request["repository"]["id"] }
  #contributors = repository.rels[:contributors].get.data
  get '/hi' do
    contributor_preferences = ContributorPreferences.all
    slim :index, locals: { preferences: contributor_preferences.to_a }
  end
  post '/hi/:git_id' do
    contributor_preferences = ContributorPreferences.find_by(git_id: params[:git_id])
    whitelisted_params = contributor_preferences.whitelisted_fields.reduce({}) { |hash, field| hash[field.to_s] = params[field]; hash }
    contributor_preferences.update_attributes!(whitelisted_params)
    redirect '/hi'
  end
end
