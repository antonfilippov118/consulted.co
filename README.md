[![Build Status](https://circleci.com/gh/floriank/consulted.png?circle-token=37979798070167a8f6b7caf53a1c6e4f0b8fffe5)](https://magnum.travis-ci.com/floriank/consulted)

# README

This is the main Rails app for consulted.co.

## Requirements

This app is supposed to run on Heroku.

To get started:

* change directory into cloned Repository:

```
cd location/to/consulted
```

* Needed modules / dependencies
...
- mongodb
- nodejs and/or npm
- bundler

* Install rvm from

```
\curl -sSL https://get.rvm.io | bash -s stable
```

* Install a version of nodejs (https://nodejs.org)

* Install ruby (rvm will give you a hint on this)

```
rvm install ruby-2.0.0-p451
```
rvm use ruby-2.0.0@consulted --create (if cd - hook doesn't do the job)
...


* Execute Bundler:

```
bundle install
```

* run the dev server

```
rails s
```

The app should now be available under http://localhost:3000.

## Alternative: Vagrant

This repository ships with a Vagrantfile to ease development.

You should make sure you install [vagrant](http://www.vagrantup.com/) and include the following plugins, once installed:

```
vagrant plugin install vagrant-librarian-chef
vagrant plugin install vagrant-vbguest
```

The VM can be started via console:

```
vagrant up
```


You can access the server via

```
vagrant ssh
```

and the app is located here:

```
cd /consulted.co
```

You can run `bundle` there and start the server via `rails s` afterwards:

```
bundle
bundle exec rails s
```

Ports are setup in a way that the app should now be reachable under http://localhost:3000/ from the host. MongoDB can be reached on port `27018`.

## Tests

Code should have tests attached.

The complete suite can be run via

```
bundle exec guard
```

This will also check compliance via Ruby style guidelines.


## Notes

### Platform settings usage

For now we store platform settings in PlaformSettings model and we have a simple
facade Settings for this. So we can use platform settings in code like here:

```ruby
Settings.platform_fee
```
