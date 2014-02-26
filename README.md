[![Build Status](https://magnum.travis-ci.com/floriank/consulted.png?token=bNVgt7Atr6dPqBZnmFEV&branch=master)](https://magnum.travis-ci.com/floriank/consulted)

# README

This is the main Rails app for consulted.co.

## Requirements

This app is supposed to run on Heroku.

To get started:

* change directory into cloned Repository:

```
cd location/to/consulted
````

* Install rvm from

```
\curl -sSL https://get.rvm.io | bash -s stable
```

* Install ruby (rvm will give you a hint on this)

```
rvm install ruby-2.0.0-p353
```

* Execute Bundler:

```
bundle install
```

* run the dev server

```
rails s
```

The app should now be available under http://localhost:3000.

## Tests

Code should have tests attached.

The complete suite can be run via

```
bundle exec guard
```

This will also check compliance via Ruby style guidelines.

