library(shiny)

shinyUI(
  fluidPage(
    titlePanel(title= "Hello Shiny, This is a simple title panel"),
    sidebarLayout(
      sidebarPanel(
        ("Enter the personal information"),
        fileInput("textFile", "Upload any text file"),
        checkboxGroupInput("pos", "Part of speech",
                           c("Adjective" = "adjective",
                             "Adverb"= "adverb",
                             "Noun" = "noun",
                             "Proper Noun" = "proper noun",
                             "Verb"= "verb")
        )
      ),
      mainPanel(
        h2("This is the main panels"),
        tabsetPanel(type="tabs",
                    tabPanel("Overview",
                             h4(p("Data Input")),
                             p("This app support only text files")),
                    tabPanel("Table of annotated documents",
                             h4(p("Table of annoted documents")),
                             DT::dataTableOutput('table')),
                    tabPanel("Wordclouds",
                             h3("Wordclouds"),
                             h4("Nouns Wordcloud"),
                             plotOutput(outputId = "wordCloudNoun"),
                             h4("Verbs Wordcloud"),
                             plotOutput(outputId = "wordCloudVerb")),
                    tabPanel("Top-30 co-occurance",
                             h4(p("Top-30 co-occurance")),
                             p("Top-30 co-occurance"),
                             plotOutput(outputId = "networkChart")
                    )
        )
      )
    )
  )
)
