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
