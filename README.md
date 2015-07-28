# LootCrate ![Code Ship](https://www.codeship.io/projects/cc8d31f0-1f1d-0131-b372-7ed4fea82a1b/status)

<!--[![Build Status](https://api.travis-ci.com/LootCrate/lootcrate.png?token=X3mC6HYvEdT5EgNCXnXj)](https://travis-ci.org/LootCrate/lootcrate)-->
[![Coverage Status](https://coveralls.io/repos/LootCrate/lootcrate/badge.png)](https://coveralls.io/r/LootCrate/lootcrate)
[![Code Climate](https://codeclimate.com/repos/5266ba7156b102152c02bf84/badges/c10e0b8b7525d8ef2167/gpa.png)](https://codeclimate.com/repos/5266ba7156b102152c02bf84/feed)

By [Loot Crate](http://lootcrate.com/).

Epic geek + gamer gear delivered monthly.

**Loot Crate** is a Rails app with Recurly integration through the [recurly] (https://github.com/recurly/recurly-client-ruby) gem.

## Installation

Fork the repository, clone locally:

```console
git clone git@github.com:your_username/lootcrate.git
```

Ensure using Ruby v2.2.0

Run the following command to install it:

```console
bundle install
```

**You will need to have postgres running**
**You should have rvm or rbenv**

## Set Environment
If you need to tweak environment variables, you can set them in your resource file (```.zshrc``` or ```.rc```), 
set them on the command line, or use a .env file.

There is an ```.env_example``` file you can copy over to ```.env``` to start with.

If you use this gem to handle env vars for multiple Rails environments (development, test, production, etc.), 
please note that env vars that are general to all environments should be stored in .env. Then, environment specific
env vars should be stored in .env.<that environment's name>. When you load a certain environment, dotenv will
first load general env vars from .env, then load environment specific env vars from .env.<current environment>.
Variables defined in .env.<current environment> will override any values set in .env or already defined in the 
environment.

    ENV[FF] = 'true' # enables feature testing in browser mode with selenium. the 'hang' command is very useful
    
    ENV['RECURLY_SUBDOMAIN'] = 'lootcrate-sandbox'
    
    ENV['RECURLY_API_KEY'] || '86e6...cb27'

Create development database
```console
createdb lootcrate_development
```

Run migrations and seed:

```console
bundle exec rake db:migrate
bundle exec rake db:seed
```

Install Redis
```console
brew install redis
```

Start foreman
```console
bundle exec foreman start -f Procfile.development
```

Create test database
```console
createdb lootcrate_test
```

Run tests
```console
brew install phantomjs
bundle exec rake db:test:prepare
bundle exec rake spec
bundle exec rake spec SPEC=/path/to/folder/or/file
```

**Creating Test Users**
Instructions: Run rake command below with desired test user. It will create all necessary data in database and chargify. It will output the email/password.

```console
bundle exec rake create_test_users:with_one_active_braintree_subscription
bundle exec rake create_test_users:help (list of commands)
```

## I18n

**Shipping** currently only United States and Canada.
**Billing** supports all countries.

## Information

### Documentation/Style Guide

Currently there is no central style guide or documentation. If/when we have that stuff, it should be added here.

## Contributers

* David Attilio Bellotti (https://github.com/dbellotti)
* Patrick Hunt (https://github.com/patrickhunt)
* Bryce Travis (https://github.com/btravis08)
* Eugene Dvortsov (https://github.com/eugenedvortsov)
