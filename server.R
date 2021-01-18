function(input, output, session) {

  # data -----
  nodes <- reactive({
    read.csv(file = "data/touch_df.csv") %>%
      filter(game_id == input$game_id, team == input$team)
  })
  
  small_nodes <- reactive({
    small_nodes <- read.csv(file = "data/player_df.csv") %>%
      filter(game_id == input$game_id, team == input$team) %>%
      select(-game_id, -team)
    
    small_nodes %>%
      arrange(desc(count)) %>%
      group_by(start_zone) %>%
      summarize(
        player = first(player),
        mean_x = first(mean_x),
        mean_y = first(mean_y)
      ) %>%
      as.data.frame()
  })
  
  edges <- reactive({
    df <- read.csv(file = "data/pass_df.csv") %>%
      filter(
        start_zone != end_zone,
        game_id == input$game_id,
        team == input$team
      )
    
    df <- df %>%
      inner_join(
        y = nodes() %>% select(start_zone, x = mean_x, y = mean_y),
        by = "start_zone"
      )
    
    df <- df %>%
      inner_join(
        y = nodes() %>% select(start_zone, xend = mean_x, yend = mean_y),
        by = c("end_zone" = "start_zone")
      )
    
    bind_rows(
      df, 
      df %>% rename(end_zone = start_zone, start_zone = end_zone)
    ) %>%
      filter(start_zone < end_zone) %>%
      group_by(game_id, team, start_zone, end_zone) %>%
      summarize(
        x = first(x), 
        y = first(y), 
        xend = first(xend), 
        yend = first(yend),
        count = sum(count)
      ) %>%
      as.data.frame()
  })
  
  # viz -----
  plot_params <- reactive({
    req(input$screen_width)
    
    if (input$screen_width > 992) {
      list(
        big_nodes_size_range = c(5, 18),
        small_nodes_size = 3,
        small_nodes_text_size = 5,
        small_nodes_text_angle = 0,
        small_nodes_text_nudge_x = nudge_small_nodes(dimension = "x", value = small_nodes()$mean_x),
        small_nodes_text_nudge_y = nudge_small_nodes(dimension = "y", value = small_nodes()$mean_y, main_axis = F),
        attack_direction_size = 7,
        attack_angle = -90,
        attack_vjust = -1
      )
      
    } else if (input$screen_width > 576) {
      list(
        big_nodes_size_range = c(4, 16),
        small_nodes_size = 3,
        small_nodes_text_size = 4,
        small_nodes_text_angle = 0,
        small_nodes_text_nudge_x = nudge_small_nodes(dimension = "x", value = small_nodes()$mean_x),
        small_nodes_text_nudge_y = nudge_small_nodes(dimension = "y", value = small_nodes()$mean_y, main_axis = F),
        attack_direction_size = 5,
        attack_angle = -90,
        attack_vjust = -1
      )
      
    } else {
      list(
        big_nodes_size_range = c(3, 14),
        small_nodes_size = 2,
        small_nodes_text_size = 3,
        small_nodes_text_angle = 90,
        small_nodes_text_nudge_x = nudge_small_nodes(dimension = "x", value = small_nodes()$mean_x, main_axis = F),
        small_nodes_text_nudge_y = nudge_small_nodes(dimension = "y", value = small_nodes()$mean_y),
        attack_direction_size = 3,
        attack_angle = 90,
        attack_vjust = 1.75
      )
    }
  })
  
  output$viz <- renderCachedPlot(
    cacheKeyExpr = list(
      small_nodes(),
      plot_params(),
      edges(),
      nodes(),
      input$zones,
      input$players
    ),
    expr = {
      # optional layers -----
      layers <- list(
        zones = geom_segment(
          data = pitch_df,
          aes(x = x, y = y, xend = xend, yend = yend),
          color = "#25414b",
          size = 1,
          alpha = 1
        ),
        
        players = list(
          geom_point(
            data = small_nodes(),
            mapping = aes(x = mean_x, y = mean_y), 
            size = plot_params()$small_nodes_size,
            color = "#000000",
            shape = 16,
            show.legend = F
          ),
          
          geom_text(
            data = small_nodes(),
            mapping = aes(x = mean_x, y = mean_y, label = player),
            color = "#fcf854",
            family = "Open Sans",
            fontface = "bold",
            lineheight = 1,
            size = plot_params()$small_nodes_text_size,
            angle = plot_params()$small_nodes_text_angle,
            nudge_y = plot_params()$small_nodes_text_nudge_y,
            nudge_x = plot_params()$small_nodes_text_nudge_x
          )
        )
      )
      
      # plot -----
      pitch_base_plot +
        
        # defence / attack labels
        geom_text(
          x = 0, y = 3375, 
          label = "DEFENCE", 
          color = "#ffffff",
          family = "Open Sans",
          fontface = "bold",
          size = plot_params()$attack_direction_size,
          vjust = -1, angle = 90
        ) +
        
        geom_text(
          x = 10500, y = 3375, 
          label = "ATTACK", 
          color = "#ffffff",
          family = "Open Sans",
          fontface = "bold",
          size = plot_params()$attack_direction_size,
          vjust = plot_params()$attack_vjust, angle = plot_params()$attack_angle
        ) +
        
        # edges
        geom_segment(
          data = edges(),
          mapping = aes(x = x, y = y, xend = xend, yend = yend),
          size = edges()$count %>% rescale(c(1, 5)),
          alpha = edges()$count %>% rescale(c(0.1, 1)),
          show.legend = F
        ) +
        
        # nodes
        geom_point(
          data = nodes(),
          mapping = aes(x = mean_x, y = mean_y),
          size = nodes()$count %>% rescale(plot_params()$big_nodes_size_range),
          color = "#5aa3bb",
          shape = 16,
          show.legend = F
        ) +
        
        # optional layers
        layers[c(input$zones, input$players)]
    }
  )
  
  # intro -----
  observeEvent(input$intro_button, {
    session$sendCustomMessage(
      type = "matomoEvent", 
      message = c("IntroJS", "Click", "Click")
    )
    
    introjs(
      session = session, 
      options = list(
        nextLabel = "Next",
        prevLabel = "Previous",
        skipLabel = "Exit",
        doneLabel = "Done",
        hidePrev = T,
        hideNext = T,
        showStepNumbers = T,
        showButtons = T,
        showBullets = F,
        showProgress = F,
        disableInteraction = T 
      )
    )
  })
  
}