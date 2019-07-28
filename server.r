source("https://raw.githubusercontent.com/himnsuk/taba-shiny-assignment/master/dependencies.R")
udmodel <- udpipe_download_model(language = "english")
udmodel <- udpipe_load_model(file = udmodel$file_model)

shinyServer(
  function(input, output) {
    Dataset <- reactive({
      if(is.null(input$textFile)) return(
        "Please upload a file in left panel"
      ) else{
        text_file_read <- readLines(input$textFile$datapath)
        text_file_read  =  str_replace_all(text_file_read, "<.*?>", "")
        text_annotations <- udpipe_annotate(udmodel, x = text_file_read)
        text_df <- as.data.frame(text_annotations, detailed = TRUE)
        work_df <- text_df[-c(1, 4)]
        return(work_df)
      }
    })
    output$table <- DT::renderDataTable(head(Dataset(), 100),
                                        extensions = c('Buttons', 'Scroller'),
                                        options = list(
                                          dom = 'Bftsp',
                                          deferRender = TRUE,
                                          scrollY = 400,
                                          scroller = TRUE,
                                          buttons = c('copy', 'csv', 'excel', 'pdf', 'print')
                                        ))

    output$networkChart <- renderPlot({
      work_df <- Dataset()
      text_file_cooccuance <- keywords_collocation(x=work_df,
                                                   term = "token",
                                                   group = c("paragraph_id", "sentence_id"),
                                                   ngram_max = 4
      )

      text_file_cooc <- cooccurrence(x=subset(work_df, upos %in% c("NOUN", "VERB")),
                                     term = "lemma",
                                     group=c("paragraph_id", "sentence_id")
      )
      wordnetwork <- head(text_file_cooc, 30)


      wordnetwork <- igraph::graph_from_data_frame(wordnetwork)

      x <- ggraph(wordnetwork, layout = "fr") +
        geom_edge_link(aes(width = cooc, edge_alpha = cooc), edge_colour = "#d16102") +
        geom_node_text(aes(label = name), col = "blue", size = 4) +
        return(x)
    })

    output$wordCloudNoun <- renderPlot({
      work_df <- Dataset()
      nouns_stats <- textrank_keywords(work_df$lemma,
                                       relevant = work_df$upos %in% c("NOUN"),
                                       ngram_max = 8, sep = " ")
      wordCloudNoun <- wordcloud(words = nouns_stats$keywords$keyword, freq = nouns_stats$keywords$freq, colors=brewer.pal(8, "Dark2"))
      return(wordCloudNoun)
    })
    output$wordCloudVerb <- renderPlot({
      work_df <- Dataset()
      verb_stats <- textrank_keywords(work_df$lemma,
                                       relevant = work_df$upos %in% c("VERB"),
                                       ngram_max = 8, sep = " ")
      wordCloudVerb <- wordcloud(words = verb_stats$keywords$keyword, freq = verb_stats$keywords$freq, colors=brewer.pal(8, "Dark2"))
      return(wordCloudVerb)
    })
  }
)




