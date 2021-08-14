library(tidyverse)
library(rvest)
library(lubridate)

list_csv <- read_csv("naver_crawler.csv")

list_csv <- list_csv[41:80,]

for(y in 1:nrow(list_csv)) {
  try({
    top_cate <- list_csv$대분류[y]
    middle_cate <- list_csv$소분류[y]
    url_name <- list_csv$cate_url_middle[y]
    
    url_info <- url_name %>% 
      read_html() %>% 
      html_nodes("._itemSection")
    
    for(x in 1:length(url_info)) {
      
      
      product_title <- url_info[x] %>% 
        html_nodes(".cont") %>% 
        html_text()
      
      product_rank <- url_info[x] %>% 
        html_nodes(".best_rnk") %>% 
        html_text()
      
      product_price <- url_info[x] %>% 
        html_nodes(".price") %>% 
        html_text()
      
      product_url <- url_info[x] %>% 
        html_nodes(".cont") %>% 
        html_nodes("a") %>% 
        html_attr("href")
      
      product_review <- url_info[x] %>% 
        html_nodes(".mall") %>% 
        html_nodes(".txt") %>% 
        html_text()
      
      if(length(product_review) == 0) {
        product_review <- "리뷰없음"
      }
      
      total_df <- data.frame(
        '대분류' = top_cate,
        '소분류' = middle_cate,
        product_rank,
        product_title,
        product_price,
        product_review,
        product_url
      )
      
      write_lines(paste0(top_cate,"_",
                         middle_cate,"_",
                         product_title, "_",
                         Sys.time()), "log.txt", append= TRUE)
      
      if(!file.exists("product_df_2.csv")) {
        total_df %>%
          write_excel_csv("product_df_2.csv")
      } else {
        total_df %>%
          write_excel_csv("product_df_2.csv", append= TRUE)
      }
    }
    
  }, silent = T)
  Sys.sleep(10)
}  


