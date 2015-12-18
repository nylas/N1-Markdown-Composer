fs = require 'fs'
path = require 'path'
marked = require 'marked'
Utils = require './utils'
{React, ComponentRegistry, DraftStore, QuotedHTMLTransformer} = require 'nylas-exports'
{EventedIFrame, ResizableRegion, Flexbox} = require 'nylas-component-kit'

# Keep a file-scope variable containing the contents of the markdown stylesheet.
# This will be embedded in the markdown preview iFrame, as well as the email body.
# The stylesheet is loaded when a preview component is first mounted.
markdownStylesheet = null

class MarkdownEditor extends React.Component
  @displayName: 'MarkdownEditor'

  @propTypes:
    body: React.PropTypes.string.isRequired,
    onFocus: React.PropTypes.func.isRequired,
    onBodyChanged: React.PropTypes.func.isRequired,

  constructor: (@props) ->
    @_session = null
    @state = textContent: Utils.getTextFromHtml(@props.body)

  componentDidMount: =>
    # Check if the markdownStylesheet has been loaded. If it is currently null,
    # fetch the file and populate the variable.
    markdownStylesheet ||= fs.readFileSync(path.resolve(__dirname, "../stylesheets/markdown.css" ))

  componentWillReceiveProps: (newProps) =>
    if @props.body isnt newProps.body
      @_updateContent(Utils.getTextFromHtml(newProps.body))

  focusEditor: =>
    textarea = React.findDOMNode(@refs.textarea)
    textarea.focus()
    textarea.selectionStart = textarea.selectionEnd = textarea.value.length

  getCurrentSelection: ->

  getPreviousSelection: ->

  _onDOMMutated: ->

  _markdownToHtml: (markdown) =>
    try
      marked(markdown)
    catch err
      @_onError(err)

  _updateContent: (textContent) =>
    @setState({textContent})
    @_renderIntoIframe(textContent)

  _onTextAreaChanged: (event)=>
    @props.onBodyChanged(event)
    @_updateContent(event.target.value)

  _onError: (error) =>
    dialog = require('remote').require('dialog')
    dialog.showErrorBox('Markdown Conversion Failed', error.toString())

  _renderIntoIframe: (markdown)=>
    html = @_markdownToHtml(markdown)
    doc = React.findDOMNode(@refs.previewFrame).contentDocument
    doc.open()

    # NOTE: The iframe must have a modern DOCTYPE. The lack of this line
    # will cause some bizzare non-standards compliant rendering with the
    # message bodies. This is particularly felt with <table> elements use
    # the `border-collapse: collapse` css property while setting a
    # `padding`.
    doc.write("<!DOCTYPE html>")
    doc.write("<style>#{markdownStylesheet}</style>")
    doc.write("<div class='markdown-body' id='inbox-html-wrapper'>#{html}</div>")
    doc.close()

    frame = React.findDOMNode(@refs.previewFrame)
    frame.style.height = frame.contentWindow.document.body.scrollHeight + "px"

  render: =>
    # Draw a resizable region to contain our document frame. The markdown
    # preview itself will be drawn inside of an iFrame so that it is entirely self
    # contained, and the possibility of XSS insecurities is reduced.
    <Flexbox className="markdown-editor">
      <textarea
        className="editing-region"
        ref="textarea"
        value={@state.textContent}
        onFocus={@props.onFocus}
        onChange={@_onTextAreaChanged} />
      <ResizableRegion ref="previewRegion" className="preview-region" handle={ResizableRegion.Handle.Left}>
        <EventedIFrame ref="previewFrame" seamless="seamless" scrolling="no"/>
      </ResizableRegion>
    </Flexbox>

module.exports = MarkdownEditor
