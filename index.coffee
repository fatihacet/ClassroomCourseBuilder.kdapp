class CourseBuilder extends JView

  constructor: (options = {}, data) ->
    
    super options, data
    
    panel                = @getDelegate()
    workspace            = panel.getDelegate()
    @generalDetails      = new CourseGeneralDetailsForm
    @addNewChapterButton = new KDButtonView
      cssClass           : "cupid-green add-course-button"
      title              : "Add New Chapter"
      callback           : =>
        @generalDetails.setHeight 0
        @generalDetails.on "transitionend", =>
          panel.header.updatePartial """<span class="title">Add New Chapter to Course</span>"""
        
    @generalDetails.form.fields.Chapters.addSubView @addNewChapterButton 
    
    @layoutSelector = new CourseLayoutSelector
    
  pistachio: ->
    """
      {{> @generalDetails}}
      {{> @layoutSelector}}
    """

class CourseChapterList extends KDView
  
  constructor: (options = {}, data) ->
    
    super options, data
    
    @listController = new KDListViewController
      noItemFoundWidget: new KDView
        partial     : "You don't have a chapter yet"
        cssClass    : "no-item"
      view          : new KDListView
        itemClass   : CourseChapterListItem
    ,
      items         : @getData() or []
    @addSubView @listController.getView()
    
class CourseChapterListItem extends KDListItemView

  constructor: (options = {}, data) ->
    
    super options, data
  
  partial: ->
    """ #{@getData()} """

class CourseGeneralDetailsForm extends KDView
  
  constructor: (options = {}, data) ->
    
    options.cssClass   = "general-details-form"
    options.bind       = "transitionend"
    
    super options, data
    
    formOptions         =
      fields            :
        Name            :
          label         : "Course Name"
          name          : "name"
          placeholder   : "Name of your course, eg. Learning CoffeeScript, Advanded JavaScript"
          defaultValue  : "My Awesome Course"
        Description     :
          label         : "Course Description"
          type          : "textarea"
          name          : "description"
          placeholder   : "A few words about your course. This will be displayed on Course Catalog."
          defaultValue  : "This is my fucking awesome course. Move on!"
        ResourcesRoot   :
          label         : "Course Resources URL"
          type          : "text"
          name          : "resourcesRoot"
          placeholder   : "Public URL of your course files"
          defaultValue  : "https://raw.github.com/fatihacet/ClassroomCourses/master/MyAwesomeCourse.kdcourse"
        CourseType      :
          itemClass     : KDSelectBox
          label         : "Course Type"
          type          : "select"
          name          : "type"
          selectOptions : [
            { title     : "Collaborative",     value : "collaborative"     }
            { title     : "Non-collaborative", value : "non-collaborative" }
          ]
        Category        :
          itemClass     : KDSelectBox
          label         : "Course Category"
          type          : "select"
          name          : "category"
          selectOptions : [
            { title     : "Programming Languages"    ,     value : "programming-languages"    }
            { title     : "Computer Science Lessons" ,     value : "computer-science-lessons" }
            { title     : "School Lessons"           ,     value : "school-lessons"           }
            { title     : "How To Course"            ,     value : "how-to"                   }
          ]
        Chapters        :
          itemClass     : CourseChapterList
          label         : "Chapters"

    @addSubView @form = new KDFormViewWithFields formOptions

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
      delegate: @getDelegate()
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
        
    dropArea.addSubView  container = new KDView
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

