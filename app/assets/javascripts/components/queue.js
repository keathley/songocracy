/**
 * @jsx React.DOM
 */
var React = require('react');
var Song = require('./song');

var Queue = React.createClass({
  getInitialState: function() {
    return {
      songs: []
    };
  },
  componentDidMount: function() {
    faye.subscribe('/songs', function(song) {
      this.updateSongList(song);
    }.bind(this));

    $.get('/queue', function(data) {
      console.log(data);
      this.loadSongs(data);
    }.bind(this));
  },
  loadSongs: function(songs) {
    this.setState({
      songs: songs
    });
  },
  updateSongList: function(song) {
    console.log(song);
    this.setState({
      songs: this.state.songs.concat([song])
    });
  },
  render: function() {
    var songs = this.state.songs.map(function(song) {
      return (
        <li><Song song={song} /></li>
      );
    });
    return (
      <ul>
        {songs}
      </ul>
    );
  }
});

module.exports = Queue;