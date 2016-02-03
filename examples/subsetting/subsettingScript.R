full_script <- readLines("~/Desktop/330_Lecture3_2015.R")
full_script[19] <- "exchange = read.csv(\"~/Desktop/hb1.csv\")"
full_script[21] <- paste("png(\"exchange_rate.png\")",
                         full_script[21],
                         "dev.off()",
                         sep = "; ")
full_script[29] <- "png(\"data_dens.png\")"
subset <- full_script[16:33]

eval(parse(text = subset))
