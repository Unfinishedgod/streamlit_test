library(tidyverse)
library(rvest)

df_info_list <- read_csv("product_df_2.csv")

for(x in 1:nrow(df_info_list)) {
  try({
    product_title <- df_info_list$product_title[x]
    product_url <- df_info_list$product_url[x]
    
    df_info_html <- product_url %>% 
      read_html() %>% 
      html_nodes(".top_summary_title__15yAr")
    
    df_info_score <- df_info_html %>% 
      html_nodes(".top_grade__3jjdl") %>% 
      html_text()
    
    if(length(df_info_score)==0) {
      df_info_score <- "없음"
    }
    
    df_info_detail <- df_info_html %>% 
      html_nodes(".top_cell__3DnEV") %>%
      html_text() 
    
    if(length(df_info_detail)==0) {
      df_info_detail <- "없음"
    } else {
      df_info_detail <- df_info_detail %>% 
        paste0(collapse = "\n\n\n")
    }
    
    
    detail_df <- data.frame(
      product_title,
      product_url,
      df_info_score,
      df_info_detail
    )
    
    write_lines(paste0(product_title,"_",
                       Sys.time()), "detail_log.txt", append= TRUE)
    
    if(!file.exists("product_detail_2.csv")) {
      detail_df %>%
        write_excel_csv("product_detail_2.csv")
    } else {
      detail_df %>%
        write_excel_csv("product_detail_2.csv", append= TRUE)
    }
  }, silent = T)
  Sys.sleep(sample(1:5,1)/5)
}
