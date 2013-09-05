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