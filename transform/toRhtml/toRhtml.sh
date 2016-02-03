#!/bin/sh
xsltproc -o $HOME/uoastorage/openapi/documentation/report/report.Rhtml \
    $HOME/uoastorage/openapi/documentation/report/xsl/toRhtml.xsl \
    report.xml
