SettingsUI = function(id)
{
  ns = shiny::NS(id)
  shiny::sidebarLayout(
    shiny::sidebarPanel(width = 3, shiny::h3("Settings"), "Here you can tweak settings of the application"),
    shiny::mainPanel(width = 9,
                     shiny::h1("Application settings"),
                     shiny::wellPanel(
                       shiny::h3("App theme"),
                       shiny::selectInput(ns("shinytheme-selector"), NULL, c("default", "cerulean", "cosmo", "cyborg", "darkly", "flatly", "journal", "lumen", "paper", "readable", "sandstone", "simplex", "slate", "spacelab", "superhero", "united", "yeti"), selectize = FALSE),
                       shiny::tags$script(paste0("$('#", ns("shinytheme-selector"),"')\n  .on('change', function(el) {\n    var allThemes = $(this).find('option').map(function() {\n      if ($(this).val() === 'default')\n        return 'simplex';\n      else\n        return $(this).val();\n    });\n\n    // Find the current theme\n    var curTheme = el.target.value;\n    if (curTheme === 'default') {\n      curTheme = 'simplex';\n      curThemePath = 'shinythemes/css/simplex.min.css';\n    } else {\n      curThemePath = 'shinythemes/css/' + curTheme + '.min.css';\n    }\n\n    // Find the <link> element with that has the bootstrap.css\n    var $link = $('link').filter(function() {\n      var theme = $(this).attr('href');\n      theme = theme.replace(/^.*\\//, '').replace(/(\\.min)?\\.css$/, '');\n      return $.inArray(theme, allThemes) !== -1;\n    });\n\n    // Set it to the correct path\n    $link.attr('href', curThemePath);\n  });")), shiny::hr(),
                       shiny::h3("Feature computation"),hr(),
                       shiny::checkboxInput(ns("compute_features"), "Compute all features? (Only recommended for networks with < 2000 points)", value = TRUE), hr(),
                       shiny::h3("Plot appearance"),
                       shiny::selectInput(ns("plot_colors"), "Select a colorpalette for network points", choices = c("Set1", "Set2", "Set3", "Paired", "Accent", "Dark2", "Spectral", "RdYlBu"), selectize = FALSE),
                       shinyWidgets::radioGroupButtons(ns("plot_bg_color"), "Select background color", choices = c("transparent" = 'rgba(252, 252, 252, 0)', "light" = 'rgba(252, 252, 252, 1)', "dark" = 'rgba(28, 28, 28, 1)'), justified = TRUE),
                       shinyWidgets::radioGroupButtons(ns("plot_axis_color"), "Select axis color", choices = c("dark" = 'black', "light" = 'white'), justified = TRUE))
    )
  )
}
