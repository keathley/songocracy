/**
 * @jsx React.DOM
 */

var React = require('react');

var Song = React.createClass({
  render: function() {
    return (
      <div>
        <img src={this.props.song.images[1].url}
          height={150}
          width={148} />
        <h3>{this.props.song.artist}</h3>
        <h3>{this.props.song.name}</h3>
      </div>
    );
  }

});

module.exports = Song;