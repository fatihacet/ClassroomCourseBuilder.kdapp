class AddNewChapterWorkspace extends Workspace
  
  constructor: (options = {}, data) ->
    
    options.cssClass       = "editor-workspace"
    options.panels         = [
      title                : "Adding New Chapter to CoffeeScript Course"
      buttons              : [
        {
          title            : "Save Chapter"
          cssClass         : "cupid-green"
          callback         : => @emit "ChapterSaveRequested"
        }
        {
          title            : "Cancel"
          cssClass         : "clean-gray"
          callback         : => @emit "ChapterAddingCancelled"
        }  
      ]
      layout               : {
        direction          : "horizontal"
        sizes              : [ "330px", null ]
        views              : [
          {
            type           : "split"
            options        :
              direction    : "vertical"
              sizes        : [ "40%", null ]
            views          : [
              {
                type       : "custom"
                name       : "chapterDetails"
                paneClass  : ChapterDetails
              }
              {
                type       : "custom"
                name       : "layoutSelector"
                paneClass  : LayoutSelector
              }
            ]
          }
          {
            type           : "split"
            options        :
              direction    : "vertical"
              sizes        : [ "55%", null ]
            views          : [
              {
                type       : "editor"
                title      : "Config Editor"
                name       : "configEditor"
                content    : settings.config
              }
              {
                type       : "custom"
                name       : "markdownEditor"
                paneClass  : MarkdownView
              }
            ]
          }
        ]
      }
    ]
    
    super options, data
    