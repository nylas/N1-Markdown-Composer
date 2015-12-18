marked = require 'marked'
Utils = require './utils'
{ComposerExtension} = require 'nylas-exports'

class MarkdownComposerExtension extends ComposerExtension

  @finalizeSessionBeforeSending: (session) ->
    html = marked(Utils.getTextFromHtml(session.draft().body))
    session.changes.add({body: html}, {silent: true})

module.exports = MarkdownComposerExtension
