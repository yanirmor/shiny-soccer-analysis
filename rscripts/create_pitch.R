create_pitch <- function() {
  y_min <- 0 
  y_max <- 6750
  x_min <- 0 
  x_max <- 10500
  
  grass_color <- "#77BF48"
  line_color <- "#FFFFFF"
  background_color <- "#4B7A2C"
  goal_color <- "#000000"
  
  penalty_mark <- 1100
  
  penalty_box_width <- 4030
  penalty_box_width <- c(
    (y_max / 2) + (penalty_box_width / 2),
    (y_max / 2) - (penalty_box_width / 2)
  )
  
  penalty_box_length <- 1650
  penalty_box_length <- c(
    penalty_box_length, 
    x_max - penalty_box_length
  )
  
  goal_width <- 732
  goal_posts <- c(
    (y_max / 2) + (goal_width / 2),
    (y_max / 2) - (goal_width / 2)
  )
  
  goal_box_width <- 1832
  goal_box_width <- c(
    (y_max / 2) + (goal_box_width / 2),
    (y_max / 2) - (goal_box_width / 2)
  )
  
  goal_box_length <- 550
  goal_box_length <- c(
    goal_box_length,
    x_max-goal_box_length
  )
  
  center_circle_radius <- 915
  
  create_circle <- function(center, radius){
    tt <- seq(from = 0, to = 2 * pi, length.out = 1000)
    xx <- center[1] + radius * cos(tt)
    yy <- center[2] + radius * sin(tt)
    data.frame(x = xx, y = yy)
  }
  
  left_box_arc <- create_circle(
    center = c(penalty_mark, y_max / 2), 
    radius = center_circle_radius
  )
  left_box_arc <- left_box_arc[which(left_box_arc$x >= 1650), ]
  
  right_box_arc <- create_circle(
    center = c(x_max - penalty_mark, y_max / 2), 
    radius = center_circle_radius
  )
  right_box_arc <- right_box_arc[which(right_box_arc$x <= x_max - 1650), ]
  
  center_circle <- create_circle(
    center = c(x_max / 2, y_max / 2), 
    radius = center_circle_radius
  )
  
  plot_df <- data.frame(
    x_max = x_max,
    y_max = y_max,
    penalty_box_length_1 = penalty_box_length[1], 
    penalty_box_length_2 = penalty_box_length[2], 
    penalty_box_width_1 = penalty_box_width[1], 
    penalty_box_width_2 = penalty_box_width[2],
    goal_box_length_1 = goal_box_length[1], 
    goal_box_length_2 = goal_box_length[2], 
    goal_box_width_1 = goal_box_width[1], 
    goal_box_width_2 = goal_box_width[2],
    penalty_mark = penalty_mark,
    goal_posts_1 = goal_posts[1],
    goal_posts_2 = goal_posts[2]
  )
  
  ggplot(data = plot_df) +
    xlim(c(-10, x_max + 10)) +
    ylim(c(-10, y_max + 10)) +
    theme(
      axis.text.x = element_blank(),
      axis.text.y = element_blank(),
      axis.title.x = element_blank(),
      axis.title.y = element_blank(),
      axis.ticks.length = unit(0, "lines"),
      panel.background = element_rect(
        fill = background_color,
        color = background_color
      ),
      panel.grid.major = element_blank(),
      panel.grid.minor = element_blank(),
      plot.background = element_blank()
    ) +
    
    # pitch
    geom_rect(
      mapping = aes(
        xmin = 0,
        xmax = x_max,
        ymin = 0,
        ymax = y_max
      ),
      fill = grass_color,
      color = line_color
    ) +

    # penalty box left
    geom_rect(
      mapping = aes(
        xmin = 0,
        xmax = penalty_box_length_1,
        ymin = penalty_box_width_1,
        ymax = penalty_box_width_2
      ),
      fill = grass_color,
      color = line_color
    ) +

    # penalty box right
    geom_rect(
      mapping = aes(
        xmin = penalty_box_length_2,
        xmax = x_max,
        ymin = penalty_box_width_1,
        ymax = penalty_box_width_2
      ),
      fill = grass_color,
      color = line_color
    ) +

    # goal box left
    geom_rect(
      mapping = aes(
        xmin = 0,
        xmax = goal_box_length_1,
        ymin = goal_box_width_1,
        ymax = goal_box_width_2
      ),
      fill = grass_color,
      color = line_color
    ) +

    # goal box right
    geom_rect(
      mapping = aes(
        xmin = goal_box_length_2,
        xmax = x_max,
        ymin = goal_box_width_1,
        ymax = goal_box_width_2
      ),
      fill = grass_color,
      color = line_color
    ) +

    # half line
    geom_segment(
      mapping = aes(
        x = x_max / 2,
        y = y_min,
        xend = x_max / 2,
        yend = y_max
      ),
      color = line_color
    ) +

    # penalty box left arc
    geom_path(
      data = left_box_arc,
      mapping = aes(x = x, y = y),
      color = line_color
    ) +

    # penalty box right arc
    geom_path(
      data = right_box_arc,
      mapping = aes(x = x, y = y),
      color = line_color
    ) +

    # center circle
    geom_path(
      data = center_circle,
      mapping = aes(x = x, y = y),
      color = line_color
    ) +

    # penalty mark left
    geom_point(
      mapping = aes(
        x = penalty_mark ,
        y = y_max / 2
      ),
      color = line_color
    ) +

    # penalty mark right
    geom_point(
      mapping = aes(
        x = x_max - penalty_mark,
        y = y_max / 2
      ),
      color = line_color
    ) +

    # circle center mark
    geom_point(
      mapping = aes(
        x = x_max / 2,
        y = y_max / 2
      ),
      color = line_color
    ) +

    # goal posts left
    geom_segment(
      mapping = aes(
        x = x_min,
        y = goal_posts_1,
        xend = x_min,
        yend = goal_posts_2
      ),
      color = goal_color,
      size = 1
    ) +

    # goal posts right
    geom_segment(
      mapping = aes(
        x = x_max,
        y = goal_posts_1,
        xend = x_max,
        yend = goal_posts_2
      ),
      color = goal_color,
      size = 1
    )
}
