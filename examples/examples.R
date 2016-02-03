### pipeline example for Honours report
library(conduit)

## UK Commuter Flow
## ersatz copies of the original files are hosted on a webserver at
## http://127.0.0.1:8088/report/ as the original resource link is broken
##
## THIS ONE TAKES A WHILE
ukCommuterErsatz <- loadPipeline("ukCommuterErsatz",
                                 "ukCommuterErsatz/pipeline.xml")
runPipeline(ukCommuterErsatz, targ = tempdir())

## UK Commuter Response
##
## This pipeline uses the data modules from "UK Commuter Flow" pipeline,
## but plots things differently
##
## ersatz copies of the original files are hosted on a webserver at
## http://127.0.0.1:8088/report/ as the original resource link is broken
##
## THIS ONE TAKES A WHILE
ukResponseErsatz <- loadPipeline("ukResponseErsatz",
                                 "ukResponseErsatz/pipeline.xml")
runPipeline(ukResponseErsatz, targ = tempdir())

extract_flow_data <- loadModule("extract_flow_data",
                                "ukResponseErsatz/extract_flow_data.xml")
out1 <- runModule(extract_flow_data, targ=tempdir())

retrieve_centroids <- loadModule("retrieve_centroids",
                                 "ukResponseErsatz/retrieve_centroids.xml")
out2 <- runModule(retrieve_centroids, targ = tempdir())

extract_script <- loadModule("extract_script",
                             "ukResponseErsatz/extract_script.xml")
runModule(extract_script, targ = tempdir())
