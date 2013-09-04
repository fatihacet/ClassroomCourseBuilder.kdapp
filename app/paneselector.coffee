class CoursePaneSelector extends JView
  
  constructor: (options = {}, data) ->
    
    options.cssClass = "pane-selector"
    
    super options, data
    
    panel        = @getDelegate()
    builder      = panel.getDelegate()
    cssClasses   = @layoutToCssClasses[@getOptions().layout]
    @dropAreas   = []
    @paneKeys    = []
    @layout      = new KDCustomHTMLView
      tagName    : "a"
      cssClass   : "start-tab-split-option"
      attributes : 
        href     : "#"
        
    cssClasses.forEach (cssClass) =>
      dropArea   = new KDCustomHTMLView
        tagName  : "span"
        cssClass : cssClass
        bind     : "drop dragenter dragleave dragend dragover dragstart mousemove"
        
      @layout.addSubView dropArea
      @dropAreas.push dropArea
      
      dropArea.on "drop", (e) => @handleDrop dropArea
        
    @paneItems   = new KDCustomHTMLView
      cssClass   : "pane-items-container"
    
    for key, value of @paneTypes
      do =>
        @paneItems.addSubView item = new KDCustomHTMLView
          tagName     : "div"
          partial     : value
          paneKey     : key
          paneTitle   : value
          bind        : "dragstart dragend"
          attributes  :
            draggable : yes
            
        item.on "dragstart", => @emit "ItemIsDragging", item
        
        item.on "dragend",   => @emit "ItemDragIsDone", item
      
    @on "ItemIsDragging", (item) =>
      @draggingItem = item
      @layout.setClass "highlight"
      
    @on "ItemDragIsDone", (item) =>
      @layout.unsetClass "highlight"
      @draggingItem = null
      
  handleDrop: (dropArea) -> 
    {paneTitle, paneKey} = @draggingItem.getOptions()
    
    dropArea.destroySubViews()    
    dropArea.addSubView container = new KDView
      cssClass: "pane-type"
      
    container.addSubView title = new KDCustomHTMLView
      tagName  : "p"
      partial  : paneTitle
      
    title.addSubView cog = new KDCustomHTMLView
      cssClass : "icon cog"
      click    : => 
        settingsView = new PaneSettings
          type   : paneKey
          title  : paneTitle
          index  : index
        settingsView.on "SettingsFormSubmitted", ->
  
    index = @dropAreas.indexOf dropArea
    @paneKeys[index] = paneKey
        
  paneTypes    : 
    terminal   : "Terminal"
    finder     : "Filetree"
    editor     : "Editor"
    preview    : "Preview"
    
  layoutToCssClasses:
    single     : [ "fl w100" ]
    double     : [ "fl w50", "fr w50" ]
    triple     : [ "fl w50 full-l", "fr w50 h50", "fr w50 h50" ]
    quad       : [ "fl w50 h50", "fr w50 h50", "fl w50 h50", "fr w50 h50" ]
  
  pistachio: ->
    """
      {{> @layout}}
      {{> @paneItems}}
    """