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