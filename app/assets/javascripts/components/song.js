/**
 * @jsx React.DOM
 */

var React = require('react');

var Song = React.createClass({
  render: function() {
    return (
      <div>
        <span>{this.props.song.name}</span>
        <span>{this.props.song.artist}</span>
        <span>{this.props.song.images}</span>
      </div>
    );
  }

});

module.exports = Song;