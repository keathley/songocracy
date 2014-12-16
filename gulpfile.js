var gulp       = require('gulp');
var browserify = require('browserify');
var sass       = require('gulp-ruby-sass');
var source     = require('vinyl-source-stream');
var buffer     = require('vinyl-buffer');


gulp.task('browserify', function() {
  return browserify('./src/javascripts/main.js')
    .transform('reactify', {
      "es6": true
    })
    .bundle()
    .pipe(source('main.js'))
    .pipe(gulp.dest('public/js'));
});

gulp.task('styles', function() {
  gulp.src('src/assets/styles/**/*.scss')
    .pipe(sass({
      quiet: true,
      style: 'expanded',
      loadPath: [
        "bower_components/bourbon/dist"
      ]
    }))
    .pipe(gulp.dest('public/css'));
});

gulp.task('copy', function() {
  gulp.src('src/index.html')
    .pipe(gulp.dest('public'));
});
gulp.task('default', ['browserify', 'styles', 'copy']);

gulp.task('watch', function() {
  gulp.watch('src/**/*.js', ['default']);
});
