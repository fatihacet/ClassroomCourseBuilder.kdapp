class PaneSettings extends KDObject

  constructor: (options = {}, data) ->
    
    super options, data
    
    if options.type is "preview"
      fields               =
        defaultUrl         : 
          label            : "Default URL"
          type             : "text"
          name             : "defaultUrl"
          
    else if options.type is "editor"
      fields               =
        editorType         : 
          label            : "Editor Type"
          name             : "type"
          type             : "select"
          defaultValue     : "editor"
          selectOptions    : [
            { title        : "Tabbed Editor", value: "tabbedEditor" }
            { title        : "Editor",        value: "editor" }
          ]
          
    else if options.type is "terminal"
      fields               =
        defaultUrl         : 
          label            : "Initial Command"
          type             : "text"
          name             : "initialCommand"
    
    else if options.type is "finder"
      fields               =
        rootPath           : 
          label            : "Root Path"
          type             : "text"
          name             : "path"
          
    @modal                 = new KDModalViewWithForms
      title                : "#{@getOptions().title} Settings"
      overlay              : yes
      content              : ""
      tabs                 :
        forms              :
          settings         : 
            fields         : fields
            buttons        : 
              save         :
                title      : "Save"
                cssClass   : "modal-clean-green"
                callback   : =>
                  debugger
                  @emit "SettingsFormSubmitted"
              cancel       : 
                title      : "Cancel"
                cssClass   : "modal-cancel"
                callback   : => @modal.destroy()