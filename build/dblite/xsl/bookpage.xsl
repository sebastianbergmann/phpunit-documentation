<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                version="1.0"
>

<xsl:template name="bookpage">
  <file name="index.htm">
    <label>
      <xsl:call-template name="label"/>
    </label>
  <html>
    <xsl:value-of select="$newline"/>
    <head>
      <xsl:value-of select="$newline"/>
      <title>
        <xsl:value-of select="/book/title"/>
      </title>

    </head>
    <body bgcolor="#ffffff">

      <!-- ======================================================= -->
      <!-- BOOK INFO PARAGRAPH -->

      <p class="bookinfo">
        <font size="-1">
          <xsl:text>by </xsl:text>
          <xsl:call-template name="authors"/>
          <br/>
          <xsl:text>ISBN </xsl:text>
          <xsl:value-of select="/book/bookinfo/isbn"/>
          <br/>
          <xsl:value-of select="/book/bookinfo/edition"/>
          <xsl:text>, published </xsl:text>
          <xsl:value-of select="/book/bookinfo/pubdate"/>
          <xsl:text>.</xsl:text>
          <br/>
          <xsl:text>(See the </xsl:text>
          <a>
            <xsl:attribute name="href">
              <xsl:call-template name="book-url"/>
            </xsl:attribute>
            <xsl:text>catalog page</xsl:text> 
          </a>
          <xsl:text>for this book.)</xsl:text>
        </font>
      </p>
      <xsl:value-of select="$newline"/>


      <!-- ======================================================= -->
      <!-- SEARCH PARAGRAPH -->

      <p>
        <a href="jobjects/fsearch.htm">Search</a> 
        <xsl:text> the text of </xsl:text>
        <i>
          <xsl:value-of select="/book/title"/>
        </i>
        <xsl:text>.</xsl:text>
      </p>
      <xsl:value-of select="$newline"/>


      <!-- ======================================================= -->
      <!-- TOC -->

      <h3 class="tochead">Table of Contents</h3>
      <xsl:value-of select="$newline"/>
      <xsl:call-template name="toc"/>
      <xsl:value-of select="$newline"/>

      <p>
        <font size="-1">
          <a href="copyrght.htm">
            <xsl:text>Copyright $$ENTITY-START$$copy; 2002</xsl:text>
          </a>
          <xsl:text> O'Reilly &amp; Associates. All rights reserved.</xsl:text>
        </font>
      </p>

    </body>
  </html>
  </file>

</xsl:template>
</xsl:stylesheet>
