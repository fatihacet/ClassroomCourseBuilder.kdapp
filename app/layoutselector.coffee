class LayoutSelector extends JView
  
  constructor: (options = {}, data) ->
    
    options.cssClass = "layout-selector"
    
    super options, data

    for layoutKey, markup of settings.layouts
      do (layoutKey) =>
        @[layoutKey] = new KDView
          partial    : markup
          layout     : layoutKey
          click      : => @selectLayout @[layoutKey]
    
  selectLayout: (layout) ->
    @selectedLayout?.unsetClass "selected"
    layout.setClass "selected"
    @selectedLayout = layout
    @createPaneSelector()
    
  createPaneSelector: ->
    @paneSelector?.destroy()
    @addSubView @paneSelector = new PaneSelector
      delegate : this
      layout   : @selectedLayout.getOptions().layout
      
  selectInitialLayout: ->
    @double.getDomElement().trigger "click"
    
  viewAppended : ->
    super 
    @selectInitialLayout()
    
  pistachio: ->
    """
      <div class="layouts-container">
        {{> @single}}
        {{> @double}}
        {{> @triple}}
        {{> @quad}}
      </div>
    """