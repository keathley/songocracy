/**
 * @jsx React.DOM
 */
var React = require('react');
var Queue = require('./queue');

var APP = React.createClass({
  getInitialState: function() {
    return {
      songs: [],
      text: ''
    };
  },
  onChange: function(e) {
    this.setState({text: e.target.value});
  },
  handleSubmit: function(e) {
    e.preventDefault();
    this.setState({
      songs: this.state.songs.concat([this.state.text]),
      text: ''
    });
  },
  render: function() {
    return (
      <div>
        <h1>Songocracy</h1>
        <form onSubmit={this.handleSubmit}>
          <input onChange={this.onChange} value={this.state.text} />
          <button>Add Song</button>
        </form>
        <Queue songs={this.state.songs}/>
      </div>
    );
  }
});
module.exports = APP;
