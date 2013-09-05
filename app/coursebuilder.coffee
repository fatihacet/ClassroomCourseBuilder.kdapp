class CourseBuilder extends JView

  constructor: (options = {}, data) ->
    
    super options, data
    
    @panel          = @getDelegate()
    @workspace      = @panel.getDelegate()
    @generalDetails = new CourseGeneralDetailsForm
    @chapters       = []
      
    @addNewChapterButton()
    
    @workspace.on "CourseSaveRequested", @bound "saveCourse"

  bindChapterWorkspaceEvents: ->
    chapterWorkspace = @addNewChapterWorkspace
    chapterWorkspace.on "ChapterSaveRequested", @bound "saveChapter"
    
    chapterWorkspace.on "ChapterAddingCancelled", (panel) =>
      chapterWorkspace.destroy()
      
      @workspace.setHeight "100", "%"
      
  saveCourse: ->
    nickname          = KD.nick()
    vmController      = KD.getSingleton "vmController"
    generalDetails    = @generalDetails.form.getFormData()
    manifest          = settings.manifest generalDetails.name
    manifest[key]     = value for key, value of generalDetails
    manifest.chapters = []
    jsonFiles         = {}
    jsFiles           = {}
    
    for chapter, index in @chapters
      layoutFileName  = "chapter#{index}-layout.json"
      configFileName  = "chapter#{index}-config.js"
      
      manifest.chapters.push
        title         : chapter.title
        icon          : "https://koding.com/apple-touch-icon-114x114-precomposed.png"
        description   : chapter.readme
        subscription  : "free"
        resourcesPath : "./"
        layoutPath    : "./#{layoutFileName}"
        configPath    : "./#{configFileName}"
      
      jsonFiles[layoutFileName] = settings.panelTypeToLayoutConfig[chapter.layout] chapter.panes
      
    gistFiles         = 
      "manifest.json" : { content: JSON.stringify manifest, null, 2 }
      
    for fileName, content of jsonFiles
      gistFiles[fileName] = { content: JSON.stringify content, null, 2 }
      
    # for fileName, content of jsFiles
        
    jsonGist          = 
      description     : """#{generalDetails.name}, created by #{nickname} using ClassroomCourseBuilder.kdapp"""
      public          : yes
      files           : gistFiles
      
    jsFiles           = 
      description     : """#{generalDetails.name}, created by #{nickname} using ClassroomCourseBuilder.kdapp"""
      public          : yes
      files           : jsFiles
      
    vmController.run "mkdir -p /home/#{nickname}/.classroomcoursebuilder", (err, res) ->
      tmpFile         = "/home/#{nickname}/.classroomcoursebuilder/.gist.tmp"
      tmp             = FSHelper.createFileFromPath tmpFile
      tmp.save JSON.stringify(jsonGist), (err, res) ->
        return warn "error while trying to save gist"  if err
        
        vmController.run "curl -kLs -A\"Koding\" -X POST https://api.github.com/gists --data @#{tmpFile}", (err, res) ->
          return warn err  if err
          vmController.run "rm -rf /home/#{nickname}/.classroomcoursebuilder"
          
          res = JSON.parse res
          log res
          new KDModalView 
            title     : "Your course is ready to import"
            overlay   : yes
            cssClass  : "modal-with-text"
            content   : """
              <p>Your course <strong>manifest.json</strong> has been created and upload to Github as Gist.</p>
              <p>Here is your public URL to manifest.json. You can use and share this URL to import your course to Classroom App.</p>
              <p><strong>#{res.files["manifest.json"].raw_url}</strong></p>
            """
  
  saveChapter: ->
    # TODO: validation, validation, validation...
    panel             = @addNewChapterWorkspace.getActivePanel()
    details           = panel.getPaneByName("chapterDetails").form.getFormData()
    {paneSelector}    = panel.getPaneByName "layoutSelector"
    configCode        = panel.getPaneByName("configEditor").getValue()
    chapterData       = 
      title           : details.name
      layout          : paneSelector.getOptions().layout
      panes           : paneSelector.paneKeys
      readme          : KD.utils.applyMarkdown panel.getPaneByName("markdownEditor").markdownField.getValue()
        
    KD.utils.compileCoffeeOnClient configCode, (compiled) =>
      return warn err if err
      chapterData.config = compiled
      @chapters.push chapterData
      @generalDetails.emit "NewChapterAdded", chapterData
      @addNewChapterWorkspace.emit "ChapterAddingCancelled" # event name is not consist

  addNewChapterButton: ->
    @addNewChapterButton = new KDButtonView
      cssClass           : "cupid-green add-course-button"
      title              : "Add New Chapter"
      callback           : =>
        appView.addSubView @addNewChapterWorkspace = new AddNewChapterWorkspace
        @bindChapterWorkspaceEvents()
        @workspace.setHeight 0
          
    @generalDetails.form.fields.Chapters.addSubView @addNewChapterButton
      
  pistachio: ->
    """
      {{> @generalDetails}}
    """