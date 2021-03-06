Ember.Handlebars.registerBoundHelper 'htmlBodyFormatter', (email, options) ->
  iFrameContainerSelector = ".email-history [data-id='#{email.get('id')}']"
  iFrameContainerSelector +=  " .iframe-container"

  if !email.get('message')?.length && !email.get('html')?.length
    Ember.run.next ->
      iFrameContainer = $(iFrameContainerSelector)

      iFrameContainer.children('iframe').remove()

    return new Handlebars.SafeString("<p>(No Message)</p>")

  if email.get('html')?.length
    text = email.get('html')
    text = text.replace(/(href=")x-msg:\/\/([^"]+)\//ig, '$1#$2')
    text = text.replace(/[ÀÁÂÃÄÅ]/g, '')
  else
    text = email.get('message')
    unless /^(?:\s*(<[\w\W]+>)[^>]*|#([\w-]*))$/.test text
      text = text.replace(/\n/g, '<br />')

  text = text.replace(/<(a)([^>]+)>/ig,"<$1 target=\"_blank\"  $2>")

  self = this

  Ember.run.next ->
    iFrameContainer = $(iFrameContainerSelector)

    $('#email-body-iframe', iFrameContainer).remove()

    iFrameContainer.append """
      <iframe id="email-body-iframe" src=""></iframe>
    """

    $iFrame = iFrameContainer.children('iframe')
    return unless iFrame = $iFrame.get(0)

    frameWindow = iFrame.contentWindow
    frameDocument = frameWindow.document
    frameDocument.open()
    frameDocument.write text
    frameDocument.close()

    if replies = $iFrame.contents().find('.gmail_quote')
      replies.remove() if replies.length

    iFrame.style.visibility = "hidden"
    iFrame.style.height = "10px"
    iFrame.style.height = $iFrame.contents().height() + "px"
    iFrame.style.visibility = "visible"

    parentController = self.get('parentController')

    Ember.run.next ->
      return unless parentController.on
      parentController.trigger('contentLoaded')

  return ""
