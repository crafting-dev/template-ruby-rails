# A Rails with MySQL template for Cloud Sandbox

This is a skeleton [ruby on rails](https://rubyonrails.org/) application template created on a basic [App](https://crafting.readme.io/docs/app-spec) configuration in [Cloud Sandbox](https://crafting.readme.io/docs/introduction). 

## Getting Started

The general workflow when developing in Cloud Sandbox involves:

1. [Configuring App](https://github.com/crafting-dev/template-ruby-rails#configuring-app)
2. [Creating Sandbox](https://github.com/crafting-dev/template-ruby-rails#creating-sandbox)
3. [Developing with Sandbox](https://github.com/crafting-dev/template-ruby-rails#developing-with-sandbox)

### 1. Configuring App

[App](https://crafting.readme.io/docs/app-spec) can be viewed/edited either on the [Web UI](https://sandboxes.cloud/app) or via the [`cs`](https://sandboxes.cloud/download) command line tool. To see the App configuration used for this template, see [steps to recreate template](https://github.com/crafting-dev/template-ruby-rails#steps-to-recreate-template) below.

### 2. Creating Sandbox

Once App has been configured, you can create a sandbox using either the Web UI, or using the command line tool:

```
cs sandbox create
```

### 3. Developing with Sandbox

After creating a sandbox, you can start developing in the workspace using any of the Web UI or command line tools. The [docs](https://crafting.readme.io/docs/development-in-sandbox) contain more information for working with a sandbox. This template was generated following the steps [below](https://github.com/crafting-dev/template-ruby-rails#steps-to-recreate-template).

## Caveat

For the purposes of this template, the [Repo Manifest](https://crafting.readme.io/docs/repo-manifest) file [.sandbox/manifest.yaml](https://github.com/crafting-dev/template-ruby-rails/blob/master/.sandbox/manifest.yaml) is used to install needed packages and gems during build. 

In your own workspace, however, it is best that you make installation of tools, packages, customize shell, environment variables, etc. by making modification to the workspace and taking [snapshots](https://crafting.readme.io/docs/snapshots). 

You can instead use `Repo Manifests` to change automation with source code (eg. changing how code is built, etc.). 

See our [FAQ](https://crafting.readme.io/docs/frequently-asked-questions) for more details.

## Steps to recreate template

#### App configuration

The following App configuration was used to create this template (`cs app show -o yaml`):

```yaml
spec:
  endpoints:
  - http:
      routes:
      - backend:
          port: localhost
          target: ruby-rails
        path_prefix: /
    name: base
  services:
  - description: Ruby/Rails template
    name: ruby-rails
    workspace:
      checkouts:
      - manifest:
          overlays:
          - content: ""
        path: src/template-ruby-rails
        repo:
          git: git@github.com:crafting-dev/template-ruby-rails.git
      packages:
      - name: ruby
        version: 2.7.2
      - name: nodejs
        version: 16.9.1
      port_forward_rules:
      - local: "3306"
        remote:
          port: mysql
          target: mysql
      ports:
      - name: localhost
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

1. `sudo apt-get install libgmp3-dev`
2. `gem install rails`
3. `sudo apt-get update`
4. `sudo apt-get install mysql-client libmysqlclient-dev`

Make mysql credentials set in App configurations available as environment variables:

1. `echo "export MYSQL_DB=\"mysql\"" >> ~/.bashrc`
2. `echo "export MYSQL_PASS=\"batman\"" >> ~/.bashrc`

Create new rails app:

```
rails new . -d mysql
```

Update `config/database.yml` to use the already set mysql credentials:

```yaml
default: &default
  adapter: mysql2
  encoding: utf8mb4
  pool: <%= ENV.fetch("RAILS_MAX_THREADS") { 5 } %>
  username: root
  password: <%= ENV['MYSQL_PASS'] %>
  host: <%= ENV['MYSQL_DB'] %>

development:
  <<: *default
  database: <%= ENV['MYSQL_DB'] %>
  
production:
  <<: *default
  url: <%= ENV['MY_APP_DATABASE_URL'] %>
```

Then start a new rails server:

```
rails s
```