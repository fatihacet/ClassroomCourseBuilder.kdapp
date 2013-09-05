class ChapterDetails extends KDView
  
  constructor: (options = {}, data) ->
    
    options.cssClass   = "general-details-form"
    
    super options, data
    
    formOptions         =
      fields            :
        Name            :
          label         : "Chapter Name"
          name          : "name"
          placeholder   : "Name of your chapter, eg. Introduction to CoffeeScript"
          defaultValue  : "My Awesome Chapter"

    @addSubView @form = new KDFormViewWithFields formOptions