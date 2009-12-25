<!-- This is a complex design with one page per section. For a simpler 
design with one page for whole chapter, use chapter2.xsl -->

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


      <!-- ======================================================= -->
      <!-- METADATA -->

      <meta name="DC.Creator">
        <xsl:attribute name="content">
           <xsl:call-template name="authors"/>
        </xsl:attribute>
      </meta>
      <meta name="DC.Format" content="text/xml" scheme="MIME"/>
      <meta name="DC.Language" content="en-US"/>
      <meta name="DC.Publisher" content="O'Reilly &amp; Associates, Inc."/>
      <meta name="DC.Source" scheme="ISBN">
        <xsl:attribute name="content">
           <xsl:call-template name="isbn"/>
        </xsl:attribute>
      </meta>
      <meta name="DC.Subject.Keyword">
        <xsl:attribute name="content">
           <xsl:text>stuff</xsl:text>
        </xsl:attribute>
      </meta>
      <meta name="DC.Title">
        <xsl:attribute name="content">
           <xsl:value-of select="/book/title"/>
        </xsl:attribute>
      </meta>
      <meta name="DC.Type" content="Text.Monograph"/>
      <xsl:value-of select="$dblnewline"/>
    </head>
    <body bgcolor="#ffffff">
    <xsl:value-of select="$dblnewline"/>


      <!-- ======================================================= -->
      <!-- TOP BANNER -->

        <img src="gifs/smbanner.gif" usemap="#banner-map" 
                  border="0" alt="Book Home"/>
      <map name="banner-map">
        <area shape="rect" coords="1,-2,616,66" href="index.htm"
              alt="Mac OS X for Unix Geeks"/> 
        <area shape="rect" coords="629,-11,726,25"
              href="jobjects/fsearch.htm" alt="Search this book"/>
      </map>
      <xsl:value-of select="$dblnewline"/>


      <!-- ======================================================= -->
      <!-- TOP NAV BAR -->

      <div class="navbar">
        <table width="684" border="0">
          <tr>
            <td align="left" valign="top" width="228">
              <a href="$prev$">
                <img src="../gifs/txtpreva.gif" alt="Previous" border="0"/>
              </a>
            </td>
            <td align="center" valign="top" width="228">
            </td>
            <td align="right" valign="top" width="228">
              <a href="$next$">
                <img src="../gifs/txtnexta.gif" alt="Next" border="0"/>
              </a>
            </td>
          </tr>
        </table>
      </div>
      <xsl:value-of select="$newline"/>
      <xsl:value-of select="$dblnewline"/>


      <!-- ======================================================= -->
      <!-- CONTENT UP TO FIRST SECTION -->

      <xsl:apply-templates select="title"/>
      <xsl:choose>
        <xsl:when test="self::part">
          <xsl:apply-templates select="partintro"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:apply-templates select="*[not(self::sect1) and not(self::title)]"/>
          <xsl:apply-templates select="sect1[not(preceding-sibling::sect1)]"/>
        </xsl:otherwise>
     </xsl:choose>
      

      <!-- ======================================================= -->
      <!-- BOTTOM NAV BAR -->

      <xsl:value-of select="$dblnewline"/>
      <hr width="684" align="left"/>
      <xsl:value-of select="$newline"/>
      <div class="navbar">
        <table width="684" border="0">
          <tr>
            <td align="left" valign="top" width="228">
              <a href="$prev$">
                <img src="../gifs/txtpreva.gif" alt="Previous" border="0"/>
              </a>
            </td>
            <td align="center" valign="top" width="228">
              <a href="index.htm">
                <img src="../gifs/txthome.gif" alt="Home" border="0"/>
              </a>
            </td>
            <td align="right" valign="top" width="228">
              <a href="$next$">
                <img src="../gifs/txtnexta.gif" alt="Next" border="0"/>
              </a>
            </td>
          </tr>
          <tr>
            <td align="left" valign="top" width="228">
              <insertdata>
                <xsl:text>prev_label</xsl:text>
              </insertdata>
            </td>
            <td align="center" valign="top" width="228">
              <a href="index/index.htm">
                <img src="../gifs/index.gif" alt="Book Index" border="0"/>
              </a>
            </td>
            <td align="right" valign="top" width="228">
              <insertdata>
                <xsl:text>next_label</xsl:text>
              </insertdata>
            </td>
          </tr>
        </table>
      </div>
      <xsl:value-of select="$newline"/>
      <hr width="684" align="left"/>
      <xsl:value-of select="$dblnewline"/>


      <!-- ======================================================= -->
      <!-- LIBRARY NAV BAR -->

      <img src="../gifs/navbar.gif" usemap="#library-map" 
           border="0" alt="Library Navigation Links"/>
      <xsl:value-of select="$newline"/>
      <p>
        <font size="-1">
          <a href="copyrght.htm">
            <xsl:text>Copyright $$ENTITY-START$$copy; 2002</xsl:text>
          </a>
          <xsl:text> O'Reilly &amp; Associates. All rights reserved.</xsl:text>
        </font>
      </p>

      <xsl:value-of select="$dblnewline"/>
      <map name="library-map">
**REPLACE WITH MAP FILE**
      </map>
      <xsl:value-of select="$dblnewline"/>
    </body>
  </html>
  </file>


  <!-- ======================================================= -->
  <!-- REST OF CHAPTER -->

  <xsl:choose>
    <xsl:when test="self::part">
      <xsl:apply-templates select="*[not(self::partintro) and
			             not(self::title)]"/>
    </xsl:when>
    <xsl:otherwise>
      <xsl:apply-templates select="*[preceding-sibling::sect1]"/>
    </xsl:otherwise>
  </xsl:choose>

</xsl:template>
</xsl:stylesheet>
