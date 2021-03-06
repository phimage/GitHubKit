# GitHubKit

[![Slack](https://img.shields.io/badge/join-slack-745EAF.svg?style=flat)](https://bit.ly/2UkyFO8)
[![iOS](https://img.shields.io/badge/iOS-ff0000.svg?style=flat)](https://github.com/Einstore/Einstore)
[![macOS](https://img.shields.io/badge/macOS-ff0000.svg?style=flat)](https://github.com/Einstore/Einstore)
[![Ubuntu](https://img.shields.io/badge/Ubuntu-D95E33.svg?style=flat)](https://www.ubuntu.com/download/server)
[![Swift 5.1](https://img.shields.io/badge/swift-5.1-orange.svg?style=flat)](http://swift.org)
[![Vapor 4](https://img.shields.io/badge/vapor-4.0-blue.svg?style=flat)](https://vapor.codes)

Super simple to use Github API client library written using Apple NIO

## Functionality

The below probably don't contain all methods from the spec but it's a good start ...

- [x] Organizations
- [x] Repos
- [x] Files
- [x] File contents
- [x] Comments
- [x] Commits (full management)
- [x] Branches
- [x] Webhooks
- [x] Tags
- [x] Releases
- [ ] PR's
- [ ] Issues

## Usage

#### Add to your Package.swift file

```swift
.package(url: "https://github.com/Einstore/GitHubKit.git", from: "1.0.0")
```

Don't forget about your target

```swift
.target(
    name: "App",
    x: [
        "GitHubKit"
    ]
)
```

#### Configure
```swift
let config = Github.Config(
    username: "orafaj",
    token: token,
    server: "https://github.ford.com/api/v3/"
)
let github = try Github(config)

// or

let github = try Github(config, eventLoop: eventLoop)

// or 

let github = try Github(config, eventLoopGroupProvider: .createNew)
```

#### Use in iOS and server side frameworks

Although this library has been only tested with Vapor 4, using Apple NIO HHTPClient should be compatible with any iOS or server side project.

Please let us know on our [slack here](https://bit.ly/2UkyFO8) how you getting on or should you need any support!

#### Use in Vapor 4?

```swift
import GitHubKit

// In configure.swift
services.register(Github.self) { container in
    let config = Github.Config(
        username: "orafaj",
        token: token,
        server: "https://github.ford.com/api/v3/"
    )
    return try Github(config, eventLoop: container.eventLoop)
}

// In routes (or a controller)
r.get("github", "organizations") { req -> EventLoopFuture<[Organization]> in
    let github = try c.make(Github.self)
    return try Organization.query(on: github).getAll().map() { orgs in
        print(orgs)
        return orgs
    }
}
```

## Development

Adding a new API call is ... surprisingly super simple too

Lets say you need to add a detail of a user

#### Go to the documentation

https://developer.github.com/v3/users/

#### Autogenerate a model

Copy the example JSON, for example:

```json
{
  "login": "octocat",
  "id": 1,
  "node_id": "MDQ6VXNlcjE=",
  "avatar_url": "https://github.com/images/error/octocat_happy.gif",
  "gravatar_id": "",
  "url": "https://api.github.com/users/octocat",
  "html_url": "https://github.com/octocat",
  "followers_url": "https://api.github.com/users/octocat/followers",
  "following_url": "https://api.github.com/users/octocat/following{/other_user}",
  "gists_url": "https://api.github.com/users/octocat/gists{/gist_id}",
  "starred_url": "https://api.github.com/users/octocat/starred{/owner}{/repo}",
  "subscriptions_url": "https://api.github.com/users/octocat/subscriptions",
  "organizations_url": "https://api.github.com/users/octocat/orgs",
  "repos_url": "https://api.github.com/users/octocat/repos",
  "events_url": "https://api.github.com/users/octocat/events{/privacy}",
  "received_events_url": "https://api.github.com/users/octocat/received_events",
  "type": "User",
  "site_admin": false,
  "name": "monalisa octocat",
  "company": "GitHub",
  "blog": "https://github.com/blog",
  "location": "San Francisco",
  "email": "octocat@github.com",
  "hireable": false,
  "bio": "There once was...",
  "public_repos": 2,
  "public_gists": 1,
  "followers": 20,
  "following": 0,
  "created_at": "2008-01-14T04:33:35Z",
  "updated_at": "2008-01-14T04:33:35Z"
}
```

Go to the https://app.quicktype.io and convert the JSON into a model ... you might want to mess a bit with the settings to keep the models consistent with ones in the project already. Also, any sub structs (unless they can be used elsewhere) should be moved inside of the parent model. 

Oh yeah ... and call the main class `User`! :) ...

Import `Vapor` and conform the main model to `Content` instead of `Codable`.

#### Make a request extension

First you need to conform the `User` model to `Queryable`. This will enable the `User.query(on: container)` method.

```swift
extension User: Queryable { }
```

Next we create an extension on `QueryableProperty` which is generated each time you request a query on a container from the previous step. Make sure you specify the `QueryableType == User`

```swift
extension QueryableProperty where QueryableType == User {
    
    /// Get all organizations for authenticated user
    public func get() throws -> EventLoopFuture<User> {
        return try github.get(path: "user")
    }
    
}
```

#### All done

You should be able to call `try User.query(on: c).get()` and get an `EventLoopFuture<User>` with the details of your authenticated user.

### Author

**Ondrej Rafaj** @rafiki270

(It wasn't my token after all, was it?!)

### License

MIT; See LICENSE file for details.
