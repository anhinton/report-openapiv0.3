#!/bin/bash
## replace latex-style quotes
sed -i "s/\`/'/g" report.xml
sed -i "s/''/\"/g" report.xml
