class CourseGeneralDetailsForm extends KDView
  
  constructor: (options = {}, data) ->
    
    options.cssClass = "general-details-form"
    
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

    @addSubView @form = new KDFormViewWithFields formOptions

class CourseLayoutSelector extends JView
  
  constructor: (options = {}, data) ->
    
    options.cssClass = "layout-selector"
    
    super options, data
    
    @single   = new KDView
      partial : '<a class="start-tab-split-option" href="#"><span class="fl w100"></span></a>'
      layout  : "single"
      click   : => @selectLayout @single
      
    @double   = new KDView
      partial : '<a class="start-tab-split-option" href="#"><span class="fl w50"></span><span class="fr w50"></span></a>'
      layout  : "double"
      click   : => @selectLayout @double
      
    @triple   = new KDView
      partial : '<a class="start-tab-split-option" href="#"><span class="fl w50 full-l"></span><span class="fr w50 h50"></span><span class="fr w50 h50"></span></a>'
      layout  : "triple"
      click   : => @selectLayout @triple
      
    @quad     = new KDView
      partial : '<a class="start-tab-split-option" href="#"><span class="fl w50 h50"></span><span class="fr w50 h50"></span><span class="fl w50 h50"></span><span class="fr w50 h50"></span></a>'
      layout  : "quad"
      click   : => @selectLayout @quad
  
  selectLayout: (layout) ->
    @selectedLayout?.unsetClass "selected"
    layout.setClass "selected"
    @selectedLayout = layout
    
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
    cssClasses   = @layoutToCssClasses[builder.layout.getOptions().layout]
    @layout      = new KDCustomHTMLView
      tagName    : "a"
      cssClass   : "start-tab-split-option"
      attributes : 
        href     : "#"
        
    cssClasses.forEach (cssClass) =>
      dropArea = new KDCustomHTMLView
        tagName  : "span"
        cssClass : cssClass
        bind     : "drop dragenter dragleave dragend dragover dragstart mousemove"
        
      @layout.addSubView dropArea
      dropArea.on "drop", (e) => dropArea.updatePartial "<p>#{@draggingItem.getOptions().paneTitle}</p>"
        
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
        
  paneTypes: 
    "terminal"     : "Terminal"
    "finder"       : "Filetree"
    "editor"       : "Editor"
    "tabbedEditor" : "Tabbed Editor"
    "preview"      : "Preview"
    
  layoutToCssClasses:
    single : [ "fl w100" ]
    double : [ "fl w50", "fr w50" ]
    triple : [ "fl w50 full-l", "fr w50 h50", "fr w50 h50" ]
    quad   : [ "fl w50 h50", "fr w50 h50", "fl w50 h50", "fr w50 h50" ]
    
  pistachio: ->
    """
      {{> @layout}}
      {{> @paneItems}}
    """

class ClassroomCourseBuilder extends Workspace

  constructor: (options = {}, data) ->
    
    options.name      = "Classroom Course Builder"
    options.panels    = [
      {
        title         : "Step 1 - General Course Details"
        hint          : "<p>Lorem ipsum dolor sit amet</p>"
        buttons       : [
          {
            title     : "Next"
            cssClass  : "cupid-green join-button"
            callback  : => @emit "GeneralDetailsFormPosted"
          }
        ]
        pane          : 
          type        : "custom"
          name        : "generalDetails"
          paneClass   : CourseGeneralDetailsForm
      }
      {
        title         : "Step 2 - Choose Your Layout"
        hint          : "<p>Lorem ipsum dolor sit amet</p>"
        buttons       : [
          {
            title     : "Next"
            cssClass  : "cupid-green join-button"
            callback  : => @emit "LayoutSelected"
          }
        ]
        pane          : 
          type        : "custom"
          name        : "layoutSelector"
          paneClass   : CourseLayoutSelector
      }
      {
        title         : "Step 3 - Assign Your Panes"
        hint          : "<p>Lorem ipsum dolor sit amet</p>"
        buttons       : [
          {
            title     : "Next"
            cssClass  : "cupid-green join-button"
            callback  : => @emit "PanesSelected"
          }
        ]
        pane          : 
          type        : "custom"
          name        : "paneSelector"
          paneClass   : CoursePaneSelector
      }
    ]
    
    super options, data
    
    @on "GeneralDetailsFormPosted", =>
      @formData = @getActivePanel().getPaneByName("generalDetails").form.getFormData()
      @next()
      
    @on "LayoutSelected", =>
      @layout = @getActivePanel().getPaneByName("layoutSelector").selectedLayout
      @next()

appView.addSubView new ClassroomCourseBuilder
