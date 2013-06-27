# Test dependency
path    = require 'path'
async   = require 'async'

# Test framework
assert  = require 'assert'

# Testing target
combiner = require(path.resolve('lib','combine-rss')).combiner()

# Sample URL
apple    = "http://images.apple.com/main/rss/hotnews/hotnews.rss"
livedoor = "http://news.livedoor.com/topics/rss/trend.xml"
geta6    = "http://blog.geta6.net/rss"

# Add
describe "#add", ->
  beforeEach (done)->
    combiner.deleteAll()
    done()

  afterEach (done)->
    combiner.deleteAll()
    done()

  it "Stringの追加", ->
    combiner.add apple,(urls)->
      assert.equal urls.length, 1

  it "Arrayの追加", ->
    combiner.add [livedoor,geta6],(urls)->
      assert.equal urls.length, 2

  it "Uniq処理", ->
    combiner.add [livedoor,livedoor],(urls)->
      assert.equal urls.length, 1

  it "非同期(non-callbacking)", ->
    combiner.add apple
    assert.equal combiner.geturls().length, 1

# Delete
describe "#del", ->
  beforeEach (done)->
    combiner.add [apple,livedoor,geta6],->
      done()

  afterEach (done)->
    combiner.deleteAll()
    done()

  it "Stringの削除", ->
    combiner.del apple,(urls)->
      assert.equal urls.length, 2

  it "Arrayの削除", ->
    combiner.del [apple,livedoor],(urls)->
      assert.equal urls.length, 1 

  it "非同期(non-callbacking)", ->
    combiner.del apple
    assert.equal combiner.geturls().length, 2

# combine
describe "#combine", ->
  rss = {}
  beforeEach (done)->
    async.series [ (cb)->
      combiner.add [geta6,apple,livedoor],->
        cb()
    ,(cb)->
      combiner.combine (res)->
        rss = res
        cb()
    ],(err,results)->
      done()

  afterEach (done)->
    combiner.deleteAll()
    done()

  it "コールバックが受け取られる",->
    assert rss.articles
    assert.notEqual rss.articles, []

  it "オプション無しのとき、結合されRSSオブジェクトが入る",(done)->
    combiner.combine()
    setTimeout ->
      assert combiner.rss().articles
      assert.notEqual combiner.rss().articles, []
      done()
    ,1000

  it "日付別に並んでいる", ->
    one   = rss.articles[0].pubDate.getTime()
    two   = rss.articles[1].pubDate.getTime()
    three = rss.articles[2].pubDate.getTime()
    assert.equal true, (one >= two >= three)

  it "#rss.output - XMLが出力される", ->
    combiner.rss().output 
      title: "combiner_rss"
      description: "node_rss_combine"
      feed_url: "http://nikezono.net/rss.xml"
      site_url: "http://nikezono.net"
      image_url: "http://nikezono.net/favicon.ico"
      author: "nikezono"
    ,(xml)->
      assert.equal xml.length > 0, true
      assert xml
      assert.equal typeof(xml), 'string'

  it "#rss.crawl  - combineのエイリアスとなっている",(done)->
    combiner.crawl()
    setTimeout ->
      assert combiner.rss().articles
      assert.notEqual combiner.rss().articles, []
      done()
    ,1000
