#!/usr/bin/Rscript
library(XML)
report.xml <- xmlParse("report.xml")

#' Convert an XML heading node to a list item with a link to the
#' heading id
xmlToLi <- function(x) {
    li <- newXMLNode("li")
    link <- newXMLNode("a")
    xmlAttrs(link) <- c(href = paste0("#", xmlAttrs(x)[["id"]]))
    xmlValue(link) <- xmlValue(x)
    li <- addChildren(li, kids = list(link))
    li
}

#' Create a section of an HTML table of contents for one document section
sectionToContents <- function(section) {
    h1 <- getNodeSet(section, "h1")[[1]]
    h2 <- getNodeSet(section, ".//h2")
    item <- xmlToLi(h1)
    if (length(h2)) {
        ul <- newXMLNode("ul")
        ul <- addChildren(ul, kids = lapply(h2, xmlToLi))
        item <- addChildren(item, kids = list(ul))
    }
    item
}

## give unique ids to <h1> and <h2> tags
headingList <- getNodeSet(report.xml, "//h1|//h2")
headingList <-
    lapply(seq_along(headingList),
           function (i, heading) {
               id <- gsub("[ ]", "-", tolower(xmlValue(heading[[i]])))
               id <- gsub("'", "", id)
               id <- paste("c", i, "-", id, sep="")
               xmlAttrs(heading[[i]])[["id"]] <- id
           }, headingList)

## extract sections for table of contentx
sectionList <- getNodeSet(report.xml, "//section")
sectionClass <- xpathApply(
    report.xml, "//section",
    function(x) {
        if ("class" %in% names(xmlAttrs(x))) {
            xmlAttrs(x)[["class"]]
        } else {
            NULL
        }
    })
sectionList <- sectionList[!(sectionClass == "contents")]
appendixList <- getNodeSet(report.xml, "//appendix")
sectionList <- c(sectionList, appendixList)

## produce table of contents in contents.html
contents <- sapply(sectionList, sectionToContents)
contents <- newXMLNode("ul", unlist(contents))
saveXML(contents, "~/uoastorage/openapi/documentation/report/contents.xml")

saveXML(report.xml, "report.xml")
