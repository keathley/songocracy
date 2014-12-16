var APP = require('./components/app');
var React = require('react');
window.React = React;

React.render(
  <APP />,
  document.getElementById('main'));
