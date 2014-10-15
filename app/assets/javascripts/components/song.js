/**
 * @jsx React.DOM
 */

var React = require('react');

var Song = React.createClass({
  render: function() {
    return (
      <div>
        <span>{this.props.song}</span>
      </div>
    );
  }

});

module.exports = Song;