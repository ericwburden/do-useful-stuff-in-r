library(shiny)
library(bslib)

full_row <- function(...) {
    fluidRow(column(width = 12, ...))
}

generate_tutorials_menu <- function() {
    tutorial_dirs <- list.dirs("tutorial", recursive = FALSE)
    tutorials_menu_args <- list(title = "Tutorials", menuName = "tutorials-menu")
    
    for (dir in tutorial_dirs) {
        rmd_file <- paste(dir, "index.Rmd", sep = "/")
        yaml_frontmatter <- rmarkdown::yaml_front_matter(rmd_file)
        title <- yaml_frontmatter$title
        url_path <- paste("tutorial", basename(dir), sep = "/")
        
        # Saves off the first tutorial tab name into an environment variable, used
        # by the 'Get Started' button
        if (Sys.getenv("FIRST_TUTORIAL_TAB") == "") {
            Sys.setenv(FIRST_TUTORIAL_TAB = title)
        }
        
        embedded_tutorial <- tags$iframe(
            src = url_path,
            width = "100%",
            height = "100vh",
            style="border:none;"
        )
        tab_panel <- tabPanel(title, embedded_tutorial)
        tutorials_menu_args[[length(tutorials_menu_args) + 1]] <- tab_panel
    }
    
    do.call(navbarMenu, tutorials_menu_args)
}

ui <- navbarPage(
    theme = bs_theme(version = 4, bootswatch = "sandstone"),
    includeCSS("www/css/style.css"),
    id = "navbar-main",
    title = "Do Useful Stuff in R!",
    selected = "welcome-page",
    collapsible = TRUE,
    tabPanel(
        "Welcome",
        value = "welcome-page",
        class = "welcome-page",
        fluidRow(column(width = 8, offset = 2, 
            full_row(
                class = "welcome-page-contents",
                full_row(
                    h2(
                        "Your 'Get out of Excel Free' Card",
                        class = "display-4 text-center bolder text-success mt-4 bg-light"
                    )
                ),
                full_row(
                    p(
                        "There's a better way to understand, visualize, and reproduce your data. ",
                        "The R programming language, is free, open-source, and made for people like ",
                        "you to do jobs like yours (you know, the one with spreadsheets). Dive in to ",
                        "revolutionize your workflows and never go back to asking 'Now, which formula ",
                        "did I run first?' again.",
                        class = "lead text-center bg-success text-light p-2"
                    )
                ),
                full_row(
                    actionButton(
                        "get-started-btn",
                        "Get Started",
                        class = "btn-success"
                    )
                )
            )
        ))
    ),
    generate_tutorials_menu()
    
)

# Define server logic required to draw a histogram
server <- function(input, output, session) { 
    observeEvent(
        input$`get-started-btn`,
        showTab(inputId = 'navbar-main', target = Sys.getenv("FIRST_TUTORIAL_TAB"), select = T)
    )    
}

# Run the application 
shinyApp(ui = ui, server = server)
