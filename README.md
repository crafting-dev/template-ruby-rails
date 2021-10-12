# A Rails with MySQL template for Cloud Sandbox

This is a template [Ruby on Rails](https://rubyonrails.org/) skeleton application created on a basic [App](https://crafting.readme.io/docs/app-spec) configuration in [Cloud Sandbox](https://crafting.readme.io/docs/introduction). 

## Getting Started

The general workflow when developing in Cloud Sandbox involves:

1. [Configuring App](https://github.com/crafting-dev/template-ruby-rails#configuring-app)
2. [Creating Sandbox](https://github.com/crafting-dev/template-ruby-rails#creating-sandbox)
3. [Developing with Sandbox](https://github.com/crafting-dev/template-ruby-rails#developing-with-sandbox)

### 1. Configuring App

[App](https://crafting.readme.io/docs/app-spec) can be viewed/edited either on the [Web UI](https://sandboxes.cloud/app) or via the [`cs`](https://sandboxes.cloud/download) command line tool. To see the App configuration used for this template, see [steps to recreate template](https://github.com/crafting-dev/template-ruby-rails#steps-to-recreate-template) below.

### 2. Creating Sandbox

Once App has been configured, you can create a sandbox using either the Web UI, or through the command line tool:

```
cs sandbox create
```

### 3. Developing with Sandbox

After creating a sandbox, you can start developing in the workspace using any of the Web UI or command line tools. The [docs](https://crafting.readme.io/docs/development-in-sandbox) contain more information for working with a sandbox. 

This template was generated following the steps [below](https://github.com/crafting-dev/template-ruby-rails#steps-to-recreate-template).

## Caveat

For the purposes of this template, the [Repo Manifest](https://crafting.readme.io/docs/repo-manifest) file [.sandbox/manifest.yaml](https://github.com/crafting-dev/template-ruby-rails/blob/master/.sandbox/manifest.yaml) is used to install needed packages and gems during build. 

In your own workspace, however, it is best that you make installation of tools, packages, customize shell, environment variables, etc. by making modification to the workspace and taking [snapshots](https://crafting.readme.io/docs/snapshots). 

You can instead use `Repo Manifests` to change automation with source code (eg. changing how code is built, etc.). 

See our [FAQ](https://crafting.readme.io/docs/frequently-asked-questions) for more details.

## Steps to recreate template

#### App configuration

The following App configuration was used to create this template (`cs app show -o yaml`):

```yaml
endpoints:
- http:
    routes:
    - backend:
        port: http
        target: ruby-rails
      path_prefix: /
  name: app
services:
- description: Ruby on Rails with MySQL template
  name: ruby-rails
  workspace:
    checkouts:
    - manifest:
        overlays:
        - content: ""
      path: src/template-ruby-rails
      repo:
        git: https://github.com/crafting-dev/template-ruby-rails.git
    packages:
    - name: ruby
      version: ~2.7
    - name: nodejs
      version: ~16
    ports:
    - name: http
      port: 3000
      protocol: HTTP/TCP
- managed_service:
    properties:
      root-password: batman
    service_type: mysql
    version: "8"
  name: mysql
```

The git repo under checkouts can be any empty remote git repository. 

#### Sandbox creation

Create a new sandbox with the above App configuration:

```
cs sandbox create
```

#### Develop in sandbox

Install necessary packages and gems before creating a new rails app in the workspace.

1. `sudo apt-get install -y libgmp3-dev`
2. `sudo apt-get install -y mysql-client libmysqlclient-dev`
3. `sudo apt-get update`
4. `gem install rails`

Create new rails app:

```
rails new . -d mysql
```

Update `config/database.yml`:

```yaml
default: &default
  adapter: mysql2
  encoding: utf8mb4
  pool: <%= ENV.fetch("RAILS_MAX_THREADS") { 5 } %>
  username: root
  password: batman # Use an environment variable in a real app setting
  host: <%= ENV['MYSQL_SERVICE_HOST'] %>

development:
  <<: *default
  database: mysql
  
production:
  <<: *default
  url: <%= ENV['MY_APP_DATABASE_URL'] %>
```

*NOTE 1*: Sandbox supports standard service injection, where the environment variables `MYSQL_SERVICE_HOST` and `MYSQL_SERVICE_PORT` are already populated. See [environment variables](https://crafting.readme.io/docs/environment-variables) for more details.

*NOTE 2*: For `production.url`, you can specify the connection url environment variable explicitly. Read [Configuring a database](https://guides.rubyonrails.org/configuring.html#configuring-a-database) for a full overview on how database connection configuration can be specified.


Then start a new rails server:

```
rails s
```