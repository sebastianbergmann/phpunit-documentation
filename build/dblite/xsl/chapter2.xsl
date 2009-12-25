<!-- This is a plain chapter that will appear in one file. For a more
complex design with one page per section, use chapter.xsl -->

<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                version="1.0"
>

<xsl:template name="chapter">
  <file>
    <xsl:attribute name="name">
      <xsl:call-template name="filename"/>
    </xsl:attribute>
    <label>
      <xsl:call-template name="label"/>
    </label>
    <number>
      <xsl:value-of select="@label"/>
    </number>
  <html>
    <head>
      <title>
        <xsl:value-of select="title"/>
        <xsl:text> (</xsl:text>
        <xsl:value-of select="/book/title"/>
        <xsl:text>)</xsl:text>
      </title>
      <link rel="stylesheet" type="text/css" href="../style/style1.css"/>
      <xsl:value-of select="$dblnewline"/>

    </head>
    <body bgcolor="#ffffff">

      <xsl:apply-templates/>
      
    </body>
  </html>
  </file>
</xsl:template>
</xsl:stylesheet>
