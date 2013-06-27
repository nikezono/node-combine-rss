module.exports.combiner = ->

  # utility
  async      = require 'async'
  _          = require 'underscore'
  url        = require 'url'
  path       = require 'path'
  http       = require 'http'

  # dependency
  parser  = require 'parse-rss'

  # user lib
  rss     = (require('./rss')).rss()

  # instance property
  urls = []


  #ObjectのURLを前削除
  deleteAll: ->
    urls = new Array()
    rss.init()

  # add ObjectにURLを追加する
  # @url [String or Array] １つ以上のurl
  add: (req,callback)->
    if _.isString(req)
      urls.push req
      callback urls if callback?
    else if _.isArray(req)
      async.forEach req,(val,cb)->
        urls.push val
        cb()
      ,->
        callback _.uniq(urls) if callback?

  # delete ObjectからURLを削除する
  # @url [String or Array] １つ以上のurl
  del: (req,callback)->
    if _.isString(req)
      urls = _.reject urls,(iterator_url)->
        return iterator_url is req
      callback urls if callback?

    else if _.isArray(req)
      async.forEach req,(val,cb)->
        urls = _.reject urls,(iterator_url)->
          return iterator_url is val
        cb()
      ,->
        callback urls if callback?

  # combine urlsから一つのRSSオブジェクトを生成する
  # @callback(option) rss Objectを返す(combiner.rssでバックグラウンド実行&同期取得できる)
  combine: (callback)->
    rss.init()
    async.forEach urls,(url,cb)->
      parser url, (articles)->
        rss.articles = rss.articles.concat articles
        cb()
    ,->
      rss.articles = _.sortBy _.uniq(rss.articles), (article)->
        return article.pubDate.getTime()
      rss.articles.reverse()
      callback rss if callback?

  # crawl combineのエイリアス
  crawl: (callback)->
    this.combine(callback)

  # Accessor Methods
  geturls: ->
    return urls

  rss: ->
    return rss
