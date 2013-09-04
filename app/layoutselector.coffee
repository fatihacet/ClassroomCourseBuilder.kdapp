class CourseLayoutSelector extends JView
  
  constructor: (options = {}, data) ->
    
    options.cssClass = "layout-selector"
    
    super options, data
    
    layouts   = 
      single  : """<a class="start-tab-split-option" href="#"><span class="fl w100"></span></a>"""
      double  : """<a class="start-tab-split-option" href="#"><span class="fl w50"></span><span class="fr w50"></span></a>"""
      triple  : """<a class="start-tab-split-option" href="#"><span class="fl w50 full-l"></span><span class="fr w50 h50"></span><span class="fr w50 h50"></span></a>"""
      quad    : """<a class="start-tab-split-option" href="#"><span class="fl w50 h50"></span><span class="fr w50 h50"></span><span class="fl w50 h50"></span><span class="fr w50 h50"></span></a>"""
      
    for layoutKey, markup of layouts
      do (layoutKey) =>
        @[layoutKey] = new KDView
          partial    : markup
          layout     : layoutKey
          click      : => @selectLayout @[layoutKey]
    
  selectLayout: (layout) ->
    @selectedLayout?.unsetClass "selected"
    layout.setClass "selected"
    @selectedLayout = layout
    
    @paneSelector?.destroy()
    @addSubView @paneSelector = new CoursePaneSelector 
      delegate: @
      layout  : layout.getOptions().layout
    
  pistachio: ->
    """
      <div class="layouts-container">
        {{> @single}}
        {{> @double}}
        {{> @triple}}
        {{> @quad}}
      </div>
    """