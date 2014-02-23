[![Build Status](https://magnum.travis-ci.com/floriank/consulted.png?token=bNVgt7Atr6dPqBZnmFEV&branch=master)](https://magnum.travis-ci.com/floriank/consulted)

# README

This is the main Rails app for consulted.co.

## Requirements

This app is supposed to run on [TorqueBox](http://torquebox.org) and therefore requires [JRuby](http://jruby.org).

To get started:

* change directory into cloned Repo:

> cd location/to/consulted

* Install rvm from

> \curl -sSL https://get.rvm.io | bash -s stable

* Install jruby (rvm will give you a hint on this)

> rvm install jruby-1.7.10

* Execute Bundler:

> bundle install

* run TorqueBox:

> torquebox run

This will boot up the application server. However, you still need to deploy the actual application:

> torquebox deploy

The app should now be available under http://localhost:8080.

In development mode, code is reloaded automatically and therefore no redeploy is neccessary.

## Tests

Code should have tests attached.

The complete suite can be run via

> bundle exec guard

This will also check compliance via Ruby style guidelines.

