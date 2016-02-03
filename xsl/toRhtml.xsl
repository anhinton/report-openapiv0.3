<?xml version="1.0"?>
<xsl:stylesheet version="1.0"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
  <xsl:output encoding="UTF-8" indent="yes" method="html"
	      omit-xml-declaration="yes"
	      doctype-public="-//W3C//DTD HTML 4.01//EN"
	      doctype-system="http://www.w3.org/TR/html4/strict.dtd"/>

  <!-- complete Rhtml document template -->
  <xsl:template match="document">
    <html>
      <head>
	<!-- process head tags -->
	<xsl:apply-templates select="//head"/>
	<meta name="viewport" content ="width=device-width, initial-scale=1.0"/>
	<link rel="stylesheet" href="stylesheet.css"/>
      </head>
      <body>
	<xsl:comment>begin.rcode setup, include=FALSE<xsl:text>
</xsl:text>library(knitr)
opts_chunk$set(cache=TRUE)
end.rcode</xsl:comment>
	<xsl:apply-templates select="//body"/>
      </body>
    </html>
  </xsl:template>

  <!-- html head template -->
  <xsl:template match="//head">
    <title><xsl:value-of select="title"/></title>

    <!-- author meta tag -->
    <xsl:for-each select="authors/author/name">
      <xsl:element name="meta">
	<xsl:attribute name="name">author</xsl:attribute>
	<xsl:attribute name="content">
	  <xsl:value-of select="node()"/>
	</xsl:attribute>
      </xsl:element>
    </xsl:for-each>

    <!-- date meta tag -->
    <xsl:if test="date != ''">
      <xsl:element name="meta">
	<xsl:attribute name="name">date</xsl:attribute>
	<xsl:attribute name="content">
	  <xsl:value-of select="date"/>
	</xsl:attribute>
      </xsl:element>
    </xsl:if>

    <!-- date meta tag -->
    <xsl:if test="description != ''">
      <xsl:element name="meta">
	<xsl:attribute name="name">description</xsl:attribute>
	<xsl:attribute name="content">
	  <xsl:value-of select="description"/>
	</xsl:attribute>
      </xsl:element>
    </xsl:if>
  </xsl:template>

  <!-- html body template -->
  <xsl:template match="//body">
    <div class="main">
      <!-- produce document title section -->
      <div class="title">
	<h1 class="title"><xsl:value-of select="//head/title"/></h1>

	<!-- subtitle -->
	<xsl:for-each select="//head/subtitle">
	  <xsl:if test="//head/subtitle != ''">
	    <h2 class="subtitle"><xsl:value-of select="node()"/></h2>
	  </xsl:if>
	</xsl:for-each>

	<!-- authors -->
	<xsl:for-each select="//head/authors/author">
	  <p class="author">
	    <xsl:value-of select="name"/>
	    <!-- email -->
	    <xsl:if test="email">
	    <br/><xsl:element name="a"><xsl:attribute name="href"><xsl:value-of select="email"/></xsl:attribute><xsl:value-of select="email"/></xsl:element></xsl:if>
	  </p>
	</xsl:for-each>
	<!-- affiliation -->
	<xsl:if test="//head/authors/affiliation">
	  <p class="author">
	    <xsl:value-of select="//head/authors/affiliation"/>
	  </p>
	</xsl:if>
	<!-- date -->
	<p class="date"><xsl:value-of select="//head/date"/></p>
      </div>
      
      <!-- process rest of body -->
      <xsl:apply-templates select="@*|node()"/>
    </div>
  </xsl:template>

  <!-- figures -->
  <xsl:template match="figure">
    <div class="figure">
      <xsl:element name="img">
	<xsl:attribute name="class">figure</xsl:attribute>
	<xsl:attribute name="id">figure-<xsl:value-of select="@number"/></xsl:attribute>
	<xsl:attribute name="src"><xsl:value-of select="normalize-space(@src)"/></xsl:attribute>
	<xsl:attribute name="alt"><xsl:value-of select="normalize-space(@alt)"/></xsl:attribute>
      </xsl:element>
      <div class="figcaption"><p>Figure <xsl:value-of select="@number"/>: <xsl:value-of select="figcaption"/></p></div>
    </div>
  </xsl:template>

  <!-- url items -->
  <xsl:template match="url">
    <xsl:element name="a">      
      <xsl:attribute name="href">
	<xsl:value-of select="node()"/>
      </xsl:attribute>
      <xsl:value-of select="node()"/>
    </xsl:element>
  </xsl:template>

  <!-- cite items -->
  <xsl:template match="cite">
    <xsl:element name="a">
      <xsl:attribute name="href">#ref-<xsl:value-of select="@key"/></xsl:attribute><xsl:value-of select="node()"/>
    </xsl:element>
  </xsl:template>

  <!-- knitr chunks -->
  <xsl:template match="pre[@class='knitr']">
    <xsl:text>

</xsl:text><xsl:comment>begin.rcode <xsl:value-of select="@name"/><xsl:if test="@options != ''"><xsl:text>, </xsl:text><xsl:value-of select="@options"/></xsl:if><xsl:text>
</xsl:text><xsl:value-of select="."/><xsl:text>
</xsl:text>end.rcode</xsl:comment><xsl:text>
     
</xsl:text>
  </xsl:template>
  
  <!-- todo items -->
  <xsl:template match="todo">
    <strong>TODO: <xsl:value-of select="."/></strong>
  </xsl:template>

  <!-- ann items -->
  <xsl:template match="ann">
    <span class="ann"><xsl:value-of select="."/></span>
  </xsl:template>

  <!-- mod items -->
  <xsl:template match="mod">
    <span class="mod"><xsl:value-of select="."/></span>
  </xsl:template>

  <!-- section to div for html4 -->
  <xsl:template match="section">
    <xsl:element name="div">
      <xsl:if test="@class != ''">
	<xsl:attribute name="class"><xsl:value-of select="@class"/>
	</xsl:attribute>
      </xsl:if>
      <xsl:apply-templates select="@*|node()"/>
    </xsl:element>
  </xsl:template>

  <!-- subsection -->
  <xsl:template match="subsection">
    <div class="subsection">
      <xsl:apply-templates select="@*|node()"/>
    </div>
  </xsl:template>

  <!-- appendix to div for html4 -->
  <xsl:template match="appendix">
    <xsl:element name="div">
      <xsl:attribute name="class">appendix</xsl:attribute>
      <xsl:apply-templates select="@*|node()"/>
    </xsl:element>
  </xsl:template>

  <!-- copy everything into new doc -->
  <xsl:template match="@*|node()">
    <xsl:copy>
      <xsl:apply-templates select="@*|node()"/>
    </xsl:copy>
  </xsl:template>

</xsl:stylesheet>
