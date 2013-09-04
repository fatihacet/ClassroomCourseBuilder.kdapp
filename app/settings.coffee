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