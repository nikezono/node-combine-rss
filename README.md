node-combine-rss
---

combine rss feeds in url

input multiple rss feeds, then output single xml url

combined rss object can deal like below.

##install

***using npm:***

    npm install combine-rss

*** or using package.json: ***

    "combine-rss": "*"

##example
    # Coffeescript

    # rss feed urls
    apple    = "http://images.apple.com/main/rss/hotnews/hotnews.rss"
    livedoor = "http://news.livedoor.com/topics/rss/trend.xml"

    # schema
    schema = 
      title: "combiner_rss"
      description: "node_rss_combine"
      feed_url: "http://nikezono.net/rss.xml"
      site_url: "http://nikezono.net"
      image_url: "http://nikezono.net/favicon.ico"
      author: "nikezono"

    # require
    combiner = require('combine-rss').combiner()

    # add
    combiner.add [apple,livedoor]

    # delete
    combiner.del livedoor, (urls)->
      console.log urls
      # => ["http://images.apple.com/main/rss/hotnews/hotnews.rss"]

    # combine
    combiner.combine (rss)->
      console.log rss.articles
        # => combined articles array
      rss.output schema,(xml)->
        console.log xml
        # => xml string

    # combine(async)
    combiner.combine()
    setTimeout ->
      rss = combiner.rss()
      rss.output schema,(xml)->
        console.log xml
        # => xml string
    ,500

    #crawl(alias)
    combiner.crawl (rss)->
      rss.output schema,(xml)->
        console.log xml
        # => xml string
      console.log rss.articles
        # => combined articles array



## API

### Combiner

#### combiner.add(feed_url,[callback])
add **feed url** to instance property.
#####Arguments

* feed_url - either `String` and `Array` type argument is possible.
* callback(urls) - Optional. This function gets urls Array containing all added urls.

#### combiner.del(feed_url,[callback])
delete **feed url** in instance property.
#####Arguments

* feed_url - either `String` and `Array` type argument is possible.
* callback(urls) - Optional. This function gets urls Array containing all added urls.

#### combiner.deleteAll()
delete all url in instance property.

#### combiner.geturls()
Return urls Array containing all added urls.

#### combiner.combine([callback])
combine all urls to single rss object.
#####Arguments

* callback(rss) - Optional. This function gets `rss` object which combined all added urls.

#### combiner.rss()
Return RSS objects.

#### combiner.crawl([callback])
alias to `combine()`.

### RSS

#### rss.articles
Return rss Object Array sorted by PubDate and descending order.
each object is parsed by [node-parse-rss](https://github.com/nikezono/node-parse-rss) and this module is wrapper of [feedparser](https://github.com/danmactough/node-feedparser).

#### rss.output(schema,callback)
output rss xml.
#####Arguments

* schema - your RSS feed's schema.

**example**

      title: "combiner_rss"
      description: "node_rss_combine"
      feed_url: "http://nikezono.net/rss.xml"
      site_url: "http://nikezono.net"
      image_url: "http://nikezono.net/favicon.ico"
      author: "nikezono"

* callback(xml) - This function gets xml string which combined all added urls.

### Articles parameter(quote from [feedparser](https://github.com/danmactough/node-feedparser).)
##### List of meta properties

* title
* description
* link (website link)
* xmlurl (the canonical link to the feed, as specified by the feed)
* date (most recent update)
* pubdate (original published date)
* author
* language
* image (an Object containing `url` and `title` properties)
* favicon (a link to the favicon -- only provided by Atom feeds)
* copyright
* generator
* categories (an Array of Strings)

##### List of article properties

* title
* description (frequently, the full article content)
* summary (frequently, an excerpt of the article content)
* link
* origlink (when FeedBurner or Pheedo puts a special tracking url in the `link` property, `origlink` contains the original link)
* date (most recent update)
* pubdate (original published date)
* author
* guid (a unique identifier for the article)
* comments (a link to the article's comments section)
* image (an Object containing `url` and `title` properties)
* categories (an Array of Strings)
* source (an Object containing `url` and `title` properties pointing to the original source for an article; see the [RSS Spec](http://cyber.law.harvard.edu/rss/rss.html#ltsourcegtSubelementOfLtitemgt) for an explanation of this element)
* enclosures (an Array of Objects, each representing a podcast or other enclosure and having a `url` property and possibly `type` and `length` properties)
* meta (an Object containing all the feed meta properties; especially handy when using the EventEmitter interface to listen to `article` emissions)
