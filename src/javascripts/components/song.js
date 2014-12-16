var React = require('react');
var ReactFireMixin = require('reactfire');
var Firebase = require('firebase');
var TrackService = require('../services/TrackService');

var Song = React.createClass({
  mixins: [ReactFireMixin],
  componentWillMount: function() {
    this.bindAsObject(
      new Firebase("https://songocracy.firebaseio.com/songs/" + this.props.song.id),
      'song')
  },
  onUpvote: function() {
    var ref = this.firebaseRefs['song'];
    TrackService.upvote(ref);
  },
  render: function() {
    var song = this.props.song || {};
    return (
      <div>
        <button onClick={this.onUpvote}>
          Upvote
        </button>
        <img src={song.image.url}
          height={150}
          width={148} />
        <h3>{song.artist}</h3>
        <h3>{song.name}</h3>
        <h3>{song.upvotes}</h3>
      </div>
    );
  }
});

module.exports = Song;
