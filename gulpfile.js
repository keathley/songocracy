var gulp = require('gulp');
var browserify = require('gulp-browserify');
var concat = require('gulp-concat');
var sass = require('gulp-ruby-sass');
var minifycss = require('gulp-minify-css');
var rename = require('gulp-rename');

gulp.task('browserify', function(){
  gulp.src('app/assets/javascripts/main.js')
    .pipe(browserify({transform: 'reactify'}))
    .on('error', function(err) {
      console.log(err.message);
    })
    .pipe(concat('main.js'))
    .pipe(gulp.dest('public/js'));
});

gulp.task('styles', function() {
  gulp.src('app/assets/styles/**/*.scss')
    .pipe(sass({
      quiet: true,
      style: 'expanded',
      loadPath: [
        "bower_components/bourbon/dist",
        "bower_components/neat/app/assets/stylesheets",
        "bower_components/bitters/app/assets/stylesheets",
        "bower_components/font-awesome/scss"
      ]
    }))
    .pipe(gulp.dest('public/css'))
    .pipe(rename({suffix: '.min'}))
    .pipe(minifycss())
    .pipe(gulp.dest('public/css'));
});

gulp.task('copy', function() {
  gulp.src('src/index.html')
    .pipe(gulp.dest('public'));
});

gulp.task('default', ['browserify', 'styles', 'copy']);

gulp.task('watch', function() {
  gulp.watch('app/assets/**/*.*', ['default']);
});
