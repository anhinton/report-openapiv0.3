#!/usr/bin/Rscript
setwd("~/uoastorage/openapi/documentation/report/transform")

library(conduit)

## produce table of contents

## run pipeline to extract <cite key=""/> tags and produce APA references
transform <- loadPipeline(
    name = "transform",
    ref = "processCitations/pipeline.xml")
out1 <- runPipeline(transform, targ = tempdir())

## convert report.xml to report.Rhtml
toRhtml <- loadPipeline(
    name = "toRhtml",
    ref = "toRhtml/pipeline.xml")
out2 <- runPipeline(toRhtml, targ = tempdir())
