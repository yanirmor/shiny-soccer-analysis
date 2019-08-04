generic_modal <- function(error = T, content) {
  title <- if (error) {
    span(img(src = "icons/soccer_red.png", "Oops..."))
  } else {
    span(img(src = "icons/soccer_green.png", "Success!"))
  }
  
  showModal(
    modalDialog(
      title = title,
      easyClose = T,
      content
    )
  )
}

connect_to_db <- function() {
  dbConnect(
    drv = Postgres(), 
    host = Sys.getenv(x = "DB_HOST"),
    port = Sys.getenv(x = "DB_PORT"),
    dbname = Sys.getenv(x = "DB_NAME"),
    user = Sys.getenv(x = "DB_USER"),
    password = Sys.getenv(x = "DB_PASSWORD")
  )
}

nudge_small_nodes <- function(dimension, value, main_axis = T) {
  max_value <- if (dimension == "x") 10500 else 6750

  if (main_axis) {
    case_when(
      value < max_value * 0.06 ~ max_value * 0.03,
      value > max_value * 0.94 ~ -1 * max_value * 0.03,
      T ~ 0
    )
    
  } else {
    case_when(
      value < max_value / 2 ~ max_value * 0.06,
      T ~ -1 * max_value * 0.05
    )
  }
}