class ClassroomCourseBuilder extends Workspace

  constructor: (options = {}, data) ->
    
    options.cssClass  = "classroom-course-builder"
    options.name      = "Classroom Course Builder"
    options.panels    = [
      {
        title         : "General Course Details"
        hint          : "<p>Lorem ipsum dolor sit amet</p>"
        pane          : 
          type        : "custom"
          paneClass   : CourseBuilder
      }
    ]
    
    super options, data
    
    @on "GeneralDetailsFormPosted", (panel) =>
      @formData = panel.getPaneByName("generalDetails").form.getFormData()
      @next()
      
    @on "LayoutSelected", (panel) =>
      @layout = panel.getPaneByName("layoutSelector").selectedLayout
      @next()
    
    @on "PanesSelected", (panel) =>
      @selectedPanes = panel.getPaneByName("paneSelector").paneKeys
      @next()
  
  generateCode: ->
    panelType = @layout.getOptions().layout
    @formData.layout = @panelTypeToLayoutConfig[panelType](@selectedPanes).layout
    @createGist (err, res) ->
      new KDModalView 
        title   : "Your course is ready to import"
        overlay : yes
        cssClass: "modal-with-text"
        content : """
          <p>Your course <strong>manifest.json</strong> has been created and upload to Github as Gist.</p>
          <p>Here is your public URL to manifest.json. You can use and share this URL to import your course to Classroom App.</p>
          <p><strong>#{res.files["manifest.json"].raw_url}</strong></p>
        """
    
  createGist: (callback) ->
    nickname = KD.nick()
    gist     = 
      description : """Classroom Course, created by #{nickname} using ClassroomCourseBuilder"""
      public      : yes
      files       :
        "manifest.json": { content: JSON.stringify @formData, null, 2 }

    vmController  = KD.getSingleton 'vmController'
    vmController.run "mkdir -p /home/#{nickname}/.classroomcoursebuilder", (err, res) ->
      
      tmpFile = "/home/#{nickname}/.classroomcoursebuilder/.gist.tmp"
      tmp     = FSHelper.createFileFromPath tmpFile
      tmp.save JSON.stringify(gist), (err, res) ->
        return warn "error while trying to save gist"  if err
        
        vmController.run "curl -kLs -A\"Koding\" -X POST https://api.github.com/gists --data @#{tmpFile}", (err, res) ->
          callback err, JSON.parse res
          vmController.run "rm -f #{tmpFile}"
      
  panelTypeToLayoutConfig:
    triple: (paneTypes) -> 
      layout             : 
        direction        : "vertical"
        sizes            : [ "35%", null ]
        views            : [
          { type         : paneTypes[0] }
          {
            type         : "split"
            options      :
              direction  : "horizontal"
              sizes      : [ "50%", null ]
            views        : [
              { type     : paneTypes[1] }
              { type     : paneTypes[2] }
            ]
          }
        ]
        
class PaneSettings extends KDObject

  constructor: (options = {}, data) ->
    
    super options, data
    
    if options.type is "preview"
      fields               =
        defaultUrl         : 
          label            : "Default URL"
          type             : "text"
          name             : "defaultUrl"
          
    else if options.type is "editor"
      fields               =
        editorType         : 
          label            : "Editor Type"
          name             : "type"
          type             : "select"
          defaultValue     : "editor"
          selectOptions    : [
            { title        : "Tabbed Editor", value: "tabbedEditor" }
            { title        : "Editor",        value: "editor" }
          ]
          
    else if options.type is "terminal"
      fields               =
        defaultUrl         : 
          label            : "Initial Command"
          type             : "text"
          name             : "initialCommand"
    
    else if options.type is "finder"
      fields               =
        rootPath           : 
          label            : "Root Path"
          type             : "text"
          name             : "path"
          
    @modal                 = new KDModalViewWithForms
      title                : "#{@getOptions().title} Settings"
      overlay              : yes
      content              : ""
      tabs                 :
        forms              :
          settings         : 
            fields         : fields
            buttons        : 
              save         :
                title      : "Save"
                cssClass   : "modal-clean-green"
                callback   : =>
                  debugger
                  @emit "SettingsFormSubmitted"
              cancel       : 
                title      : "Cancel"
                cssClass   : "modal-cancel"
                callback   : => @modal.destroy()

appView.addSubView new ClassroomCourseBuilder
