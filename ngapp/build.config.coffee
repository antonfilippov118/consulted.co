module.exports =
  build_dir: 'build'
  compile_dir: 'bin'
  app_files:
    js: [
      'src/**/*.js'
    ]
    coffee: [
      'src/**/*.coffee'
    ]
    coffeeunit: [
      'test/**/*.coffee'
    ]
    atpl: [
      'src/app/**/*.tpl.html'
    ]
    ctpl: [
      'src/common/**/*.tpl.html'
    ]
    html: [
      'src/index.html'
    ]
    less: 'src/less/style.less'
  test_files:
    js: [
      'vendor/angular-mocks/angular-mocks.js'
      'vendor/chai/chai.js'
      'vendor/should/should.js'
    ]
  vendor_files:
    js: [
      'vendor/angular/angular.js',
      'vendor/angular-route/angular-route.js'
      'vendor/angular-animate/angular-animate.js'
    ],
    css: []
    assets: []
