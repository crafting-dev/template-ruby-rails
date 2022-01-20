# Ruby on Rails with MySQL template for Crafting Sandbox

This is a Ruby on Rails with MySQL template, configured for quick development setup in [Crafting Sandbox](https://docs.sandboxes.cloud/docs).

## Specifications

This template was created with MySQL and *without* Minitest:
```bash
rails new template-ruby-rails -d mysql -T
```

[Rspec](https://rspec.info/) is used for testing instead:
```ruby
gem 'rspec-rails', '~> 5.0.0'
```

[Rubocop](https://github.com/rubocop/rubocop) is used for linting, enforcing many of the guidelines outlined in the community [Ruby Style Guide](https://rubystyle.guide/).
```ruby
gem 'rubocop-rails', require: false
```

The shell script [`sandbox.sh`](sandbox.sh) is used to configure sandbox for quick workspace setup. The manifest file [`.sandbox/manifest.yaml`](.sandbox/manifest.yaml) uses it during build stage when creating a new sandbox using this template.

[`config/database.yml`](config/database.yml) is modified to use the preconfigured credentials set in App configuration. The environment variables `MYSQL_SERVICE_HOST` and `MYSQL_SERVICE_PORT` come already populated in sandbox.

## Pings Controller

This template comes with a `Pings` controller already generated:
```bash
rails g controller Pings pong
```

whereby the action `pong` is defined as:
```ruby
def pong
  @pong = {
    ping: @ping,               # @ping = params[:ping]
    received_at: @current_time # @current_time = Time.current
  }

  render json: @pong
end
```

with the route:
```ruby
get 'ping', to: 'pings#pong'
```

This action receives a parameter string, and responds with the param string and the current time.
For example:
```bash
$ curl --request GET 'localhost:3000/ping?ping=hello'
{"ping":"hello","received_at":"XXXX-XX-XXXXX:XX:XX.XXXX"}
```

## App Definition

The following [App Definition](https://docs.sandboxes.cloud/docs/app-definition) was used to create this template:

```yaml
endpoints:
- name: api
  http:
    routes:
    - pathPrefix: "/api/"
      backend:
        target: ruby-rails
        port: api
workspaces:
- name: ruby-rails
  description: Template backend using Ruby/Rails
  ports:
  - name: api
    port: 3000
    protocol: HTTP/TCP
  checkouts:
  - path: backend
    repo:
      git: https://github.com/crafting-dev/template-ruby-rails
  packages:
  - name: ruby
    version: 2.7.2
  - name: nodejs
    version: 16.12.0
dependencies:
- name: mysql
  serviceType: mysql
  version: '8'
  properties:
    database: superhero
    password: batman
    username: brucewayne
```
