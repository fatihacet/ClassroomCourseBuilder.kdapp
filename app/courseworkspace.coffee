class ClassroomCourseWorkspace extends Workspace

  constructor: (options = {}, data) ->
    
    options.cssClass  = "classroom-course-builder"
    options.name      = "Classroom Course Builder"
    options.panels    = [
      {
        title         : "General Course Details"
        hint          : "<p>Lorem ipsum dolor sit amet</p>"
        buttons       : [
          title       : "Save"
          cssClass    : "cupid-green join-button"
          callback    : => @emit "CourseSaveRequested"
        ,
          title       : "Save Chapter"
          cssClass    : "cupid-green hidden"
          callback    : => @emit "ChapterSaveRequested"
        ,
          title       : "Cancel"
          cssClass    : "clean-gray join-button hidden"
          callback    : (panel) => @emit "ChapterAddingCancelled", panel
        ]
        pane          : 
          type        : "custom"
          paneClass   : CourseBuilder
      }
    ]
    
    super options, data
