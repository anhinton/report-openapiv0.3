library(R2HTML)
outfile <- HTMLInitFile(outdir = "/var/www/conduit",
                        filename = "xfiles_season_1",
                        Title = "The X Files Season 1")
HTML("<h1>The X Files Season 1</h1>", outfile)
HTML(season1, outfile, row.names = FALSE)
HTML("Source: <a href=\"https://en.wikipedia.org/wiki/List_of_The_X-Files_episodes\">https://en.wikipedia.org/wiki/List_of_The_X-Files_episodes</a>",
     outfile)
HTMLEndFile(outfile)
