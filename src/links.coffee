# Description:
#   Link Storage
#
# Dependencies:
#   "cheerio": "^0.22.0"
#   "firebase": "^3.5.2"
#   "request": "^2.76.0"
#
# Configuration:
#   None
#
# Commands:
#   hubot save <link> | <description>  - saves a link with the given description
#   hubot show links  - show all saved links
#   hubot search links <query>  - fuzzy match link description and query
#   hubot show user links <user> - shows all links a user has posted
#
# Author:
#   Kyle Montag - kmontag42 on github

_ = require 'underscore'
Firebase = require 'firebase'
cheerio = require 'cheerio'
request = require 'request'
app = Firebase.database()

saveUrl = (url, description, res) ->
  app.ref('links/').once('value', (snapshot) ->
    console.log(snapshot.val())
    existingUrls = _.map(snapshot.val(),(x) ->
      x.url
    )
    if _.contains(existingUrls, url)
      console.log('Link already saved', url)
    else
      app.ref('links/').push({
        url: url,
        description: description,
        user: res.message.user.name
      })
  )

module.exports = (robot) ->
  robot.respond /save (((http[s]?|ftp):\/)?\/?([^:\/\s]+)((\/\w+)*\/)([\w\-\.]+[^#?\s]+)?(.*)?(#[\w\-]+)?) \| (.*)/i, (res) ->
    saveUrl(res.match[1], res.match[res.match.length-1], res)
    res.send 'Link saved'

  robot.respond /show links/i, (res) ->
    app.ref('links/').once('value', (snapshot) ->
      returnString = ''
      _.each(snapshot.val(), (x) ->
        returnString += ''+x.url+'\t'+x.description+'\t'+x.user+'\n'
      )
      res.send(returnString)
    )

  robot.respond /show user links (.*)/i, (res) ->
    app.ref('links/').once('value', (snapshot) ->
      filteredLinks = _.filter(snapshot.val(), (x) ->
        x.user && x.user.match(new RegExp(res.match[1]));
      )
      returnString = ''
      _.each(filteredLinks, (x) ->
        returnString += ''+x.url+'\t'+x.description+'\t'+x.user+'\n'
      )
      res.send(returnString)
    )

  robot.respond /search links (.*)/i, (res) ->
    app.ref('links/').once('value', (snapshot) ->
      filteredLinks = _.filter(snapshot.val(), (x) ->
        x.description && x.description.match(new RegExp(res.match[1]));
      )
      returnString = ''
      _.each(filteredLinks, (x) ->
        returnString += ''+x.url+'\t'+x.description+'\t'+x.user+'\n'
      )
      res.send(returnString)
    )

  robot.hear /((https?:\/\/)?(www\.)?[-a-zA-Z0-9@:%._\+~#=]{2,256}\.[a-z]{2,4}\b([-a-zA-Z0-9@:%_\+.~#?&//=]*))/i, (res) ->
    if res.message.user.name != 'hubot'
      url = res.match[1].split(' ')[0].replace(' null', '')
      request.get(url, (err, resp, body) ->
        if !err
          if resp.statusCode == 200
            $ = cheerio.load(body)
            if $('meta[property="og:title"]').length > 0
              saveUrl(url, $('meta[property="og:title"]').attr("content"), res)
            else
              saveUrl(url, $('title').html(), res)
          else
            saveUrl(url, '', res)
        else
#          res.send('there was an error')
          robot.messageRoom '@kyle', 'Error with GET: ' + url + ' ' + err
      )
