/* Compiled by kdc on Thu Sep 05 2013 15:49:55 GMT+0000 (UTC) */
(function() {
/* KDAPP STARTS */
/* BLOCK STARTS: /home/alexdesouza/Applications/ClassroomCourseBuilder.kdapp/app/settings.coffee */
var settings;

settings = {
  config: "config =\n\n  validate: (panel, workspace, callback) ->\n    # this method will be called to validate chapter\n    # you must call callback method with a boolean\n    \n    callback yes\n  \n  onSuccess : ->\n    # this callback will be called when your user succeed with submitted code.\n  \n  onFailed  : (error) ->\n    # this callback will be called when your user failed with submitted code.",
  readme: function(appName) {
    if (appName == null) {
      appName = "Your Awesome Course";
    }
    return "" + appName + "\n=====";
  },
  layouts: {
    single: "<a class=\"start-tab-split-option\" href=\"#\"><span class=\"fl w100\"></span></a>",
    double: "<a class=\"start-tab-split-option\" href=\"#\"><span class=\"fl w50\"></span><span class=\"fr w50\"></span></a>",
    triple: "<a class=\"start-tab-split-option\" href=\"#\"><span class=\"fl w50 full-l\"></span><span class=\"fr w50 h50\"></span><span class=\"fr w50 h50\"></span></a>",
    quad: "<a class=\"start-tab-split-option\" href=\"#\"><span class=\"fl w50 h50\"></span><span class=\"fr w50 h50\"></span><span class=\"fl w50 h50\"></span><span class=\"fr w50 h50\"></span></a>"
  },
  panelTypeToLayoutConfig: {
    single: function(paneTypes) {
      return {
        pane: {
          type: paneTypes[0]
        }
      };
    },
    double: function(paneTypes) {
      return {
        direction: "vertical",
        sizes: ["35%", null],
        views: [
          {
            type: paneTypes[0]
          }, {
            type: paneTypes[1]
          }
        ]
      };
    },
    triple: function(paneTypes) {
      return {
        direction: "vertical",
        sizes: ["35%", null],
        views: [
          {
            type: paneTypes[0]
          }, {
            type: "split",
            options: {
              direction: "horizontal",
              sizes: ["50%", null]
            },
            views: [
              {
                type: paneTypes[1]
              }, {
                type: paneTypes[2]
              }
            ]
          }
        ]
      };
    },
    quad: function(paneTypes) {
      return {
        direction: "horizontal",
        sizes: ["50%", null],
        views: [
          {
            type: "split",
            options: {
              direction: "vertical",
              sizes: ["50%", null]
            },
            views: [
              {
                type: paneTypes[0]
              }, {
                type: paneTypes[1]
              }
            ]
          }, {
            type: "split",
            options: {
              direction: "vertical",
              sizes: ["50%", null]
            },
            views: [
              {
                type: paneTypes[2]
              }, {
                type: paneTypes[3]
              }
            ]
          }
        ]
      };
    }
  },
  manifest: function(name) {
    var firstName, lastName, nickname, _ref;
    _ref = KD.whoami().profile, firstName = _ref.firstName, lastName = _ref.lastName, nickname = _ref.nickname;
    return {
      devMode: true,
      version: "0.1",
      identifier: "com.koding.courses." + (KD.utils.slugify(name)),
      author: "" + firstName + " " + lastName,
      authorNick: "" + nickname,
      icns: {
        "128": "https://koding.com/apple-touch-icon-114x114-precomposed.png"
      },
      screenshots: []
    };
  }
};
/* BLOCK STARTS: /home/alexdesouza/Applications/ClassroomCourseBuilder.kdapp/app/panesettings.coffee */
var PaneSettings,
  __hasProp = {}.hasOwnProperty,
  __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

PaneSettings = (function(_super) {
  __extends(PaneSettings, _super);

  function PaneSettings(options, data) {
    var fields,
      _this = this;
    if (options == null) {
      options = {};
    }
    PaneSettings.__super__.constructor.call(this, options, data);
    if (options.type === "preview") {
      fields = {
        defaultUrl: {
          label: "Default URL",
          type: "text",
          name: "defaultUrl"
        }
      };
    } else if (options.type === "editor") {
      fields = {
        editorType: {
          label: "Editor Type",
          name: "type",
          type: "select",
          defaultValue: "editor",
          selectOptions: [
            {
              title: "Tabbed Editor",
              value: "tabbedEditor"
            }, {
              title: "Editor",
              value: "editor"
            }
          ]
        }
      };
    } else if (options.type === "terminal") {
      fields = {
        defaultUrl: {
          label: "Initial Command",
          type: "text",
          name: "initialCommand"
        }
      };
    } else if (options.type === "finder") {
      fields = {
        rootPath: {
          label: "Root Path",
          type: "text",
          name: "path"
        }
      };
    }
    this.modal = new KDModalViewWithForms({
      title: "" + (this.getOptions().title) + " Settings",
      overlay: true,
      content: "",
      tabs: {
        forms: {
          settings: {
            fields: fields,
            buttons: {
              save: {
                title: "Save",
                cssClass: "modal-clean-green",
                callback: function() {
                  debugger;
                  return _this.emit("SettingsFormSubmitted");
                }
              },
              cancel: {
                title: "Cancel",
                cssClass: "modal-cancel",
                callback: function() {
                  return _this.modal.destroy();
                }
              }
            }
          }
        }
      }
    });
  }

  return PaneSettings;

})(KDObject);
/* BLOCK STARTS: /home/alexdesouza/Applications/ClassroomCourseBuilder.kdapp/app/layoutselector.coffee */
var LayoutSelector,
  __hasProp = {}.hasOwnProperty,
  __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

LayoutSelector = (function(_super) {
  __extends(LayoutSelector, _super);

  function LayoutSelector(options, data) {
    var layoutKey, markup, _fn, _ref,
      _this = this;
    if (options == null) {
      options = {};
    }
    options.cssClass = "layout-selector";
    LayoutSelector.__super__.constructor.call(this, options, data);
    _ref = settings.layouts;
    _fn = function(layoutKey) {
      return _this[layoutKey] = new KDView({
        partial: markup,
        layout: layoutKey,
        click: function() {
          return _this.selectLayout(_this[layoutKey]);
        }
      });
    };
    for (layoutKey in _ref) {
      markup = _ref[layoutKey];
      _fn(layoutKey);
    }
  }

  LayoutSelector.prototype.selectLayout = function(layout) {
    var _ref;
    if ((_ref = this.selectedLayout) != null) {
      _ref.unsetClass("selected");
    }
    layout.setClass("selected");
    this.selectedLayout = layout;
    return this.createPaneSelector();
  };

  LayoutSelector.prototype.createPaneSelector = function() {
    var _ref;
    if ((_ref = this.paneSelector) != null) {
      _ref.destroy();
    }
    return this.addSubView(this.paneSelector = new PaneSelector({
      delegate: this,
      layout: this.selectedLayout.getOptions().layout
    }));
  };

  LayoutSelector.prototype.selectInitialLayout = function() {
    return this.double.getDomElement().trigger("click");
  };

  LayoutSelector.prototype.viewAppended = function() {
    LayoutSelector.__super__.viewAppended.apply(this, arguments);
    return this.selectInitialLayout();
  };

  LayoutSelector.prototype.pistachio = function() {
    return "<div class=\"layouts-container\">\n  {{> this.single}}\n  {{> this.double}}\n  {{> this.triple}}\n  {{> this.quad}}\n</div>";
  };

  return LayoutSelector;

})(JView);
/* BLOCK STARTS: /home/alexdesouza/Applications/ClassroomCourseBuilder.kdapp/app/paneselector.coffee */
var PaneSelector,
  __hasProp = {}.hasOwnProperty,
  __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

PaneSelector = (function(_super) {
  __extends(PaneSelector, _super);

  function PaneSelector(options, data) {
    var builder, cssClasses, key, panel, value, _fn, _ref,
      _this = this;
    if (options == null) {
      options = {};
    }
    options.cssClass = "pane-selector";
    PaneSelector.__super__.constructor.call(this, options, data);
    panel = this.getDelegate();
    builder = panel.getDelegate();
    cssClasses = this.layoutToCssClasses[this.getOptions().layout];
    this.dropAreas = [];
    this.paneKeys = [];
    this.layout = new KDCustomHTMLView({
      tagName: "a",
      cssClass: "start-tab-split-option",
      attributes: {
        href: "#"
      }
    });
    cssClasses.forEach(function(cssClass) {
      var dropArea;
      dropArea = new KDCustomHTMLView({
        tagName: "span",
        cssClass: cssClass,
        bind: "drop dragenter dragleave dragend dragover dragstart mousemove"
      });
      _this.layout.addSubView(dropArea);
      _this.dropAreas.push(dropArea);
      return dropArea.on("drop", function(e) {
        return _this.handleDrop(dropArea);
      });
    });
    this.paneItems = new KDCustomHTMLView({
      cssClass: "pane-items-container"
    });
    _ref = this.paneTypes;
    _fn = function() {
      var item;
      _this.paneItems.addSubView(item = new KDCustomHTMLView({
        tagName: "div",
        partial: value,
        paneKey: key,
        paneTitle: value,
        bind: "dragstart dragend",
        attributes: {
          draggable: true
        }
      }));
      item.on("dragstart", function() {
        return _this.emit("ItemIsDragging", item);
      });
      return item.on("dragend", function() {
        return _this.emit("ItemDragIsDone", item);
      });
    };
    for (key in _ref) {
      value = _ref[key];
      _fn();
    }
    this.on("ItemIsDragging", function(item) {
      _this.draggingItem = item;
      return _this.layout.setClass("highlight");
    });
    this.on("ItemDragIsDone", function(item) {
      _this.layout.unsetClass("highlight");
      return _this.draggingItem = null;
    });
  }

  PaneSelector.prototype.handleDrop = function(dropArea) {
    var cog, container, index, paneKey, paneTitle, title, _ref,
      _this = this;
    _ref = this.draggingItem.getOptions(), paneTitle = _ref.paneTitle, paneKey = _ref.paneKey;
    dropArea.destroySubViews();
    dropArea.addSubView(container = new KDView({
      cssClass: "pane-type"
    }));
    container.addSubView(title = new KDCustomHTMLView({
      tagName: "p",
      partial: paneTitle
    }));
    title.addSubView(cog = new KDCustomHTMLView({
      cssClass: "icon cog",
      click: function() {
        var settingsView;
        settingsView = new PaneSettings({
          type: paneKey,
          title: paneTitle,
          index: index
        });
        return settingsView.on("SettingsFormSubmitted", function() {});
      }
    }));
    index = this.dropAreas.indexOf(dropArea);
    return this.paneKeys[index] = paneKey;
  };

  PaneSelector.prototype.paneTypes = {
    terminal: "Terminal",
    finder: "Filetree",
    editor: "Editor",
    preview: "Preview"
  };

  PaneSelector.prototype.layoutToCssClasses = {
    single: ["fl w100"],
    double: ["fl w50", "fr w50"],
    triple: ["fl w50 full-l", "fr w50 h50", "fr w50 h50"],
    quad: ["fl w50 h50", "fr w50 h50", "fl w50 h50", "fr w50 h50"]
  };

  PaneSelector.prototype.pistachio = function() {
    return "{{> this.layout}}\n{{> this.paneItems}}";
  };

  return PaneSelector;

})(JView);
/* BLOCK STARTS: /home/alexdesouza/Applications/ClassroomCourseBuilder.kdapp/app/markdownview.coffee */
var MarkdownView,
  __hasProp = {}.hasOwnProperty,
  __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

MarkdownView = (function(_super) {
  __extends(MarkdownView, _super);

  function MarkdownView(options, data) {
    if (options == null) {
      options = {};
    }
    MarkdownView.__super__.constructor.call(this, options, data);
    this.header = new KDHeaderView({
      cssClass: "inner-header",
      title: "README Editor"
    });
    this.markdownField = new KDInputViewWithPreview({
      cssClass: "readme-editor",
      title: "README Editor",
      defaultValue: "HELLO\n======="
    });
  }

  MarkdownView.prototype.pistachio = function() {
    return "{{> this.header}}\n{{> this.markdownField}}";
  };

  return MarkdownView;

})(JView);
/* BLOCK STARTS: /home/alexdesouza/Applications/ClassroomCourseBuilder.kdapp/app/chapterlistitem.coffee */
var CourseChapterListItem,
  __hasProp = {}.hasOwnProperty,
  __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

CourseChapterListItem = (function(_super) {
  __extends(CourseChapterListItem, _super);

  function CourseChapterListItem(options, data) {
    if (options == null) {
      options = {};
    }
    options.cssClass = "chapter-list-item";
    CourseChapterListItem.__super__.constructor.call(this, options, data);
  }

  CourseChapterListItem.prototype.partial = function() {
    var data;
    data = this.getData();
    return "" + settings.layouts[data.layout] + "\n<h2>" + data.title + "</h2>";
  };

  return CourseChapterListItem;

})(KDListItemView);
/* BLOCK STARTS: /home/alexdesouza/Applications/ClassroomCourseBuilder.kdapp/app/chapterlist.coffee */
var CourseChapterList,
  __hasProp = {}.hasOwnProperty,
  __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

CourseChapterList = (function(_super) {
  __extends(CourseChapterList, _super);

  function CourseChapterList(options, data) {
    if (options == null) {
      options = {};
    }
    CourseChapterList.__super__.constructor.call(this, options, data);
    this.listController = new KDListViewController({
      noItemFoundWidget: new KDView({
        partial: "You don't have a chapter yet",
        cssClass: "no-item"
      }),
      view: new KDListView({
        itemClass: CourseChapterListItem
      })
    }, {
      items: this.getData() || []
    });
    this.addSubView(this.listController.getView());
  }

  return CourseChapterList;

})(KDView);
/* BLOCK STARTS: /home/alexdesouza/Applications/ClassroomCourseBuilder.kdapp/app/generaldetails.coffee */
var CourseGeneralDetailsForm,
  __hasProp = {}.hasOwnProperty,
  __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

CourseGeneralDetailsForm = (function(_super) {
  __extends(CourseGeneralDetailsForm, _super);

  function CourseGeneralDetailsForm(options, data) {
    var formOptions,
      _this = this;
    if (options == null) {
      options = {};
    }
    options.cssClass = "general-details-form";
    CourseGeneralDetailsForm.__super__.constructor.call(this, options, data);
    formOptions = {
      fields: {
        Name: {
          label: "Course Name",
          name: "name",
          placeholder: "Name of your course, eg. Learning CoffeeScript, Advanded JavaScript",
          defaultValue: "My Awesome Course"
        },
        Description: {
          label: "Course Description",
          type: "textarea",
          name: "description",
          placeholder: "A few words about your course. This will be displayed on Course Catalog.",
          defaultValue: "This is my fucking awesome course. Move on!"
        },
        ResourcesRoot: {
          label: "Course Resources URL",
          type: "text",
          name: "resourcesRoot",
          placeholder: "Public URL of your course files",
          defaultValue: "https://raw.github.com/fatihacet/ClassroomCourses/master/MyAwesomeCourse.kdcourse"
        },
        CourseType: {
          itemClass: KDSelectBox,
          label: "Course Type",
          type: "select",
          name: "type",
          selectOptions: [
            {
              title: "Collaborative",
              value: "collaborative"
            }, {
              title: "Non-collaborative",
              value: "non-collaborative"
            }
          ]
        },
        Category: {
          itemClass: KDSelectBox,
          label: "Course Category",
          type: "select",
          name: "category",
          selectOptions: [
            {
              title: "Programming Languages",
              value: "programming-languages"
            }, {
              title: "Computer Science Lessons",
              value: "computer-science-lessons"
            }, {
              title: "School Lessons",
              value: "school-lessons"
            }, {
              title: "How To Course",
              value: "how-to"
            }
          ]
        },
        Chapters: {
          label: "Chapters",
          itemClass: CourseChapterList
        }
      }
    };
    this.addSubView(this.form = new KDFormViewWithFields(formOptions));
    this.on("NewChapterAdded", function(chapterData) {
      return _this.form.inputs.Chapters.listController.addItem(chapterData);
    });
  }

  return CourseGeneralDetailsForm;

})(KDView);
/* BLOCK STARTS: /home/alexdesouza/Applications/ClassroomCourseBuilder.kdapp/app/chapterdetails.coffee */
var ChapterDetails,
  __hasProp = {}.hasOwnProperty,
  __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

ChapterDetails = (function(_super) {
  __extends(ChapterDetails, _super);

  function ChapterDetails(options, data) {
    var formOptions;
    if (options == null) {
      options = {};
    }
    options.cssClass = "general-details-form";
    ChapterDetails.__super__.constructor.call(this, options, data);
    formOptions = {
      fields: {
        Name: {
          label: "Chapter Name",
          name: "name",
          placeholder: "Name of your chapter, eg. Introduction to CoffeeScript",
          defaultValue: "My Awesome Chapter"
        }
      }
    };
    this.addSubView(this.form = new KDFormViewWithFields(formOptions));
  }

  return ChapterDetails;

})(KDView);
/* BLOCK STARTS: /home/alexdesouza/Applications/ClassroomCourseBuilder.kdapp/app/addnewchapterworkspace.coffee */
var AddNewChapterWorkspace,
  __hasProp = {}.hasOwnProperty,
  __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

AddNewChapterWorkspace = (function(_super) {
  __extends(AddNewChapterWorkspace, _super);

  function AddNewChapterWorkspace(options, data) {
    var _this = this;
    if (options == null) {
      options = {};
    }
    options.cssClass = "editor-workspace";
    options.panels = [
      {
        title: "Adding New Chapter to CoffeeScript Course",
        buttons: [
          {
            title: "Save Chapter",
            cssClass: "cupid-green",
            callback: function() {
              return _this.emit("ChapterSaveRequested");
            }
          }, {
            title: "Cancel",
            cssClass: "clean-gray",
            callback: function() {
              return _this.emit("ChapterAddingCancelled");
            }
          }
        ],
        layout: {
          direction: "horizontal",
          sizes: ["330px", null],
          views: [
            {
              type: "split",
              options: {
                direction: "vertical",
                sizes: ["40%", null]
              },
              views: [
                {
                  type: "custom",
                  name: "chapterDetails",
                  paneClass: ChapterDetails
                }, {
                  type: "custom",
                  name: "layoutSelector",
                  paneClass: LayoutSelector
                }
              ]
            }, {
              type: "split",
              options: {
                direction: "vertical",
                sizes: ["55%", null]
              },
              views: [
                {
                  type: "editor",
                  title: "Config Editor",
                  name: "configEditor",
                  content: settings.config
                }, {
                  type: "custom",
                  name: "markdownEditor",
                  paneClass: MarkdownView
                }
              ]
            }
          ]
        }
      }
    ];
    AddNewChapterWorkspace.__super__.constructor.call(this, options, data);
  }

  return AddNewChapterWorkspace;

})(Workspace);
/* BLOCK STARTS: /home/alexdesouza/Applications/ClassroomCourseBuilder.kdapp/app/coursebuilder.coffee */
var CourseBuilder,
  __hasProp = {}.hasOwnProperty,
  __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

CourseBuilder = (function(_super) {
  __extends(CourseBuilder, _super);

  function CourseBuilder(options, data) {
    if (options == null) {
      options = {};
    }
    CourseBuilder.__super__.constructor.call(this, options, data);
    this.panel = this.getDelegate();
    this.workspace = this.panel.getDelegate();
    this.generalDetails = new CourseGeneralDetailsForm;
    this.chapters = [];
    this.addNewChapterButton();
    this.workspace.on("CourseSaveRequested", this.bound("saveCourse"));
  }

  CourseBuilder.prototype.bindChapterWorkspaceEvents = function() {
    var chapterWorkspace,
      _this = this;
    chapterWorkspace = this.addNewChapterWorkspace;
    chapterWorkspace.on("ChapterSaveRequested", this.bound("saveChapter"));
    return chapterWorkspace.on("ChapterAddingCancelled", function(panel) {
      chapterWorkspace.destroy();
      return _this.workspace.setHeight("100", "%");
    });
  };

  CourseBuilder.prototype.saveCourse = function() {
    var chapter, configFiles, content, fileName, generalDetails, gistFiles, index, jsonGist, key, layoutFileName, manifest, nickname, value, vmController, _i, _len, _ref;
    nickname = KD.nick();
    vmController = KD.getSingleton("vmController");
    generalDetails = this.generalDetails.form.getFormData();
    manifest = settings.manifest(generalDetails.name);
    for (key in generalDetails) {
      value = generalDetails[key];
      manifest[key] = value;
    }
    manifest.chapters = [];
    configFiles = {};
    _ref = this.chapters;
    for (index = _i = 0, _len = _ref.length; _i < _len; index = ++_i) {
      chapter = _ref[index];
      layoutFileName = "chapter" + index + "-layout.js";
      manifest.chapters.push({
        title: chapter.title,
        icon: "https://koding.com/apple-touch-icon-114x114-precomposed.png",
        description: chapter.readme,
        subscription: "free",
        resourcesPath: "./" + layoutFileName,
        layoutPath: ""
      });
      configFiles[layoutFileName] = settings.panelTypeToLayoutConfig[chapter.layout](chapter.panes);
    }
    gistFiles = {
      "manifest.json": {
        content: JSON.stringify(manifest, null, 2)
      }
    };
    for (fileName in configFiles) {
      content = configFiles[fileName];
      gistFiles[fileName] = {
        content: JSON.stringify(content, null, 2)
      };
    }
    jsonGist = {
      description: "" + generalDetails.name + ", created by " + nickname + " using ClassroomCourseBuilder.kdapp",
      "public": true,
      files: gistFiles
    };
    return vmController.run("mkdir -p /home/" + nickname + "/.classroomcoursebuilder", function(err, res) {
      var tmp, tmpFile;
      tmpFile = "/home/" + nickname + "/.classroomcoursebuilder/.gist.tmp";
      tmp = FSHelper.createFileFromPath(tmpFile);
      return tmp.save(JSON.stringify(jsonGist), function(err, res) {
        if (err) {
          return warn("error while trying to save gist");
        }
        return vmController.run("curl -kLs -A\"Koding\" -X POST https://api.github.com/gists --data @" + tmpFile, function(err, res) {
          if (err) {
            return warn(err);
          }
          vmController.run("rm -rf /home/" + nickname + "/.classroomcoursebuilder");
          res = JSON.parse(res);
          log(res);
          return new KDModalView({
            title: "Your course is ready to import",
            overlay: true,
            cssClass: "modal-with-text",
            content: "<p>Your course <strong>manifest.json</strong> has been created and upload to Github as Gist.</p>\n<p>Here is your public URL to manifest.json. You can use and share this URL to import your course to Classroom App.</p>\n<p><strong>" + res.files["manifest.json"].raw_url + "</strong></p>"
          });
        });
      });
    });
  };

  CourseBuilder.prototype.saveChapter = function() {
    var chapterData, configCode, details, paneSelector, panel,
      _this = this;
    panel = this.addNewChapterWorkspace.getActivePanel();
    details = panel.getPaneByName("chapterDetails").form.getFormData();
    paneSelector = panel.getPaneByName("layoutSelector").paneSelector;
    configCode = panel.getPaneByName("configEditor").getValue();
    chapterData = {
      title: details.name,
      layout: paneSelector.getOptions().layout,
      panes: paneSelector.paneKeys,
      readme: KD.utils.applyMarkdown(panel.getPaneByName("markdownEditor").markdownField.getValue())
    };
    return KD.utils.compileCoffeeOnClient(configCode, function(compiled) {
      if (err) {
        return warn(err);
      }
      chapterData.config = compiled;
      _this.chapters.push(chapterData);
      _this.generalDetails.emit("NewChapterAdded", chapterData);
      return _this.addNewChapterWorkspace.emit("ChapterAddingCancelled");
    });
  };

  CourseBuilder.prototype.addNewChapterButton = function() {
    var _this = this;
    this.addNewChapterButton = new KDButtonView({
      cssClass: "cupid-green add-course-button",
      title: "Add New Chapter",
      callback: function() {
        appView.addSubView(_this.addNewChapterWorkspace = new AddNewChapterWorkspace);
        _this.bindChapterWorkspaceEvents();
        return _this.workspace.setHeight(0);
      }
    });
    return this.generalDetails.form.fields.Chapters.addSubView(this.addNewChapterButton);
  };

  CourseBuilder.prototype.pistachio = function() {
    return "{{> this.generalDetails}}";
  };

  return CourseBuilder;

})(JView);
/* BLOCK STARTS: /home/alexdesouza/Applications/ClassroomCourseBuilder.kdapp/app/courseworkspace.coffee */
var ClassroomCourseWorkspace,
  __hasProp = {}.hasOwnProperty,
  __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

ClassroomCourseWorkspace = (function(_super) {
  __extends(ClassroomCourseWorkspace, _super);

  function ClassroomCourseWorkspace(options, data) {
    var _this = this;
    if (options == null) {
      options = {};
    }
    options.cssClass = "classroom-course-builder";
    options.name = "Classroom Course Builder";
    options.panels = [
      {
        title: "General Course Details",
        hint: "<p>Lorem ipsum dolor sit amet</p>",
        buttons: [
          {
            title: "Save",
            cssClass: "cupid-green join-button",
            callback: function() {
              return _this.emit("CourseSaveRequested");
            }
          }, {
            title: "Save Chapter",
            cssClass: "cupid-green hidden",
            callback: function() {
              return _this.emit("ChapterSaveRequested");
            }
          }, {
            title: "Cancel",
            cssClass: "clean-gray join-button hidden",
            callback: function(panel) {
              return _this.emit("ChapterAddingCancelled", panel);
            }
          }
        ],
        pane: {
          type: "custom",
          paneClass: CourseBuilder,
          name: "courseBuilder"
        }
      }
    ];
    ClassroomCourseWorkspace.__super__.constructor.call(this, options, data);
  }

  return ClassroomCourseWorkspace;

})(Workspace);
/* BLOCK STARTS: /home/alexdesouza/Applications/ClassroomCourseBuilder.kdapp/index.coffee */
appView.addSubView(new ClassroomCourseWorkspace);

/* KDAPP ENDS */
}).call();