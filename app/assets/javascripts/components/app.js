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
      <div id="main-container">
        <header>
          <h1>Songocracy</h1>
        </header>
        <section className="queue-container">
          <form onSubmit={this.handleSubmit} className="track-form">
            <input onChange={this.onChange} value={this.state.text} />
          </form>
          <Queue />
        </section>
      </div>
    );
  }
});

module.exports = APP;
