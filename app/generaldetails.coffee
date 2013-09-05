class CourseGeneralDetailsForm extends KDView
  
  constructor: (options = {}, data) ->
    
    options.cssClass   = "general-details-form"
    
    super options, data
    
    formOptions         =
      fields            :
        Name            :
          label         : "Course Name"
          name          : "name"
          placeholder   : "Name of your course, eg. Learning CoffeeScript, Advanded JavaScript"
          defaultValue  : "My Awesome Course"
        Description     :
          label         : "Course Description"
          type          : "textarea"
          name          : "description"
          placeholder   : "A few words about your course. This will be displayed on Course Catalog."
          defaultValue  : "This is my fucking awesome course. Move on!"
        ResourcesRoot   :
          label         : "Course Resources URL"
          type          : "text"
          name          : "resourcesRoot"
          placeholder   : "Public URL of your course files"
          defaultValue  : "https://raw.github.com/fatihacet/ClassroomCourses/master/MyAwesomeCourse.kdcourse"
        CourseType      :
          itemClass     : KDSelectBox
          label         : "Course Type"
          type          : "select"
          name          : "type"
          selectOptions : [
            { title     : "Collaborative",     value : "collaborative"     }
            { title     : "Non-collaborative", value : "non-collaborative" }
          ]
        Category        :
          itemClass     : KDSelectBox
          label         : "Course Category"
          type          : "select"
          name          : "category"
          selectOptions : [
            { title     : "Programming Languages"    ,     value : "programming-languages"    }
            { title     : "Computer Science Lessons" ,     value : "computer-science-lessons" }
            { title     : "School Lessons"           ,     value : "school-lessons"           }
            { title     : "How To Course"            ,     value : "how-to"                   }
          ]
        Chapters        :
          label         : "Chapters"
          itemClass     : CourseChapterList

    @addSubView @form = new KDFormViewWithFields formOptions
    
    @on "NewChapterAdded", (chapterData) =>
      @form.inputs.Chapters.listController.addItem chapterData
