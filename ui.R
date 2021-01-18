basicPage(
  # page set up -----
  tags$head(
    tags$meta(charset = "UTF-8"),
    
    tags$meta(
      name = "keywords",
      content = "R Shiny, Shiny, Shiny Soccer Analysis, Yanir Mor"
    ),
    
    tags$meta(
      name = "description",
      content = "Demonstration of network analysis and visualization in R. The package ggplot2 is utilized to analyze and visualize data from soccer games."
    ),
    
    tags$link(href = "icons/soccer.png", rel = "icon"),
    tags$link(href = "icons/soccer.png", rel = "apple-touch-icon"),
    tags$link(
      rel = "stylesheet", 
      href = "https://fonts.googleapis.com/css?family=Open+Sans"
    ),
    tags$title("Soccer Analysis")
  ),
  
  includeCSS(path = "style.css"),
  includeCSS(path = "media_style.css"),
  includeScript(path = "script.js"),
  
  introjsUI(),
  includeCSS(path = "css/style_introjs.css"),
  includeCSS(path = "css/media_style_introjs.css"),
  
  # header -----
  tags$header(
    div(
      id = "header_title", 
      
      img(src = "icons/soccer.png"), 
      HTML(
        "<span class=\"third-color\">S</span>occer",
        "<span class=\"third-color\">A</span>nalysis"
      )
    ),
    
    div(
      id = "header_buttons",
      
      a(
        href = "https://www.yanirmor.com", 
        target = "_blank", 
        img(src = "icons/website.png"),
        title = "My Website"
      ),
      
      a(
        href = "https://github.com/yanirmor/shiny-soccer-analysis", 
        target = "_blank", 
        img(src = "icons/github.png"),
        title = "Source Code"
      )
    )
  ),
  
  # body -----
  div(
    class = "wrapper",
    
    # about section -----
    div(
      id = "about",
      
      div(class = "content-title", "About"),
      "This app demonstrates network analysis and visualization in R, with dplyr and ggplot2.", 
      br(),
      "It is based on data from real soccer games that was adapted and made anonymous, per the request of the original data owner.",
      
      # hr separator -----
      div(
        class = "hr-separator",
        div(class = "hr-line"),
        img(src = "icons/soccer.png"),
        div(class = "hr-line")
      )
    ),
    
    # main section -----
    div(
      id = "main",
      
      # menu section -----
      div(
        id = "menu",
  
        actionButton(inputId = "intro_button", label = "?"),
        
        div(
          id = "select_inputs",
          
          selectInput(
            inputId = "game_id",
            label = NULL,
            choices = c("Game #1" = 1, "Game #2" = 2, "Game #3" = 3)
          ),
          
          selectInput(
            inputId = "team",
            label = NULL,
            choices = c("Home Team" = "home", "Away Team" = "away")
          )
        ),
        
        div(
          id = "checkboxes",
          
          introBox(
            class = "intro-wrapper",
            data.step = 1, 
            data.intro = paste(
              "The soccer pitch is divided to <b>18 equal zones</b>.",
              "Select this option to display the zones."
            ),
            
            awesomeCheckbox(
              inputId = "zones",
              label = "Pitch Zones", 
              value = F
            )
          ),
          
          introBox(
            class = "intro-wrapper",
            data.step = 3, 
            data.intro = paste(
              "Select this option to display",
              "<b>the most contributing player in each zone</b>.",
              "The position of each player-node is the average position of the player's touches."
            ),
            
            awesomeCheckbox(
              inputId = "players",
              label = "Most Contributing Players", 
              value = F
            )
          )
        )
      ),
      
      # viz section -----
      introBox(
        id = "viz_wrapper",
        data.step = 2, 
        data.intro = "
        <b>Big nodes</b> represent ball \"touches\" (passes, shots and dribbles). 
        Their size scales with the number of touches, 
        and their position is the average position of touches in each zone.
        <br><br>
        <b>Edges</b> represent passes between zones. 
        Their width scales with the number of passes.
        ",
        data.position = "top",
        
        plotOutput(outputId = "viz", width = "100%", height = "100%")  
      )
    )
    
    
  ),
  
  # footer -----
  tags$footer(
    div(
      id = "footer_copyright",
      "2019", 
      span(class = "third-color", "Yanir Mor"), 
      HTML("&copy;"), 
      "All Rights Reserved",
      span(
        id = "licenses",
        span(class = "third-color", "(Licenses)"),
        div(
          tags$li("Base pitch plot adapted from GitHub FCrSTATS"),
          tags$li("Icon by Ivan Boyko / Iconfinder (CC BY 3.0)")
        )
      )
    )
  )
)
