report.Rhtml <- "~/uoastorage/openapi/documentation/report/report.Rhtml"
oldwd <- setwd(dirname(report.Rhtml))
on.exit(setwd(oldwd))
library(knitr)
knit(report.Rhtml)
