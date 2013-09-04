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
        @showHideButtons panel, "show", "Add New Chapter to Course"
          
    workspace.on "CourseSaveRequested", => @saveCourse panel, workspace
    
    workspace.on "ChapterSaveRequested", => @saveChapter panel, workspace
    
    workspace.on "ChapterAddingCancelled", (panel) =>
      @generalDetails.setHeight "100", "%"
      @showHideButtons panel, "hide", "General Course Details"
        
    @generalDetails.form.fields.Chapters.addSubView @addNewChapterButton 
    
    @layoutSelector = new CourseLayoutSelector
    
  saveChapter: (panel, workspace) ->
    log panel, workspace
    debugger
    
  showHideButtons: (panel, eventName, title) ->
    @generalDetails.on "transitionend", =>
      
      {header, headerButtons} = panel
      header.getDomElement().find(".title").text title
      reverseEventName = if eventName is "show" then "hide" else "show"
      headerButtons.Save[reverseEventName]()
      headerButtons.Cancel[eventName]()
      headerButtons["Save Chapter"][eventName]()
      
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

    
  pistachio: ->
    """
      {{> @generalDetails}}
      {{> @layoutSelector}}
    """