class CourseChapterListItem extends KDListItemView

  constructor: (options = {}, data) ->
    
    super options, data
  
  partial: ->
    """ #{@getData()} """