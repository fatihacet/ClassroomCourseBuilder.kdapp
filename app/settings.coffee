settings = 
  
  config:
    """
      config =
      
        validate: (panel, workspace, callback) ->
          # this method will be called to validate chapter
          # you must call callback method with a boolean
          
          callback yes
        
        onSuccess : ->
          # this callback will be called when your user succeed with submitted code.
        
        onFailed  : (error) ->
          # this callback will be called when your user failed with submitted code.
    """
  
  readme: (appName = "Your Awesome Course") ->
    """
      #{appName}
      =====
    """
    
  layouts   :
    single  : """<a class="start-tab-split-option" href="#"><span class="fl w100"></span></a>"""
    double  : """<a class="start-tab-split-option" href="#"><span class="fl w50"></span><span class="fr w50"></span></a>"""
    triple  : """<a class="start-tab-split-option" href="#"><span class="fl w50 full-l"></span><span class="fr w50 h50"></span><span class="fr w50 h50"></span></a>"""
    quad    : """<a class="start-tab-split-option" href="#"><span class="fl w50 h50"></span><span class="fr w50 h50"></span><span class="fl w50 h50"></span><span class="fr w50 h50"></span></a>"""
    
  panelTypeToLayoutConfig:
    single: (paneTypes) ->
      pane               : 
        type             : paneTypes[0]
        
    double: (paneTypes) ->
      direction        : "vertical"
      sizes            : [ "35%", null ]
      views            : [
        { type         : paneTypes[0] }
        { type         : paneTypes[1] }
      ]
      
    triple: (paneTypes) -> 
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
        
    quad: (paneTypes) ->
      direction          : "horizontal"
      sizes              : [ "50%", null ]
      views              : [
        {
          type           : "split"
          options        :
            direction    : "vertical"
            sizes        : [ "50%", null ]
          views          : [
            { type       : paneTypes[0] }
            { type       : paneTypes[1] }
          ]
        }
        {
          type           : "split"
          options        :
            direction    : "vertical"
            sizes        : [ "50%", null ]
          views          : [
            { type       : paneTypes[2] }
            { type       : paneTypes[3] }
          ]
        }
      ]
      
  manifest: (name) ->
    {firstName, lastName, nickname} = KD.whoami().profile
    
    devMode     : true
    version     : "0.1"
    identifier  : "com.koding.courses.#{KD.utils.slugify name}"
    author      : "#{firstName} #{lastName}"
    authorNick  : "#{nickname}"
    icns        : {
      "128"     : "https://koding.com/apple-touch-icon-114x114-precomposed.png"
    }
    screenshots : []
