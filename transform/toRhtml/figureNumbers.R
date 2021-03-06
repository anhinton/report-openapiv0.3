library(XML)
report.xml <- xmlParse("report.xml")
figure <- getNodeSet(report.xml, "//figure")
for (i in seq_along(figure))
    xmlAttrs(figure[[i]]) <- c(number = i)
saveXML(report.xml, "report.xml")
