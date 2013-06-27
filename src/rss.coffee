module.exports.rss = ->

  # dependencies
  RSS   = require 'rss'
  _     = require 'underscore'
  async = require 'async'

  # instance property
  articles : []
  
  ###
  # output xmlを出力する
  # @schema [hash] スキーマのハッシュ
  # example schema:
    title: "combiner_rss"
    description: "node_rss_combine"
    feed_url: "http://nikezono.net/rss.xml"
    site_url: "http://nikezono.net"
    image_url: "http://nikezono.net/favicon.ico"
    author: "nikezono"
  ###
  output   : (schema,callback) ->
    filtered = this.articles.slice(0,30) # 30件
    feed = new RSS(schema)
    async.forEach filtered, (article,cb)->
      feed.item
        title: article.title
        description: article.description
        url: article.link
        guid: article.guid
        image: article.image
        categories: article.categories
        author: article.meta.title # Important
        date: article.pubDate
      cb()
    ,->
      callback feed.xml()

  # init articlesを初期化する
  init     : ->
    this.articles = []