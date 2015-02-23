saveMstar <- function()
{
  library("RSQLite")
  library(XML)
  library(httr)

  con <- dbConnect(dbDriver("SQLite"), dbname="Data/dbPortfoliov0.20.db")
  query <- "select p.pkid, p.chname, cm.chIdMorningstar, pv, dtDate, pv.dcHeld
            from tbProducts p
              inner join tbCrossMorningstar cm on p.pkid = cm.idProduct
              inner join tbProductsValue pv on p.pkid = pv.idProduct"
  query <- strwrap(query, width=10000, simplify=TRUE)
  products <- dbGetQuery(con, query)
  
  urlMstarBase <- "http://www.morningstar.es/es/funds/snapshot/snapshot.aspx?id="
  urlPostPortfolio <- "&tab=3"
  
  # Cambiar por función apply!!!
  for (i in c(1:nrow(products)))
  {
    url <- paste(urlMstarBase, products[[3]][[i]], sep="")
    html <- GET(url)
    content = content(html, as="text")
    parsedHtml = htmlParse(content, asText=TRUE)
    vl <- xpathSApply(parsedHtml, "//td[@class='line text' and preceding-sibling::td[text() = 'VL']]", xmlValue)
    dateVL <- xpathSApply(parsedHtml, "//span[ancestor::td[text() = 'VL']]", xmlValue)
    
#     url <- paste(urlMstarBase, products[[3]][[i]], urlPostPortfolio, sep="")
#     html <- GET(url)
#     content = content(html, as="text")
#     parsedHtml = htmlParse(content, asText=TRUE)
# Bucle para coger los nodos de la clasificación por zonas!!!
#    node <- xpathSApply(parsedHtml, "//tr[td='Estados Unidos'][1]/td[@class='value number'][2]", xmlValue)
#    print(paste(products[[2]][[i]], products[[4]][[i]], node, sep = " "))
  }
}