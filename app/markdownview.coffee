class MarkdownView extends JView
  
  constructor: (options = {}, data) ->
    
    super options, data
    
    @header       = new KDHeaderView
      cssClass    : "inner-header"
      title       : "README Editor"
      
    @markdownField = new KDInputViewWithPreview
      cssClass     : "readme-editor"
      title        : "README Editor"
      defaultValue : "HELLO\n======="

  pistachio: ->
    """
      {{> @header}}
      {{> @markdownField}}
    """