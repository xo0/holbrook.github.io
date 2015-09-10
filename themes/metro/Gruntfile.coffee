module.exports = (grunt) ->
  require('load-grunt-tasks') grunt

  grunt.initConfig
    autoprefixer:
      options:
        browsers: ['last 1 version']
      dist:
        files: [
          expand: true
          cwd: '.tmp/assets/stylesheets/'
          src: '{,*/}*.css'
          dest: '.tmp/assets/stylesheets/'
        ]

    buildcontrol:
      options:
        dir: 'dist'
        commit: true
        push: true
        message: 'Build from commit %sourceCommit% on branch %sourceBranch%'
      github:
        options:
          remote: ''
          branch: 'master'

    clean:
      dist: ['dist', '.tmp']
      server: ['.jekyll', '.tmp']

    coffee:
      dist:
        files: [
          expand: true
          cwd: 'app/assets/javascripts'
          src: '{,*/}*.coffee'
          dest: '.tmp/assets/javascripts'
          ext: '.js'
        ]
      test:
        files: [
          expand: true
          cwd: 'spec'
          src: '{,*/}*.coffee'
          dest: '.tmp/spec'
          ext: '.js'
        ]

    concurrent:
      dist: [
        'coffee:dist'
        'sass'
        'imagemin'
        'copy'
      ]
      server: [
        'coffee:dist'
        'sass'
        'jekyll:server'
      ]
      test: [
        'coffee'
        'sass'
      ]

    connect:
      options:
        port: 9000
        livereload: 35729
        hostname: '0.0.0.0'
      dist:
        options:
          open: true
          base: 'dist'
          livereload: false
      livereload:
        options:
          open: true
          base: ['.tmp', '.jekyll', 'app']
      test:
        options:
          base: ['.tmp', '.jekyll', 'test', 'app']

    copy:
      dist:
        files: [
          expand: true
          dot: true
          cwd: 'app'
          dest: 'dist'
          src: [
            '{,*/}*.{ico,png,txt}'
            '.htaccess'
          ]
        ]

    filerev:
      images:
        src: ['dist/assets/images/{,*/}*.{gif,jpeg,jpg,png}']
      scripts:
        src: ['dist/assets/javascripts/{,*/}*.js']
      styles:
        src: ['dist/assets/stylesheets/{,*/}*.css']

    htmlmin:
      options:
        collapseBooleanAttributes: true
        collapseWhitespace: true
        removeAttributeQuotes: true
        removeEmptyAttributes: true
        removeRedundantAttributes: true
      dist:
        files: [
          expand: true
          cwd: 'dist'
          src: '**/*.html'
          dest: 'dist'
        ]

    imagemin:
      options:
        cache: false
      dist:
        files: [
          expand: true
          cwd: 'app/assets/images'
          src: '{,*/}*.{gif,jpeg,jpg,png}'
          dest: 'dist/assets/images'
        ]

    jasmine:
      all:
        src: '.tmp/assets/javascripts/{,*/}*.js'
        options:
          specs: '.tmp/spec/{,*/}*.js'
          vendor: ['app/assets/_bower_components/jquery/dist/jquery.js']
          keepRunner: true

    jekyll:
      options:
        bundleExec: true
        config: '_config.yml,_config.build.yml'
        src: 'app'
      dist:
        options:
          dest: 'dist'
      server:
        options:
          config: '_config.yml'
          dest: '.jekyll'

    modernizr:
      dist:
        devFile: 'app/assets/_bower_components/modernizr/modernizr.js'
        outputFile: 'dist/assets/javascripts/modernizr.js'
        files:
          src: [
            'dist/assets/javascripts/{,*/}*.js'
            'dist/assets/stylesheets/{,*/}*.css'
            '!dist/assets/javascripts/modernizr.js'
          ]
        uglify: true

    sass:
      options:
        loadPath: 'app/assets/_bower_components'
      dist:
        files: [
          expand: true
          cwd: 'app/assets/stylesheets'
          src: ['{,*/}*.scss']
          dest: '.tmp/assets/stylesheets'
          ext: '.css'
        ]

    usemin:
      options:
        assetsDirs: ['dist', 'dist/assets/images']
      html: ['dist/**/*.html']
      css: ['dist/assets/stylesheets/{,*/}*.css']

    useminPrepare:
      html: 'app/**/*.html'

    watch:
      coffee:
        files: ['app/assets/javascripts/{,*/}*.coffee']
        tasks: ['coffee:dist']
      coffeeTest:
        files: ['spec/{,*/}*.coffee']
        tasks: ['coffee:test', 'jasmine']
      jekyll:
        files: ['app/**/*.{html,md}', '*.yml']
        tasks: ['jekyll:server']
      sass:
        files: ['app/assets/stylesheets/{,*/}*.scss']
        tasks: ['sass', 'autoprefixer']
      livereload:
        options:
          livereload: 35729
        files: [
          'app/**/*.html'
          'app/assets/images/{,*/}*.{gif,jpeg,jpg,png}'
          '.tmp/assets/stylesheets/{,*/}*.css'
          '.tmp/assets/javascripts/{,*/}*.js'
          '.jekyll/**/*.html'
        ]

  grunt.registerTask 'serve', (target) ->
    return grunt.task.run(['build', 'connect:dist:keepalive']) if target is 'dist'

    grunt.task.run [
      'clean:server'
      'concurrent:server'
      'autoprefixer'
      'connect:livereload'
      'watch'
    ]

  grunt.registerTask 'test', [
    'clean:server'
    'concurrent:test'
    'connect:test'
    'jasmine'
  ]

  grunt.registerTask 'build', [
    'clean:dist'
    'jekyll:dist'
    'useminPrepare'
    'concurrent:dist'
    'autoprefixer'
    'concat'
    'cssmin'
    'uglify'
    'modernizr'
    'filerev'
    'usemin'
    'htmlmin'
  ]

  grunt.registerTask 'default', [
    'test'
    'build'
  ]
