module.exports = (grunt) ->
  [
    "contrib-clean"
    "contrib-copy"
    "contrib-concat"
    "contrib-watch"
    "contrib-uglify"
    "contrib-coffee"
    "conventional-changelog"
    "bump"
    "coffeelint"
    "recess"
    "karma"
    "html2js"
    "shell"
    "devserver"
  ].forEach (name) ->
    grunt.loadNpmTasks "grunt-#{name}"

  userConfig = require "./build.config"

  taskConfig =
    pkg: grunt.file.readJSON "package.json"

    meta:
      banner:
        "/**\n" +
        " * <%= pkg.name %> - v<%= pkg.version %> - <%= grunt.template.today('yyyy-mm-dd') %>\n" +
        " * <%= pkg.homepage %>\n" +
        " *\n" +
        " * Copyright (c) <%= grunt.template.today('yyyy') %> <%= pkg.author %>\n" +
        " * Licensed <%= pkg.licenses.type %> <<%= pkg.licenses.url %>>\n" +
        " */\n"

    changelog:
      options:
        dest: "CHANGELOG.md"
        template: 'changelog.tpl'

    devserver:
      options:
        port: 8000
        base: './build'

    bump:
      options:
        files: [
          "package.json"
          "bower.json"
        ]
        commit: no
        commitMessage: 'chore(release): v%VERSION%'
        commitFiles: [
          "package.json"
          "client/bower.json"
        ]
        createTag: no
        tagName: 'v%VERSION%'
        tagMessage: 'Version %VERSION%'
        push: no
        pushTo: 'origin'

    clean: [
      '<%= build_dir %>'
      '<%= compile_dir %>'
    ]

    copy:
      build_app_assets:
        files: [
          src: ["**"]
          dest: "<%= build_dir %>/assets/"
          cwd: "src/assets"
          expand: yes
        ]

      build_vendor_assets:
        files: [
          src: ["<%= vendor_files.assets %>", "<%= vendor_files.css %>"]
          dest: "<%= build_dir %>/assets/"
          cwd: "."
          expand: yes
          flatten: yes
        ]

      build_appjs:
        files: [
          src: ["<%= app_files.js %>"]
          dest: "<%= build_dir %>/"
          cwd: "."
          expand: yes
        ]

      build_vendorjs:
        files: [
          src: ["<%= vendor_files.js %>"]
          dest: "<%= build_dir %>/"
          cwd: "."
          expand: yes
        ]

      compile_assets:
        files: [
          src: ["**"]
          dest: "<%= compile_dir %>/assets"
          cwd: "<%= build_dir %>/assets"
          expand: yes
        ]
    shell:
      options:
        stdout: no
      copy_rails:
        command: "cp -r bin/ ../public/"
      copy_rails_build:
        command: "cp -r build/ ../public/"



    concat:
      build_css:
        src: ["<%= vendor_files.css %>", "<%= recess.build.dest %>"]
        dest: "<%= recess.build.dest %>"

      compile_js:
        options:
          banner: "<%= meta.banner %>"
        src: ["<%= vendor_files.js %>", "module.prefix", "<%= build_dir %>/src/**/*.js", "<%= html2js.app.dest %>", "<%= html2js.common.dest %>", "module.suffix"]
        dest: "<%= compile_dir %>/assets/<%= pkg.name %>-<%= pkg.version %>.js"

    coffee:
      source:
        options:
          bare: yes
        expand: yes
        cwd: "."
        src: ["<%= app_files.coffee %>"]
        dest: "<%= build_dir %>"
        ext: ".js"

    uglify:
      compile:
        options:
          banner: "<%= meta.banner %>"
        files:
          "<%= concat.compile_js.dest %>": "<%= concat.compile_js.dest %>"

    recess:
      build:
        src: ["<%= app_files.less %>"]
        dest: "<%= build_dir %>/assets/<%= pkg.name %>-<%= pkg.version %>.css"
        options:
          compile: yes
          compress: no
          noUnderscores: no
          noIDs: no
          zeroUnits: no
          includePath: ['vendor/bootstrap/less', 'vendor/animate-less/less']

      compile:
        src: ["<%= recess.build.dest %>"]
        dest: "<%= recess.build.dest %>"
        options:
          compile: yes
          compress: yes
          noUnderscores: no
          noIDs: no
          zeroUnits: no

    coffeelint:
      src:
        files:
          src: ["<%= app_files.coffee %>"]

      test:
        files:
          src: ["<%= app_files.coffeeunit %>"]

      options:
        max_line_length: 120

    html2js:
      app:
        options:
          base: "src/app"
        src: ["<%= app_files.atpl %>"]
        dest: "<%= build_dir %>/templates-app.js"

      common:
        options:
          base: "src/common"
        src: ["<%= app_files.ctpl %>"]
        dest: "<%= build_dir %>/templates-common.js"

    karma:
      options:
        configFile: "<%= build_dir %>/karma-unit.js"

      unit:
        port: 9877
        runnerPort: 9100
        background: yes

      continuous:
        singleRun: yes

    index:
      build:
        dir: "<%= build_dir %>"
        src: ["<%= vendor_files.js %>", "<%= build_dir %>/src/**/*.js", "<%= html2js.common.dest %>", "<%= html2js.app.dest %>", "<%= vendor_files.css %>", "<%= recess.build.dest %>"]
      compile:
        dir: "<%= compile_dir %>"
        src: ["<%= concat.compile_js.dest %>", "<%= vendor_files.css %>", "<%= recess.compile.dest %>"]

    karmaconfig:
      unit:
        dir: "<%= build_dir %>"
        src: ["<%= vendor_files.js %>", "<%= html2js.app.dest %>", "<%= html2js.common.dest %>", "<%= test_files.js %>"]

    delta:
      options:
        livereload: yes
      gruntfile:
        files: "Gruntfile.coffee"
        options:
          livereload: no
      coffeesrc:
        files: ["<%= app_files.coffee %>"]
        tasks: ["coffeelint:src", "coffee:source", "karma:unit:run", "copy:build_appjs", "shell:copy_rails_build"]
      assets:
        files: ["src/assets/**/*"]
        tasks: ["copy:build_assets", "shell:copy_rails_build"]
      html:
        files: ["<%= app_files.html %>"]
        tasks: ["index:build", "shell:copy_rails_build"]
      tpls:
        files: ["<%= app_files.atpl %>", "<%= app_files.ctpl %>"]
        tasks: ["html2js", "shell:copy_rails_build"]
      less:
        files: ["src/**/*.less"]
        tasks: ["recess:build", "shell:copy_rails_build"]
      coffeeunit:
        files: ["<%= app_files.coffeeunit %>"]
        tasks: ["coffeelint:test", "karma:unit:run"]
        options:
          livereload: no

  grunt.initConfig grunt.util._.extend(taskConfig, userConfig)
  grunt.renameTask "watch", "delta"
  grunt.registerTask "server", ["devserver"]

  grunt.registerTask "watch", ["build", "karma:unit", "delta"]
  grunt.registerTask "build", [
    'clean'
    'html2js'
    'coffeelint'
    'coffee'
    'recess:build'
    'concat:build_css'
    'copy:build_app_assets'
    'copy:build_vendor_assets'
    'copy:build_appjs'
    'copy:build_vendorjs'
    'index:build'
    'karmaconfig'
    'karma:continuous'
  ]
  grunt.registerTask "compile", [
    'recess:compile'
    'copy:compile_assets'
    'concat:compile_js'
    'uglify'
    'index:compile'
  ]

  grunt.registerTask "default", ["build", "compile", "shell:copy_rails"]

  filterForJS = (files) ->
    files.filter (file) ->
      file.match /\.js$/

  filterForCSS = (files) ->
    files.filter (file) ->
      file.match(/\.css$/) and !file.match(/vendor/)

  grunt.registerMultiTask "index", "Process index.html template", ->
    dirRE    = new RegExp("^(#{grunt.config("build_dir")}|#{grunt.config("compile_dir")})/", "g")
    jsFiles = filterForJS(@filesSrc).map((file) ->
      file = file.replace dirRE, ""
    )
    cssFiles = filterForCSS(@filesSrc).map((file) ->
      file = file.replace dirRE, ""
    )

    grunt.file.copy "src/index.html", "#{@data.dir}/index.html",
      process: (contents, path) ->
        grunt.template.process contents,
          data:
            scripts: jsFiles
            styles: cssFiles
            version: grunt.config("pkg.version")

  grunt.registerMultiTask "karmaconfig", "Process karma config templates", ->
    jsFiles = filterForJS(@filesSrc)
    grunt.file.copy "karma/karma-unit.tpl.js", "#{grunt.config("build_dir")}/karma-unit.js",
      process: (contents, path) ->
        grunt.template.process contents,
          data:
            scripts: jsFiles








