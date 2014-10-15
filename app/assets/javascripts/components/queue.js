/**
 * @jsx React.DOM
 */
var React = require('react');
var Song = require('./song');

var Queue = React.createClass({
  render: function() {
    var songs = this.props.songs.map(function(song) {
      return (
        <li>{song}</li>
      );
    });
    return (
      <div>
        {songs}
      </div>
    );
  }
});

module.exports = Queue;