library(tidyverse)
library(corrr)
library(igraph)
library(ggraph)


# Correlation plot --------------------------------------------------------

# Used for exploratory analysis only and not included in the thesis chapter
# Packages required are not included in packrat and will need to be loaded.

  # Create a tidy data frame of correlation
graph_correlations = function(df, BCGStatus) {
  tidy_cors <- df %>% 
    filter_(.dots = paste0("bcgvacc %in% '", BCGStatus, "'")) %>% 
    select_if(is.numeric) %>%
    select(-timesinceent, -timetotxstart_dr, -phecdecile, - phecquintile, -yr_bcg, - age_bcg, -bcgvaccyr) %>% 
    correlate() %>% 
    stretch()
  
  # Convert correlations stronger than some value
  # to an undirected graph object
  graph_cors <- tidy_cors %>% 
    filter(abs(r) > 0.05) %>% 
    graph_from_data_frame(directed = FALSE)
  
  
  ggraph(graph_cors) +
    geom_edge_link(aes(edge_alpha = abs(r), edge_width = abs(r), color = r)) +
    guides(edge_alpha = "none", edge_width = "none") +
    scale_edge_colour_gradient(limits = c(-1, 1)) +
    geom_node_point(color = "black", size = 2) +
    geom_node_text(aes(label = name), repel = TRUE) +
    theme_graph() -> p
  
  return(list(p, tidy_cors))
}

CorrBCGYes <- graph_correlations(ETS_ext, 'Yes')
CorrBCGNo <- graph_correlations(ETS_ext, 'Yes')

grid.arrange(CorrBCGYes[[1]]+ ggtitle('a.)'), CorrBCGNo[[1]] + ggtitle('b.)'), ncol = 2 )
