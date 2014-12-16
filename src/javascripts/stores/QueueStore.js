var Reflux = require('reflux');
var QueueActions = require('../actions/QueueActions');

var QueueStore = Reflux.createStore({
  init: {
    this.songs = {};
  }
});

module.exports = QueueStore;
