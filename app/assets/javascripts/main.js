/**
 * @jsx React.DOM
 */
var APP = require('./components/app');
var React = require('react');
window.React = React;
window.faye = new Faye.Client('http://localhost:9292/faye');

React.renderComponent(
  <APP />,
  document.getElementById('main'));
