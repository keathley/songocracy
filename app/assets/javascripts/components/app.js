/**
 * @jsx React.DOM
 */
var React = require('react');
var Queue = require('./queue');

var APP = React.createClass({
  getInitialState: function() {
    return {
      text: ''
    };
  },
  onChange: function(e) {
    this.setState({text: e.target.value});
  },
  handleSubmit: function(e) {
    e.preventDefault();
    $.post('/queue', { 'id': this.state.text });
    this.setState({
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
        <Queue />
      </div>
    );
  }
});

module.exports = APP;
