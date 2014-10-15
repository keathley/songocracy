/**
 * @jsx React.DOM
 */
var APP = require('./components/app');
var React = require('react');
window.React = React;

React.renderComponent(
  <APP />,
  document.getElementById('main'));
