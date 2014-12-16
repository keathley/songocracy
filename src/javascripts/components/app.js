var React = require('react');
var Queue = require('./queue');
var TrackService = require('../services/TrackService');
var ReactFireMixin = require('reactfire')
var Firebase = require('firebase');
var _ = require('lodash');

var APP = React.createClass({
  mixins: [ReactFireMixin],
  getInitialState: function() {
    return {
      text: '',
      songs: []
    };
  },
  componentWillMount: function() {
    this.bindAsArray(
      new Firebase("https://songocracy.firebaseio.com/songs/"), 'songs')
  },
  onChange: function(e) {
    this.setState({text: e.target.value});
  },
  handleSubmit: function(e) {
    e.preventDefault();
    var id = this.state.text.split(':')[2]
    var track = _.find(this.state.songs, { 'id': id });
    if (track) {
      var ref = this.firebaseRefs['songs'].child(track.id);
      TrackService.upvote(ref);
      this.setState({ text: '' });
    }
    else {
      TrackService.getById(id, (resp) => {
        this.firebaseRefs['songs'].child(resp.id).update(resp);
        this.setState({ text: '' });
      });
    }
  },
  render: function() {
    return (
      <div id="main-container">
        <header>
          <h1>Songocracy</h1>
        </header>
        <section className="queue-container">
          <form onSubmit={this.handleSubmit} className="track-form">
            <input onChange={this.onChange} value={this.state.text} />
          </form>
          <Queue songs={this.state.songs} />
        </section>
      </div>
    );
  }
});

module.exports = APP;
