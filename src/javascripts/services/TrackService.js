var reqwest = require('reqwest');

var TrackService = {
  getById: function(id, cb) {
    reqwest({
      url: "https://api.spotify.com/v1/tracks/" + id,
      method: 'get',
      contentType: 'application/json',
      crossOrigin: true,
      success: (resp) => {
        var track = {
          id: resp.id,
          url: resp.uri,
          href: resp.href,
          artist: {
            id: resp.artists[0].id,
            name: resp.artists[0].name,
            href: resp.artists[0].href
          },
          album_name: resp.album.name,
          image: resp.album.images[1],
          upvotes: 1,
          downvotes: 0
        };
        cb(track);
      }
    });
  },
  upvote: function(ref) {
    ref.child('upvotes').transaction((current_value) => {
      return (current_value || 0) + 1;
    });
  }
};

module.exports = TrackService;