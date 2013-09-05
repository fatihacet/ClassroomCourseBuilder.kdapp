class CourseChapterListItem extends KDListItemView

  constructor: (options = {}, data) ->
    
    options.cssClass = "chapter-list-item"
    
    super options, data
  
  partial: ->
    data = @getData()
    """
      #{settings.layouts[data.layout]}
      <h2>#{data.title}</h2>
    """