var React = require('react');
var Song = require('./song');
var _ = require('lodash');

var Queue = React.createClass({
  render: function() {
    var sortedSongs = _.sortBy(this.props.songs, (song) => {
      return song.upvotes - song.downvotes;
    }).reverse();
    var songs = sortedSongs.map(function(song) {
      return (
        <li key={song.id}>
          <Song song={song} />
        </li>
      );
    });
    return (
      <ul className="track-list">
        {songs}
      </ul>
    );
  }
});

module.exports = Queue;
