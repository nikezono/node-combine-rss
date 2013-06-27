// Generated by CoffeeScript 1.6.3
module.exports.rss = function() {
  var RSS, async, _;
  RSS = require('rss');
  _ = require('underscore');
  async = require('async');
  return {
    articles: [],
    /*
    # output xmlを出力する
    # @schema [hash] スキーマのハッシュ
    # example schema:
      title: "combiner_rss"
      description: "node_rss_combine"
      feed_url: "http://nikezono.net/rss.xml"
      site_url: "http://nikezono.net"
      image_url: "http://nikezono.net/favicon.ico"
      author: "nikezono"
    */

    output: function(schema, callback) {
      var feed, filtered;
      filtered = this.articles.slice(0, 30);
      feed = new RSS(schema);
      return async.forEach(filtered, function(article, cb) {
        feed.item({
          title: article.title,
          description: article.description,
          url: article.link,
          guid: article.guid,
          image: article.image,
          categories: article.categories,
          author: article.meta.title,
          date: article.pubDate
        });
        return cb();
      }, function() {
        return callback(feed.xml());
      });
    },
    init: function() {
      return this.articles = [];
    }
  };
};