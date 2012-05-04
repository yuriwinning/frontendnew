# Radium Pure JS Frontend

See [frontend_server](https://github.com/threadedlabs/frontend_server)
for underlying code that powers this project.

## Configuration

There are 3 different things that may be configured.

```yml
# config/settings.yml

server: "http://api.radiumcrm.com" # server to proxy all requests too
developer_api_key: test # developer key to use
user_api_key: test # optionally, authenticate as a user indevelopment
```

## Running Locally

```
# bundle if required
$ bundle exec foreman start
$ open localhost:5000
```

## Deploying

The JS frontend can be deployed and managed completely separately from
the API server. Just execute the deploy script and it will do the rest.

```
# commit your stuff
$ ./script/deploy
```

## Maintainers

* Assets (JS/CSS/HTML): Josh & Stefan
* All Server Stuff: Adam & Stefan
