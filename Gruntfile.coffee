module.exports = (grunt) ->
  grunt.loadNpmTasks 'grunt-contrib-clean'
  grunt.loadNpmTasks 'grunt-contrib-copy'
  grunt.loadNpmTasks 'grunt-contrib-concat'
  grunt.loadNpmTasks 'grunt-contrib-uglify'
  grunt.loadNpmTasks 'grunt-contrib-watch'
  grunt.loadNpmTasks 'grunt-contrib-coffee'
  grunt.loadNpmTasks 'grunt-contrib-compass'
  grunt.loadNpmTasks 'grunt-angular-templates'
  grunt.loadNpmTasks 'grunt-contrib-compress'
  grunt.loadNpmTasks 'grunt-yui-compressor'

  grunt.initConfig
    clean:
      dest: ['public/css', 'public/js']
      tmp:  'public/css/app'

    concat:
      cssApp:
        src: 'public/css/app/*.css'
        dest: 'public/css/app.css'
      cssVendor:
        src: 'client/vendor/css/*.css'
        dest: 'public/css/vendor.css'
      jsVendor:
        src: [
          'client/vendor/js/jquery-2.0.3.js'
          'client/vendor/js/angular/angular.js'
          'client/vendor/js/angular/angular-route.js'
          'client/vendor/js/angular/angular-resource.js'
        ]
        dest: 'public/js/vendor.js'

    coffee:
      devel:
        options:
          join: true
          sourceMap: true
        src: [
          'client/js/main.coffee'
          'client/js/**/*.coffee'
        ]
        dest: 'public/js/app.js'
        filter: 'isFile'

    compass:
      compile:
        options:
          sassDir: 'client/scss'
          cssDir: 'public/css/app'
    
    ngtemplates:
      xuApp:
        options:
          url: (module) -> module.replace /client\//, ''
          htmlmin:
            collapseBooleanAttributes:      true
            collapseWhitespace:             true
            removeAttributeQuotes:          true
            removeComments:                 true
            removeEmptyAttributes:          true
            removeRedundantAttributes:      true
            removeScriptTypeAttributes:     true
            removeStyleLinkTypeAttributes:  true
        files:
          'public/js/templates.js': 'client/partials/app/**/*.html'

    watch:
      js:
        files: [
          'client/js/**/*.coffee'
          'client/js/**/*.js'
          'client/vendor/js/**/*.js'
          'client/partials/**/*.html'
        ]
        tasks: [
          'coffee:devel'
          'ngtemplates'
          'concat:jsVendor'
        ]
      css:
        files: ['client/scss/**/*']
        tasks: ['compass:compile', 'concat:cssApp']

  grunt.registerTask 'default', ['dev']

  grunt.registerTask 'dev', [
    'clean'

    'coffee:devel'
    'ngtemplates'
    'concat:jsVendor'

    'compass:compile'
    'concat:cssApp'
    'concat:cssVendor'

    'clean:tmp'
  ]

