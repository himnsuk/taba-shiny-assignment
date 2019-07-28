library(shiny)

shinyUI(
  fluidPage(
    titlePanel(title= "Shiny App Text Analytics"),
    sidebarLayout(
      sidebarPanel(
        fileInput("textFile", "Upload any text file"),
        checkboxGroupInput("pos", "Part of speech",
                           c("Adjective" = "ADJ",
                             "Adverb"= "ADV",
                             "Noun" = "NOUN",
                             "Proper Noun" = "PRON",
                             "Verb"= "VERB")
        )
      ),
      mainPanel(
        h2("This is the main panels"),
        tabsetPanel(type="tabs",
                    tabPanel("Overview",
                             h4("Text Analytics Assignment - 2 Question-3 Shiny app"),
                             p("1. Upload any text file using left panel"),
                             p("2. Wait until your file uploaded completely"),
                             p("3. After upload complete click on the 'Table of annotated documents' tab"),
                             p("4. You can filter POS using left panel"),
                             p("5. Check noun and verb word cloud by clicking on 'Wordclouds' tab"),
                             p("6. Check co-occurance graph by clicking 'Top-30 co-occurance' tab"),
                             verbatimTextOutput("value")
                             ),
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
