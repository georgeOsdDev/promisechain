pkg = require './package.json'
gulp = require 'gulp'
gutil = require 'gulp-util'
clean = require 'gulp-clean'
mocha = require 'gulp-mocha'
uglify = require 'gulp-uglify'
rename = require 'gulp-rename'
jshint = require 'gulp-jshint'
stylish = require 'jshint-stylish'
browserify = require 'gulp-browserify'
sourcemaps = require 'gulp-sourcemaps'

gulp.task 'default', ->
  gulp.run 'build'

gulp.task 'clean', ->
  gulp.src 'dist/*', {read: false}
      .pipe clean()

gulp.task 'lint', ->
  gulp.src 'lib/jsonkey.js'
      .pipe jshint()
      .pipe jshint.reporter('jshint-stylish')
      .pipe jshint.reporter('fail')
      .on "error", gutil.log

gulp.task 'test', ->
  gulp.src 'test/test.js', {read: false}
      .pipe mocha {reporter: 'nyan'}
      .on "error", gutil.log

gulp.task 'compress', ->
  gulp.src './dist/promisechain_bundle.js'
      .pipe sourcemaps.init()
      .pipe uglify(mungle: true)
      .pipe rename("promisechain_bundle.min.js")
      .pipe sourcemaps.write(".")
      .pipe gulp.dest('./dist')
      .on "error", gutil.log

gulp.task 'bundle', ->
  gulp.src 'browser.js'
      .pipe browserify()
      .pipe rename("promisechain_bundle.js")
      .pipe gulp.dest('./dist')
      .on "error", gutil.log

gulp.task 'build', ['lint', 'test'], ->
  gulp.run 'clean', ->
    gulp.run 'bundle', ->
      gulp.run 'compress', ->
