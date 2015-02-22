saveMstar <- function(directory)
{
  library("RSQLite")
  library(XML)
  library(httr)
  
  con = dbConnect(dbDriver("SQLite"), dbname="dbPortfoliov0.20.db")
  IdsMstar <- dbGetQuery(con, "select p.pkid, p.chname, cm.chIdMorningstar from tbProducts p inner join tbCrossMorningstar cm on p.pkid = cm.idProduct")
  
  currDir <- getwd()
  if (!file.exists(directory))
  {
    dir.create(directory)
  }
  setwd(directory)
  
  urlMstarBase <- "http://www.morningstar.es/es/funds/snapshot/snapshot.aspx?id="
  urlPostPortfolio <- "&tab=3"
    
  for (idMS in IdsMstar)
  {
    url <- paste(urlMstarBase, idMS[3], urlPostPortfolio, sep="")
#     filename <- paste(idMS, ".html", sep="")
#     if (!file.exists(filename))
#     {
#       download.file(url, destfile=filename)
#     }

    html <- GET(url)
    content = content(html, as="text")
    parsedHtml = htmlParse(content, asText=TRUE)
    node <- xpathSApply(parsedHtml, "//tr[td='Estados Unidos'][1]/td[@class='value number'][2]/text()")
    print(idMS[2]);print(node)
  }
  setwd(currDir)
}