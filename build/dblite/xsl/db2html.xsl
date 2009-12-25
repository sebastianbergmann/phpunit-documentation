<?xml version="1.0"?>

<!--
========================================================================
XSLT Stylesheet to convert DocBook XML into HTML
Copyright 2000 O'Reilly and Associates
$Id: db2html.xsl,v 1.1.1.1 2002/03/26 20:08:22 eray Exp $

Function: Converts DocBook books into formatted HTML files for easy
  viewing. 
Input: DocBook Lite XML 
Output: HTML files
========================================================================
-->



<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:xt="http://www.jclark.com/xt"
                extension-element-prefixes="xt"
		version="1.0">


<!-- 
TO DO:
======
bibliography as toplevel item
metadata date, identifier, keywords
multiple prefaces
-->


<xsl:strip-space elements="comment emphasis literal para quote"/>

<xsl:variable name="newline">
<xsl:text>
</xsl:text>
</xsl:variable>

<xsl:variable name="dblnewline">
<xsl:text>

</xsl:text>
</xsl:variable>

<xsl:template match="/">
 <xsl:apply-templates/>
</xsl:template>



<!--
========================================================================
                          HIERARCHICAL ELEMENTS
========================================================================
-->



<!--
match: book
===========
This template is the outermost container for the document.
It sets up a book file (index.htm) and front matter files 
(copyrght.htm, colophon.htm).

-->
<xsl:template match="book">
  <xt:document href="html/index.htm" method="html">
    <xsl:fallback>Error while creating file.</xsl:fallback>
    <html>
      <head>
        <title>
          <xsl:value-of select="title"/>
        </title>
        <link rel="stylesheet" type="text/css" href="../style/style1.css"/>
      </head>
      <body>

        <img src="gifs/banner.gif"/>
        <h1 class="book"><xsl:value-of select="title"/></h1>

        <!-- Book info -->

        <p class="bookinfo">
          <xsl:text>by </xsl:text>
          <xsl:call-template name="author"/>
          <br/>
          <xsl:text>ISBN </xsl:text>
          <xsl:call-template name="isbn"/>
          <br/>
          <xsl:call-template name="edition"/>
          <xsl:text>, </xsl:text>
          <xsl:text>published </xsl:text>
          <xsl:call-template name="pubdate"/>
          <xsl:text>.</xsl:text>
          <br/>
          <xsl:text>(See the </xsl:text>
          <a>
            <xsl:attribute name="href">
              <xsl:text>http://www.oreilly.com/catalog/</xsl:text>
              <xsl:call-template name="nickname"/>
            </xsl:attribute>
            <xsl:text>catalog page</xsl:text>
          </a>
          <xsl:text> for this book.)</xsl:text>
        </p>

        <!-- Search -->

        <p>
          <a href="jobjects/fsearch.htm">Search</a>
          <xsl:text> the text of </xsl:text>
          <i>
            <xsl:value-of select="title"/>
          </i>
          <xsl:text>.</xsl:text>
        </p>

        <!-- Index -->

        <h3 class="tochead">Index</h3>
        <xsl:call-template name="index-links"/>

        <!-- TOC -->

        <h3 class="tochead">Table of Contents</h3>
        <xsl:call-template name="toc"/>

        <!-- Footer -->

        <hr width="515" align="left"/>
        <xsl:comment>LIBRARY-NAV-BAR</xsl:comment>
        <xsl:call-template name="copyright"/>

      </body>
    </html>
    <xsl:apply-templates select="copyrightpg"/>
    <xsl:apply-templates select="colophon"/>
    <xsl:apply-templates select="preface | chapter | appendix | part"/>
    <xsl:call-template name="index-main-page"/>
  </xt:document>
</xsl:template>


<!--
match: appendix
===============
Creates a file for an appendix and its first section, of the form
"appX_01.htm" where X is the appendix letter.

-->
<xsl:template match="appendix">
  <xsl:variable name="app">
    <xsl:number value="@number" format="a"/>
  </xsl:variable>
  <xt:document href="app{$app}_01.htm" method="html">
    <xsl:fallback>Error while creating file.</xsl:fallback>
    <xsl:call-template name="file"/>
  </xt:document>
</xsl:template>


<!--
match: chapter
==============
Creates a file for a chapter and its first section, of the form
"chXX_01.htm" where XX is the number of the chapter (01, 02, etc.).

-->
<xsl:template match="chapter">
  <xsl:variable name="chap">
    <xsl:number value="@number" format="01"/>
  </xsl:variable>
  <xt:document href="ch{$chap}_01.htm" method="html">
    <xsl:fallback>Error while creating file.</xsl:fallback>
    <xsl:call-template name="file"/>
  </xt:document>
</xsl:template>


<!--
match: part
===========
Creates a file for the part page, containing its opening information,
of the form "partX.htm" where X is the part number.

-->
<xsl:template match="part">
  <xt:document href="part{@number}.htm" method="html">
    <xsl:fallback>Error while creating file.</xsl:fallback>
    <xsl:call-template name="file"/>
  </xt:document>
</xsl:template>


<!--
match: preface
==============
Creates a file for a preface and its first section, "ch00_01.htm".

-->
<xsl:template match="preface">
  <xt:document href="ch00_01.htm" method="html">
    <xsl:fallback>Error while creating file.</xsl:fallback>
    <xsl:call-template name="file"/>
  </xt:document>
</xsl:template>


<!--
match: glossary
===============
Creates a file for a glossary, "gloss.htm".

-->
<xsl:template match="glossary">
  <xt:document href="gloss.htm" method="html">
    <xsl:fallback>Error while creating file.</xsl:fallback>
    <xsl:call-template name="file"/>
  </xt:document>
</xsl:template>


<!--
match: appendix/sect1
=====================
If this is the first section, append contents to appendix file, 
otherwise create new file of the form "appX_YY.htm", where X is the 
appendix letter and YY is the number of the section (02, 03, etc.).

-->
<xsl:template match="appendix/sect1">
  <xsl:variable name="app">
    <xsl:number value="substring-before(@number,'.')" format="a"/>
  </xsl:variable>
  <xsl:variable name="sect">
    <xsl:number value="substring-after(@number,'.')" format="01"/>
  </xsl:variable>
  <xsl:choose>
    <xsl:when test="$sect>1">
      <xt:document href="app{$app}_{string($sect)}.htm" method="html">
        <xsl:fallback>Error while creating file.</xsl:fallback>
        <xsl:call-template name="file"/>
      </xt:document>
    </xsl:when>
    <xsl:otherwise>
      <xsl:apply-templates/>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>


<!--
match: chapter/sect1
=====================
If this is the first section, append contents to chapter file,
otherwise create new file of the form "chXX_YY.htm", where XX is the
chapter number (01, 02, etc.) and YY is the number of the section (02,
03, etc.).

-->
<xsl:template match="chapter/sect1">
  <xsl:variable name="chap">
    <xsl:number value="substring-before(@number,'.')" format="01"/>
  </xsl:variable>
  <xsl:variable name="sect">
    <xsl:number value="substring-after(@number,'.')" format="01"/>
  </xsl:variable>
  <xsl:choose>
    <xsl:when test="$sect>1">
      <xt:document href="ch{string($chap)}_{string($sect)}.htm" method="html">
        <xsl:fallback>Error while creating file.</xsl:fallback>
        <xsl:call-template name="file"/>
      </xt:document>
    </xsl:when>
    <xsl:otherwise>
      <xsl:apply-templates/>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>


<!--
match: preface/sect1
=====================
If this is the first section, append contents to chapter file,
otherwise create new file of the form "ch00_XX.htm", where XX is the
number of the section (02, 03, etc.).

-->
<xsl:template match="preface/sect1">
  <xsl:variable name="sect">
    <xsl:number value="number(substring-after(@number,'.'))" format="01"/>
  </xsl:variable>
  <xsl:choose>
    <xsl:when test="$sect>1">
      <xt:document href="ch00_{string($sect)}.htm" method="html">
        <xsl:fallback>Error while creating file.</xsl:fallback>
        <xsl:call-template name="file"/>
      </xt:document>
    </xsl:when>
    <xsl:otherwise>
      <xsl:apply-templates/>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>


<!--
match: sect2, sect3, sect4
==========================
Create an anchor for linking, then process the contents.

-->
<xsl:template match="sect2|sect3|sect4">
  <xsl:call-template name="drop-anchor"/>
  <xsl:apply-templates/>
</xsl:template>


<!--
drop-anchor
===========
Place an anchor just before the object if it has an ID attribute.

-->
<xsl:template name="drop-anchor">
  <xsl:if test="@id">
    <a>
      <xsl:attribute name="name">
        <xsl:value-of select="@id"/>
      </xsl:attribute>
    </a>
  </xsl:if>
</xsl:template>



<!--
========================================================================
                              HEADS
========================================================================
-->



<xsl:template match="book/title">
  <h1 class="book"><xsl:apply-templates/></h1>
</xsl:template>


<xsl:template match="appendix/title">
  <xsl:variable name="role" select="../@role"/>
  <h1 class="chapter">
    <xsl:text>Appendix </xsl:text>
    <xsl:if test="../@number">
      <xsl:number value="../@number" format="A"/>
    </xsl:if>
    <xsl:text>.  </xsl:text>
    <xsl:apply-templates/>
  </h1>
  <xsl:if test="not($role='notoc') and count(following-sibling::sect1)>0">
    <xsl:call-template name="mini-toc"/>
  </xsl:if>
</xsl:template>


<xsl:template match="chapter/title">
  <xsl:variable name="role" select="../@role"/>
  <h1 class="chapter">
    <xsl:text>Chapter </xsl:text>
    <xsl:value-of select="../@number"/>
    <xsl:text>.  </xsl:text>
    <xsl:apply-templates/>
  </h1>
  <xsl:if test="not($role='notoc') and count(following-sibling::sect1)>0">
    <xsl:call-template name="mini-toc"/>
  </xsl:if>
</xsl:template>


<xsl:template match="part/title">
  <h1 class="chapter">
    <xsl:text>Part </xsl:text>
    <xsl:value-of select="../@number"/>
    <xsl:text>.  </xsl:text>
    <xsl:apply-templates/>
  </h1>
</xsl:template>


<xsl:template match="preface/title">
  <h1 class="chapter">Preface</h1>
</xsl:template>


<xsl:template match="sect1/title">
  <h2 class="sect1">
    <xsl:choose>
      <xsl:when test="ancestor::appendix">
        <xsl:number value="substring-before(../@number,'.')" format="A"/>
        <xsl:text>.</xsl:text>
        <xsl:value-of select="substring-after(../@number,'.')"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="../@number"/>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:text>. </xsl:text>
    <xsl:apply-templates/>
  </h2>
</xsl:template>


<xsl:template match="sect2/title">
  <h3 class="sect2">
    <xsl:choose>
      <xsl:when test="ancestor::appendix">
        <xsl:number value="substring-before(../@number,'.')" format="A"/>
        <xsl:text>.</xsl:text>
        <xsl:value-of select="substring-after(../@number,'.')"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="../@number"/>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:text>. </xsl:text>
    <xsl:apply-templates/>
  </h3>
</xsl:template>


<xsl:template match="sect3/title">
  <h3 class="sect3">
    <xsl:choose>
      <xsl:when test="ancestor::appendix">
        <xsl:number value="substring-before(../@number,'.')" format="A"/>
        <xsl:text>.</xsl:text>
        <xsl:value-of select="substring-after(../@number,'.')"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="../@number"/>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:text>. </xsl:text>
    <xsl:apply-templates/>
  </h3>
</xsl:template>


<xsl:template match="sect4/title">
  <h3 class="sect4">
    <xsl:choose>
      <xsl:when test="ancestor::appendix">
        <xsl:number value="substring-before(../@number,'.')" format="A"/>
        <xsl:text>.</xsl:text>
        <xsl:value-of select="substring-after(../@number,'.')"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="../@number"/>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:text>. </xsl:text>
    <xsl:apply-templates/>
  </h3>
</xsl:template>


<xsl:template match="example/title">
  <h4 class="objtitle">
    <xsl:text>Example </xsl:text>
    <xsl:choose>
      <xsl:when test="ancestor::appendix">
        <xsl:number value="substring-before(../@number,'.')" format="A"/>
        <xsl:text>-</xsl:text>
        <xsl:value-of select="substring-after(../@number,'.')"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="../@number"/>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:text>. </xsl:text>
    <xsl:apply-templates/>
  </h4>
</xsl:template>


<xsl:template match="figure/title">
  <h4 class="objtitle">
    <xsl:text>Figure </xsl:text>
    <xsl:choose>
      <xsl:when test="ancestor::appendix">
        <xsl:number value="substring-before(../@number,'.')" format="A"/>
        <xsl:text>-</xsl:text>
        <xsl:value-of select="substring-after(../@number,'.')"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="../@number"/>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:text>. </xsl:text>
    <xsl:apply-templates/>
  </h4>
</xsl:template>


<xsl:template match="table/title">
  <h4 class="objtitle">
    <xsl:text>Table </xsl:text>
    <xsl:choose>
      <xsl:when test="ancestor::appendix">
        <xsl:number value="substring-before(../@number,'.')" format="A"/>
        <xsl:text>-</xsl:text>
        <xsl:value-of select="substring-after(../@number,'.')"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="../@number"/>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:text>. </xsl:text>
    <xsl:apply-templates/>
  </h4>
</xsl:template>


<xsl:template match="title">
  <h4 class="objtitle">
    <xsl:apply-templates/>
  </h4>
</xsl:template>



<!--
========================================================================
                          BLOCK ELEMENTS
========================================================================
-->



<xsl:template match="para">
  <p>
    <xsl:apply-templates/>
  </p>
  <xsl:if test="not(ancestor::table | ancestor::sidebar)">
    <xsl:for-each select=".//footnote | .//footnoteref">
      <blockquote class="footnote">
        <xsl:apply-templates/>
      </blockquote>
    </xsl:for-each>
  </xsl:if>
</xsl:template>


<xsl:template match="programlisting|screen|literallayout">
  <blockquote>
    <pre class="programlisting">
      <xsl:apply-templates/>
    </pre>
  </blockquote>
</xsl:template>


<xsl:template match="example">
  <xsl:call-template name="drop-anchor"/>
  <div class="example">
    <xsl:apply-templates/>
  </div>
</xsl:template>


<xsl:template match="figure">
  <xsl:call-template name="drop-anchor"/>
  <div class="figure">
    <xsl:apply-templates select="graphic"/>
  </div>
  <xsl:apply-templates select="title"/>
</xsl:template>


<xsl:template match="figure">
  <xsl:call-template name="drop-anchor"/>
  <div class="figure">
    <xsl:apply-templates select="graphic"/>
  </div>
  <xsl:apply-templates select="title"/>
</xsl:template>


<xsl:template match="sidebar">
  <xsl:call-template name="drop-anchor"/>
  <div class="sidebar">
    <xsl:apply-templates/>
    <xsl:for-each select=".//footnote | .//footnoteref">
      <blockquote class="footnote">
        <xsl:apply-templates/>
      </blockquote>
    </xsl:for-each>
  </div>
</xsl:template>


<xsl:template match="caution|important|note|tip|warning">
  <xsl:call-template name="drop-anchor"/>
  <blockquote class="note">
    <xsl:choose>
      <xsl:when test="title">
        <xsl:apply-templates select="title"/>
      </xsl:when>
      <xsl:otherwise>
        <h4 class="objtitle">
          <xsl:choose>
            <xsl:when test="self::caution">
              <xsl:text>CAUTION</xsl:text>
            </xsl:when>
            <xsl:when test="self::important">
              <xsl:text>IMPORTANT</xsl:text>
            </xsl:when>
            <xsl:when test="self::note">
              <xsl:text>NOTE</xsl:text>
            </xsl:when>
            <xsl:when test="self::tip">
              <xsl:text>TIP</xsl:text>
            </xsl:when>
            <xsl:when test="self::warning">
              <xsl:text>WARNING</xsl:text>
            </xsl:when>
          </xsl:choose>
        </h4>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates/>
  </blockquote>
</xsl:template>



<!--
========================================================================
                            FOOTNOTES
========================================================================
-->



<xsl:template match="footnote">
  <a>
    <xsl:attribute name="href">
      <xsl:text>#FOOTNOTE-</xsl:text>
      <xsl:value-of select="@number"/>
    </xsl:attribute>
    <xsl:text>[</xsl:text>
    <xsl:value-of select="@number"/>
    <xsl:text>]</xsl:text>
  </a>
</xsl:template>


<xsl:template match="footnote/para">
  <a>
    <xsl:attribute name="name">
      <xsl:text>FOOTNOTE-</xsl:text>
      <xsl:value-of select="../@number"/>
    </xsl:attribute>
  </a>
  <p>
    <xsl:if test="count(preceding-sibling::para)=0">
      <xsl:text>[</xsl:text>
      <xsl:value-of select="../@number"/>
      <xsl:text>]</xsl:text>
    </xsl:if>
    <xsl:apply-templates/>
  </p>
</xsl:template>


<xsl:template match="footnoteref">
  <a>
    <xsl:attribute name="href">
      <xsl:text>#FOOTNOTE-</xsl:text>
      <xsl:value-of select="id(@linkend)/@number"/>
    </xsl:attribute>
    <xsl:text>[</xsl:text>
    <xsl:value-of select="id(@linkend)/@number"/>
    <xsl:text>]</xsl:text>
  </a>
</xsl:template>



<!--
========================================================================
                             XREFs
========================================================================
-->



<xsl:template match="xref">
  <xsl:variable name="ident">
    <xsl:value-of select="@linkend"/>
  </xsl:variable>

  <xsl:variable name="chaplevel">
    <xsl:choose>
      <xsl:when test="ancestor-or-self::appendix/@number">
        <xsl:number value="ancestor-or-self::appendix/@number" format="A"/>
      </xsl:when>
      <xsl:when test="ancestor-or-self::chapter">
        <xsl:value-of select="ancestor-or-self::chapter/@number"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:text>0</xsl:text>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:variable>

  <xsl:for-each select="//*[@id=$ident]">
    <a>
      <xsl:attribute name="href">
        <xsl:call-template name="filename"/>
        <xsl:if test="ancestor::appendix | 
                      ancestor::chapter |
                      ancestor::preface">
          <xsl:text>#</xsl:text>
          <xsl:value-of select="$ident"/>
        </xsl:if>
      </xsl:attribute>

      <xsl:choose>
        <xsl:when test="self::appendix/@number">
          <xsl:text>Appendix </xsl:text>
          <xsl:number value="@number" format="A"/>
          <xsl:text>, "</xsl:text>
          <xsl:value-of select="title"/>
          <xsl:text>"</xsl:text>
        </xsl:when>

        <xsl:when test="self::chapter/@number">
          <xsl:text>Chapter </xsl:text>
          <xsl:value-of select="@number"/>
          <xsl:text>, "</xsl:text>
          <xsl:value-of select="title"/>
          <xsl:text>"</xsl:text>
        </xsl:when>

        <xsl:when test="self::part/@number">
          <xsl:text>Part </xsl:text>
          <xsl:value-of select="@number"/>
          <xsl:text>, "</xsl:text>
          <xsl:value-of select="title"/>
          <xsl:text>"</xsl:text>
        </xsl:when>

        <xsl:when test="self::preface">
          <xsl:text>the Preface</xsl:text>
        </xsl:when>

        <xsl:when test="self::sect1 |
                        self::sect2 | 
                        self::sect3 |
                        self::sect4">
          <xsl:text>Section </xsl:text>
          <xsl:value-of select="$chaplevel"/>
          <xsl:text>.</xsl:text>
          <xsl:value-of select="substring-after(@number,'.')"/>
          <xsl:text>, "</xsl:text>
          <xsl:value-of select="title"/>
          <xsl:text>"</xsl:text>
        </xsl:when>

        <xsl:when test="self::figure">
          <xsl:text>Figure </xsl:text>
          <xsl:value-of select="$chaplevel"/>
          <xsl:text>-</xsl:text>
          <xsl:value-of select="substring-after(@number,'.')"/>
        </xsl:when>

        <xsl:when test="self::example">
          <xsl:text>Example </xsl:text>
          <xsl:value-of select="$chaplevel"/>
          <xsl:text>-</xsl:text>
          <xsl:value-of select="substring-after(@number,'.')"/>
        </xsl:when>

        <xsl:when test="self::refentry">
          <xsl:text>Reference </xsl:text>
          <xsl:value-of select="$chaplevel"/>
          <xsl:text>.</xsl:text>
          <xsl:value-of select="@number"/>
        </xsl:when>

        <xsl:when test="self::sidebar">
          <xsl:text>the sidebar "</xsl:text>
          <xsl:value-of select="title"/>
          <xsl:text>"</xsl:text>
        </xsl:when>

        <xsl:when test="self::table">
          <xsl:text>Table </xsl:text>
          <xsl:value-of select="$chaplevel"/>
          <xsl:text>-</xsl:text>
          <xsl:value-of select="substring-after(@number,'.')"/>
        </xsl:when>

        <xsl:otherwise>
          <xsl:text>{XREF}</xsl:text>
        </xsl:otherwise>

      </xsl:choose>
    </a>
  </xsl:for-each>
</xsl:template>


<!--
filename
========
Return the filename that contains the current node.

-->
<xsl:template name="filename">
  <xsl:choose>

    <!-- I am a chapter -->

    <xsl:when test="self::appendix/@number">
      <xsl:text>app</xsl:text>
      <xsl:number value="@number" format="a"/>
      <xsl:text>_01.htm</xsl:text>
    </xsl:when>

    <xsl:when test="self::chapter/@number">
      <xsl:text>ch</xsl:text>
      <xsl:number value="@number" format="01"/>
      <xsl:text>_01.htm</xsl:text>
    </xsl:when>

    <xsl:when test="self::part/@number">
      <xsl:text>part</xsl:text>
      <xsl:value-of select="@number"/>
      <xsl:text>.htm</xsl:text>
    </xsl:when>

    <xsl:when test="self::preface">ch00_01.htm</xsl:when>

    <!-- I am a sect1 -->

    <xsl:when test="parent::appendix and self::sect1/@number">
      <xsl:text>app</xsl:text>
      <xsl:number value="substring-before(@number,'.')" format="a"/>
      <xsl:text>_</xsl:text>
      <xsl:number value="substring-after(@number,'.')" format="01"/>
      <xsl:text>.htm</xsl:text>
    </xsl:when>

    <xsl:when test="parent::chapter and self::sect1/@number">
      <xsl:text>ch</xsl:text>
      <xsl:number value="substring-before(@number,'.')" format="01"/>
      <xsl:text>_</xsl:text>
      <xsl:number value="substring-after(@number,'.')" format="01"/>
      <xsl:text>.htm</xsl:text>
    </xsl:when>

    <xsl:when test="parent::preface and self::sect1/@number">
      <xsl:text>ch00_</xsl:text>
      <xsl:number value="substring-after(@number,'.')" format="01"/>
      <xsl:text>.htm</xsl:text>
    </xsl:when>

    <!-- I am inside a sect1 -->

    <xsl:when test="ancestor::appendix and ancestor::sect1/@number">
      <xsl:text>app</xsl:text>
      <xsl:number value="substring-before(ancestor::sect1/@number,'.')" 
        format="a"/>
      <xsl:text>_</xsl:text>
      <xsl:number value="substring-after(ancestor::sect1/@number,'.')"
          format="01"/>
      <xsl:text>.htm</xsl:text>
    </xsl:when>

    <xsl:when test="ancestor::chapter and ancestor::sect1/@number">
      <xsl:text>ch</xsl:text>
      <xsl:number value="substring-before(ancestor::sect1/@number,'.')"
        format="01"/>
      <xsl:text>_</xsl:text>
      <xsl:number value="substring-after(ancestor::sect1/@number,'.')"
          format="01"/>
      <xsl:text>.htm</xsl:text>
    </xsl:when>

    <xsl:when test="ancestor::preface and ancestor::sect1/@number">
      <xsl:text>ch00_</xsl:text>
      <xsl:number value="substring-after(ancestor::sect1/@number,'.')"
          format="01"/>
      <xsl:text>.htm</xsl:text>
    </xsl:when>

    <!-- I am inside something else -->

    <xsl:when test="ancestor::appendix/@number">
      <xsl:text>app</xsl:text>
      <xsl:number value="ancestor::appendix/@number" format="a"/>
      <xsl:text>_01.htm</xsl:text>
    </xsl:when>

    <xsl:when test="ancestor::chapter/@number">
      <xsl:text>ch</xsl:text>
      <xsl:number value="ancestor::chapter/@number" format="01"/>
      <xsl:text>_01.htm</xsl:text>
    </xsl:when>

    <xsl:when test="ancestor::preface">
      <xsl:text>ch00_01.htm</xsl:text>
    </xsl:when>

    <xsl:when test="ancestor::part/@number">
      <xsl:text>part</xsl:text>
      <xsl:value-of select="ancestor::part/@number"/>
      <xsl:text>.htm</xsl:text>
    </xsl:when>

    <xsl:otherwise>error</xsl:otherwise>
  </xsl:choose>
</xsl:template>



<!--
========================================================================
                             LISTS
========================================================================
-->



<xsl:template match="calloutlist">
  <blockquote class="calloutlist">
    <xsl:apply-templates/>
  </blockquote>
</xsl:template>


<xsl:template match="callout/para">
  <p>
    <xsl:value-of select="id(../@idref)"/>
    <xsl:text>. </xsl:text>
    <xsl:apply-templates/>
  </p>
</xsl:template>


<xsl:template match="co">
  <b>
    <xsl:text>(</xsl:text>
    <xsl:value-of select="."/>
    <xsl:text>)</xsl:text>
  </b>
</xsl:template>


<xsl:template match="member">
  <p><xsl:apply-templates/></p>
</xsl:template>


<xsl:template match="orderedlist">
  <ol><xsl:apply-templates/></ol>
</xsl:template>


<xsl:template match="orderedlist/listitem">
  <li><xsl:apply-templates/></li>
</xsl:template>


<xsl:template match="itemizedlist">
  <ul><xsl:apply-templates/></ul>
</xsl:template>


<xsl:template match="itemizedlist/listitem">
  <li><xsl:apply-templates/></li>
</xsl:template>


<xsl:template match="simplelist">
  <blockquote class="simplelist">
    <xsl:apply-templates/>
  </blockquote>
</xsl:template>


<xsl:template match="variablelist">
  <dl><xsl:apply-templates/></dl>
</xsl:template>


<xsl:template match="varlistentry">
  <xsl:apply-templates/>
</xsl:template>


<xsl:template match="varlistentry/term">
  <dt><b><xsl:apply-templates/></b></dt>
</xsl:template>


<xsl:template match="varlistentry/listitem">
  <dd><xsl:apply-templates/></dd>
</xsl:template>


<xsl:template match="glossentry">
  <dl>
    <xsl:apply-templates/>
  </dl>
</xsl:template>


<xsl:template match="glossterm">
  <dt>
    <xsl:apply-templates/>
  </dt>
</xsl:template>


<xsl:template match="glossdef">
  <dd>
    <xsl:apply-templates/>
  </dd>
</xsl:template>



<!--
========================================================================
                            TABLES
========================================================================
-->



<!--
match: table, informaltable
===========================
Convert an XML table into an HTML table.  The DocBook table has lots
more layers, so most of this is unwrapping it.

-->
<xsl:template match="table|informaltable">
  <xsl:call-template name="drop-anchor"/>
  <xsl:if test="self::table">
    <xsl:apply-templates select="title"/>
  </xsl:if>
  <table border="1">
    <xsl:apply-templates select="tgroup"/>
  </table>
  <xsl:for-each select=".//footnote | .//footnoteref">
    <blockquote class="footnote">
      <xsl:apply-templates/>
    </blockquote>
  </xsl:for-each>
</xsl:template>


<xsl:template match="tgroup|thead|tbody">
  <xsl:apply-templates/>
</xsl:template>


<xsl:template match="row">
  <tr><xsl:apply-templates/></tr>
</xsl:template>


<xsl:template match="thead//entry">
  <th><xsl:apply-templates/></th>
</xsl:template>


<xsl:template match="entry">
  <td>
    <xsl:if test="@spanname">
      <xsl:attribute name="colspan">
        <xsl:call-template name="getspan">
          <xsl:with-param name="spanname">
            <xsl:value-of select="@spanname"/>
          </xsl:with-param>
        </xsl:call-template>
      </xsl:attribute>
    </xsl:if>
    <xsl:if test="@morerows">
      <xsl:attribute name="rowspan">
        <xsl:value-of select="@morerows"/>
      </xsl:attribute>
    </xsl:if>
    <xsl:apply-templates/>
  </td>
</xsl:template>


<xsl:template name="getspan">
  <xsl:param name="spanname" value="span"/>
  <xsl:variable name="colstart">
    <xsl:for-each select="ancestor::tgroup/spanspec[@spanname='$spanname']">
      <xsl:value-of select="@namest"/>
    </xsl:for-each>
  </xsl:variable>
  <xsl:variable name="colend">
    <xsl:for-each select="ancestor::tgroup/spanspec[@spanname='$spanname']">
      <xsl:value-of select="@nameend"/>
    </xsl:for-each>
  </xsl:variable>
  <xsl:variable name="colstartnum">
    <xsl:for-each select="ancestor::tgroup/colspec[@colname='$colstart']">
      <xsl:value-of select="@colnum"/>
    </xsl:for-each>
  </xsl:variable>
  <xsl:variable name="colendnum">
    <xsl:for-each select="ancestor::tgroup/colspec[@colname='$colend']">
      <xsl:value-of select="@colnum"/>
    </xsl:for-each>
  </xsl:variable>
  <xsl:value-of select="$colendnum - $colstartnum"/>
</xsl:template>



<!--
========================================================================
                          INLINE ELEMENTS
========================================================================
-->



<xsl:template match="abbrev">
  <span class="abbrev"><xsl:apply-templates/></span>
</xsl:template>


<xsl:template match="accel">
  <span class="accel"><xsl:apply-templates/></span>
</xsl:template>


<xsl:template match="acronym">
  <span class="acronym"><xsl:apply-templates/></span>
</xsl:template>


<xsl:template match="action">
  <span class="action"><xsl:apply-templates/></span>
</xsl:template>


<xsl:template match="application">
  <em class="application"><xsl:apply-templates/></em>
</xsl:template>


<xsl:template match="citation">
  <em class="citation"><xsl:apply-templates/></em>
</xsl:template>


<xsl:template match="citetitle">
  <em class="citetitle"><xsl:apply-templates/></em>
</xsl:template>


<xsl:template match="classname">
  <tt class="classname"><xsl:apply-templates/></tt>
</xsl:template>


<xsl:template match="command">
  <i class="command"><xsl:apply-templates/></i>
</xsl:template>


<xsl:template match="comment">
  <em class="comment"><xsl:apply-templates/></em>
</xsl:template>


<xsl:template match="computeroutput">
  <tt class="computeroutput"><xsl:apply-templates/></tt>
</xsl:template>


<xsl:template match="email">
  <em class="email"><xsl:apply-templates/></em>
</xsl:template>


<xsl:template match="emphasis">
  <em class="emphasis"><xsl:apply-templates/></em>
</xsl:template>

<xsl:template match="emphasis[@role='bold']">
  <b class="emphasis-bold"><xsl:apply-templates/></b>
</xsl:template>

<xsl:template match="emphasis[@role='underline']">
  <u class="emphasis-underline"><xsl:apply-templates/></u>
</xsl:template>


<xsl:template match="envar">
  <tt class="envar"><xsl:apply-templates/></tt>
</xsl:template>


<xsl:template match="filename">
  <em class="filename"><xsl:apply-templates/></em>
</xsl:template>


<xsl:template match="firstterm">
  <em class="firstterm"><xsl:apply-templates/></em>
</xsl:template>


<xsl:template match="foreignphrase">
  <em class="foreignphrase"><xsl:apply-templates/></em>
</xsl:template>


<xsl:template match="function">
  <tt class="function"><xsl:apply-templates/></tt>
</xsl:template>


<xsl:template match="guibutton">
  <span class="gui"><xsl:apply-templates/></span>
</xsl:template>


<xsl:template match="guimenu">
  <span class="gui"><xsl:apply-templates/></span>
</xsl:template>


<xsl:template match="guimenuitem">
  <span class="gui"><xsl:apply-templates/></span>
</xsl:template>


<xsl:template match="keycap">
  <span class="keycap"><xsl:apply-templates/></span>
</xsl:template>


<xsl:template match="keysym">
  <span class="keysym"><xsl:apply-templates/></span>
</xsl:template>


<xsl:template match="literal">
  <tt class="literal"><xsl:apply-templates/></tt>
</xsl:template>


<xsl:template match="option">
  <span class="option"><xsl:apply-templates/></span>
</xsl:template>


<xsl:template match="optional">
  <span class="optional"><xsl:apply-templates/></span>
</xsl:template>


<xsl:template match="parameter">
  <span class="parameter"><xsl:apply-templates/></span>
</xsl:template>


<xsl:template match="prompt">
  <span class="prompt"><xsl:apply-templates/></span>
</xsl:template>


<xsl:template match="quote">
  <xsl:text>"</xsl:text>
  <xsl:apply-templates/>
  <xsl:text>"</xsl:text>
</xsl:template>


<xsl:template match="replaceable">
  <em class="replaceable"><xsl:apply-templates/></em>
</xsl:template>


<xsl:template match="returnvalue">
  <tt class="returnvalue"><xsl:apply-templates/></tt>
</xsl:template>


<xsl:template match="sgmltag[@class='attribute']">
  <tt class="sgmltag-attribute"><xsl:apply-templates/></tt>
</xsl:template>

<xsl:template match="sgmltag[@class='attvalue']">
  <tt class="sgmltag-attvalue">
    <xsl:text>"</xsl:text>
    <xsl:apply-templates/>
    <xsl:text>"</xsl:text>
  </tt>
</xsl:template>

<xsl:template match="sgmltag[@class='comment']">
  <tt class="sgmltag-comment">
    <xsl:text>&lt;!-- </xsl:text>
    <xsl:apply-templates/>
    <xsl:text> --&gt;</xsl:text>
  </tt>
</xsl:template>

<xsl:template match="sgmltag[@class='declaration']">
  <tt class="sgmltag-declaration">
    <xsl:text>&lt;!</xsl:text>
    <xsl:apply-templates/>
    <xsl:text>&gt;</xsl:text>
  </tt>
</xsl:template>

<xsl:template match="sgmltag[@class='element']">
  <tt class="sgmltag-element">
  <xsl:text>&lt;</xsl:text>
  <xsl:apply-templates/>
  <xsl:text>&gt;</xsl:text>
  </tt>
</xsl:template>

<xsl:template match="sgmltag[@class='emptyelement']">
  <tt class="sgmltag-emptyelement">
    <xsl:text>&lt;</xsl:text>
    <xsl:apply-templates/>
    <xsl:text>/&gt;</xsl:text>
  </tt>
</xsl:template>

<xsl:template match="sgmltag[@class='endtag']">
  <tt class="sgmltag-endtag">
    <xsl:text>&lt;/</xsl:text>
    <xsl:apply-templates/>
    <xsl:text>&gt;</xsl:text>
  </tt>
</xsl:template>

<xsl:template match="sgmltag[@class='genentity']">
  <tt class="sgmltag-genentity">
    <xsl:text>&amp;</xsl:text>
    <xsl:apply-templates/>
    <xsl:text>;</xsl:text>
  </tt>
</xsl:template>

<xsl:template match="sgmltag[@class='paramentity']">
  <tt class="sgmltag-attvalue">
    <xsl:text>%</xsl:text>
    <xsl:apply-templates/>
    <xsl:text>;</xsl:text>
  </tt>
</xsl:template>

<xsl:template match="sgmltag[@class='starttag']">
  <tt class="sgmltag-starttag">
    <xsl:text>&lt;</xsl:text>
    <xsl:apply-templates/>
    <xsl:text>&gt;</xsl:text>
  </tt>
</xsl:template>

<xsl:template match="sgmltag">
  <tt class="sgmltag-element">
  <xsl:text>&lt;</xsl:text>
  <xsl:apply-templates/>
  <xsl:text>&gt;</xsl:text>
  </tt>
</xsl:template>


<xsl:template match="structfield">
  <tt class="structfield"><xsl:apply-templates/></tt>
</xsl:template>


<xsl:template match="subscript">
  <sub class="subscript"><xsl:apply-templates/></sub>
</xsl:template>


<xsl:template match="superscript">
  <sup class="superscript"><xsl:apply-templates/></sup>
</xsl:template>


<xsl:template match="symbol">
  <span class="symbol"><xsl:apply-templates/></span>
</xsl:template>


<xsl:template match="systemitem[@role='url']">
  <a>
    <xsl:attribute name="href">
      <xsl:value-of select="."/>
    </xsl:attribute>
    <xsl:value-of select="."/>
  </a>
</xsl:template>


<xsl:template match="type">
  <xsl:apply-templates/>
</xsl:template>


<xsl:template match="userinput">
  <tt class="userinput"><b><xsl:apply-templates/></b></tt>
</xsl:template>


<xsl:template match="wordasword">
  <em class="wordasword"><xsl:apply-templates/></em>
</xsl:template>



<!--
========================================================================
                          REFENTRYS
========================================================================
-->


<xsl:template match="refentry">
  <xsl:apply-templates select=".//indexterm"/>
  <div class="refentry">
    <table width="515" border="0" cellpadding="5">
      <tr>
        <td align="left">
          <font size="+1"><b><i>
            <xsl:value-of select="refnamediv/refname"/>
          </i></b></font>
        </td>
        <td align="right">
          <i><xsl:value-of select="refnamediv/refpurpose"/></i>
        </td>
      </tr>
    </table>
    <hr width="515" size="3" noshade="true" align="left" color="black"/>
    <table width="515" border="0" cellpadding="5">
      <tr>
        <td align="left">
          <xsl:apply-templates select="refsynopsisdiv/synopsis"/>
	  <xsl:apply-templates select="refmeta/refmiscinfo[1]"/>
        </td>
        <td align="right">
	  <xsl:apply-templates select="refmeta/refmiscinfo[2]"/>
        </td>
      </tr>
    </table>
    <xsl:apply-templates select="refsynopsisdiv/para"/>
    <xsl:apply-templates select="refsect1"/>
  </div>
</xsl:template>

<xsl:template match="refentry[@role='java']">
  <xsl:apply-templates select=".//indexterm"/>
  <div class="refentry">
    <table width="515" border="0" cellpadding="5">
      <tr>
        <td align="left">
          <font size="+1"><b>
            <xsl:value-of select="refnamediv/refname"/>
          </b></font>
        </td>
        <td align="right">
          <font size="+1"><b>
            <xsl:value-of select="refmeta/refmiscinfo[@class='version']"/>
          </b></font>
        </td>
      </tr>
    </table>
    <hr width="515" size="4" noshade="true" align="left" color="black"/>
    <table width="515" border="0" cellpadding="5">
      <tr>
        <td align="left">
          <font size="+1"><b>
            <xsl:value-of select="refmeta/refmiscinfo[@class='package']"/>
          </b></font>
        </td>
        <td align="right">
          <font size="+1"><b><i>
              <xsl:value-of select="refmeta/refmiscinfo[@class='flags']"/>
          </i></b></font>
        </td>
      </tr>
    </table>
    <xsl:apply-templates select="refsynopsisdiv | refsect1" mode="java"/>
  </div>
</xsl:template>


<xsl:template match="refmiscinfo">
  <tt>
    <b>
      <xsl:value-of select="@class"/>
      <xsl:text>: </xsl:text>
    </b>
    <xsl:apply-templates/>
  </tt>
</xsl:template>


<xsl:template match="refsynopsisdiv">
  <div class="refsynopsisdiv">
    <xsl:apply-templates/>
  </div>
</xsl:template>

<xsl:template match="refsynopsisdiv" mode="java">
  <div class="refsynopsisdiv">
    <table border="0">
      <xsl:apply-templates mode="java"/>
    </table>
  </div>
</xsl:template>


<xsl:template match="refsynopsisdiv/synopsis">
  <pre><xsl:apply-templates/></pre>
</xsl:template>


<xsl:template match="classsynopsis" mode="java">
  <tr>
    <td colspan="3">
      <xsl:value-of select="modifiers"/>
      <xsl:if test="@keyword='interface'">
        <xsl:text> interface </xsl:text>
      </xsl:if>
      <xsl:if test="@keyword='class'">
        <xsl:text> class </xsl:text>
      </xsl:if>
      <b class="classname">
        <xsl:value-of select="classname"/>
      </b>
      <xsl:text> </xsl:text>
      <xsl:apply-templates select="extends | implements"/>
      <xsl:text>{</xsl:text>
    </td>
  </tr>
  <xsl:apply-templates select="members"/>
  <tr>
    <td colspan="3">
      <xsl:text>}</xsl:text>
    </td>
  </tr>
</xsl:template>


<xsl:template match="extends">
  <xsl:text>extends </xsl:text>
  <xsl:apply-templates/>
  <xsl:text> </xsl:text>
</xsl:template>


<xsl:template match="implements">
  <xsl:text>implements </xsl:text>
  <xsl:apply-templates/>
  <xsl:text> </xsl:text>
</xsl:template>


<xsl:template match="link[classref]">
  <xsl:apply-templates/>
</xsl:template>


<xsl:template match="classref">
  <xsl:if test="@role='includePkg'">
    <xsl:value-of select="@package"/>
    <xsl:text>.</xsl:text>
  </xsl:if>
  <xsl:value-of select="@class"/>
  <xsl:if test="ancestor::refsynopsisdiv and
                (following-sibling::classref or
                 ../following-sibling::link/classref)">
    <xsl:text>, </xsl:text>
  </xsl:if>
</xsl:template>


<xsl:template match="members">
  <xsl:apply-templates/>
</xsl:template>


<xsl:template match="members/title">
  <tr>
    <td>
      <i class="members">
        <xsl:text>// </xsl:text>
      </i>
    </td>
    <td colspan="2">
      <i class="members">
        <xsl:apply-templates/>
      </i>
    </td>
  </tr>
</xsl:template>


<xsl:template match="funcprototype">
  <tr>
    <td width="10">
      <xsl:if test="@revision">
        <span class="java-revision">
          <xsl:value-of select="@revision"/>
        </span>
      </xsl:if>
    </td>
    <td align="left">
      <xsl:apply-templates select="funcdef"/>
      <xsl:if test="@role='method'">
        <xsl:text>(</xsl:text>
        <xsl:apply-templates select="paramdef"/>
        <xsl:text>)</xsl:text>
      </xsl:if>
      <xsl:if test="./throws">
        <xsl:text> throws </xsl:text>
        <xsl:apply-templates select="throws"/>
      </xsl:if>
      <xsl:text>;</xsl:text>
    </td>
    <td align="right">
      <i>
        <xsl:value-of select="@flags"/>
      </i>
    </td>
  </tr>
</xsl:template>


<xsl:template match="funcdef">
  <xsl:apply-templates select="modifiers"/>
  <xsl:text> </xsl:text>
  <xsl:if test="./type">
    <xsl:apply-templates select="type"/>
    <xsl:text> </xsl:text>
  </xsl:if>
  <xsl:apply-templates select="function"/>
</xsl:template>


<xsl:template match="refentry//function">
  <b class="function">
    <xsl:apply-templates/>
  </b>
  <xsl:text> </xsl:text>
</xsl:template>


<xsl:template match="paramdef[position()=last()]">
  <xsl:apply-templates select="type"/>
  <xsl:text> </xsl:text>
  <xsl:apply-templates select="parameter"/>
</xsl:template>


<xsl:template match="paramdef">
  <xsl:apply-templates/>
  <xsl:text>, </xsl:text>
</xsl:template>


<xsl:template match="throws[position()=last()]">
  <xsl:apply-templates/>
</xsl:template>


<xsl:template match="throws">
  <xsl:apply-templates/>
  <xsl:text>, </xsl:text>
</xsl:template>


<xsl:template match="parameter">
  <i class="parameter">
    <xsl:apply-templates/>
  </i>
</xsl:template>


<xsl:template match="refsect1" mode="java">
  <xsl:apply-templates mode="java"/>
</xsl:template>


<xsl:template match="refsect1/title">
  <h4 class="refsect1">
    <xsl:apply-templates/>
  </h4>
</xsl:template>

<xsl:template match="refsect1/title" mode="java"/>


<xsl:template match="refsect1/para" mode="java">
  <p>
    <xsl:if test="preceding-sibling::title/text()">
      <span class="refsect1">
        <xsl:value-of select="preceding-sibling::title"/>
        <xsl:text>: </xsl:text>
      </span>
    </xsl:if>
    <xsl:apply-templates/>
  </p>
</xsl:template>


<xsl:template match="refsect2/title">
  <h4 class="refsect2">
    <xsl:apply-templates/>
  </h4>
</xsl:template>




<!--
========================================================================
                          NUTLISTS
========================================================================
-->



<xsl:template match="nutlist">
  <table border="1" cellpadding="5">
    <xsl:apply-templates/>
  </table>
</xsl:template>


<xsl:template match="nutentry">
  <tr>
    <td valign="top">
      <xsl:value-of select="term"/>
    </td>
    <td>
      <xsl:apply-templates/>
    </td>
  </tr>
</xsl:template>


<xsl:template match="nutentry/term"/>


<xsl:template match="nutsynopsis">
  <p><xsl:apply-templates/></p>
</xsl:template>



<!--
========================================================================
                          INDEXTERMS
========================================================================
-->



<xsl:template match="indexterm">
  <a>
    <xsl:attribute name="name">
      <xsl:text>INDEX-</xsl:text>
      <xsl:value-of select="@number"/>
    </xsl:attribute>
  </a>
</xsl:template>


<!--
index-main-page
===============
Creates a main page for the index

-->
<xsl:template name="index-main-page">
  <xt:document href="index/index.htm" method="html">
    <xsl:fallback>Error while creating file.</xsl:fallback>

    <html>
      <head>
        <title>
          <xsl:text>Index: </xsl:text>
          <xsl:value-of select="title"/>
        </title>
        <link rel="stylesheet" type="text/css" href="../../style/style1.css"/>
      </head>
      <body>
        <xsl:value-of select="$dblnewline"/>
        <xsl:comment> START OF BODY </xsl:comment>
        <xsl:value-of select="$dblnewline"/>

        <!-- Top Banner -->

        <xsl:value-of select="$dblnewline"/>
        <xsl:comment> TOP BANNER </xsl:comment>
        <xsl:value-of select="$dblnewline"/>
        <a href="../index.htm">
          <img src="../gifs/smbanns.gif"
               border="0"
               alt="Book Home"/></a>

        <!-- Index links -->

        <xsl:value-of select="$dblnewline"/>
        <xsl:comment> INDEX LINKS </xsl:comment>
        <xsl:value-of select="$dblnewline"/>
        <h2 class="index">Index</h2>
        <p>
          <a href="idx_0.htm">Symbols</a> |
          <a href="idx_a.htm">A</a> |
          <a href="idx_b.htm">B</a> |
          <a href="idx_c.htm">C</a> |
          <a href="idx_d.htm">D</a> |
          <a href="idx_e.htm">E</a> |
          <a href="idx_f.htm">F</a> |
          <a href="idx_g.htm">G</a> |
          <a href="idx_h.htm">H</a> |
          <a href="idx_i.htm">I</a> |
          <a href="idx_j.htm">J</a> |
          <a href="idx_k.htm">K</a> |
          <a href="idx_l.htm">L</a> |
          <a href="idx_m.htm">M</a> |
          <a href="idx_n.htm">N</a> |
          <a href="idx_o.htm">O</a> |
          <a href="idx_p.htm">P</a> |
          <a href="idx_q.htm">Q</a> |
          <a href="idx_r.htm">R</a> |
          <a href="idx_s.htm">S</a> |
          <a href="idx_t.htm">T</a> |
          <a href="idx_u.htm">U</a> |
          <a href="idx_v.htm">V</a> |
          <a href="idx_w.htm">W</a> |
          <a href="idx_x.htm">X</a> |
          <a href="idx_y.htm">Y</a> |
          <a href="idx_x.htm">Z</a>
        </p>

        <!-- Library Nav Bar -->

        <xsl:value-of select="$dblnewline"/>
        <xsl:comment> LIBRARY NAV BAR </xsl:comment>      
        <xsl:value-of select="$dblnewline"/>
        <hr width="515" align="left"/>
        <img src="../gifs/smnavbar.gif"
             usemap="#library-map"
             border="0"
             alt="Library Navigation Links"/>
        <p>
          <font size="-1">
            <a href="../copyrght.htm">
              <xsl:text>Copyright &#169; 2000</xsl:text>
            </a>
            <xsl:text> O'Reilly &amp; Associates. </xsl:text>
            <xsl:text>All rights reserved.</xsl:text>
          </font>
        </p>
        <map name="library-map">
          <xsl:comment> **REPLACE WITH LIBRARY-MAP** </xsl:comment>
        </map>

        <!-- End of file -->

        <xsl:value-of select="$dblnewline"/>
        <xsl:comment> END OF BODY </xsl:comment>
        <xsl:value-of select="$dblnewline"/>
      </body>
    </html>
  </xt:document>
</xsl:template>



<!--
========================================================================
                          FRONT MATTER
========================================================================
-->



<xsl:template match="copyrightpg">
  <xt:document href="copyrght.htm" method="html">
    <html>
      <head>
        <title>O'Reilly Copyright Statement</title>
        <link rel="stylesheet" type="text/css" href="../style/style1.css"/>
        <xsl:call-template name="meta-data"/>
      </head>

      <xsl:value-of select="$dblnewline"/>
      <body>
        <a href="index.htm">
          <img src="gifs/smbanner.gif" usemap="#srchmap" border="0"/>
        </a>

        <map name="srchmap">
          <area shape="rect" coords="0,0,466,65" href="index.htm">
            <xsl:attribute name="alt">
              <xsl:value-of select="/book/title"/>
            </xsl:attribute>
          </area>
	  <area shape="rect" coords="467,0,514,18" href="jobjects/fsearch.htm">
            <xsl:attribute name="alt">
              <xsl:text>Search this book</xsl:text>
            </xsl:attribute>
          </area>
        </map>

        <xsl:apply-templates select="simplesect[@role='copyright']"/>
        <xsl:apply-templates select="simplesect[@role='logo']"/>
        <xsl:apply-templates select="simplesect[@role='disclaimer']"/>

        <hr width="515" align="left"/>
        <xsl:comment>LIBRARY-NAV-BAR</xsl:comment>      
        <xsl:call-template name="copyright"/>

        <xsl:value-of select="$dblnewline"/>
        <xsl:comment>END OF FILE</xsl:comment>
        <xsl:value-of select="$dblnewline"/>
      </body>
    </html>
  </xt:document>
</xsl:template>


<xsl:template match="simplesect[@role='copyright']">
  <h3>Copyright Information</h3>
  <xsl:apply-templates/>
</xsl:template>


<xsl:template match="simplesect[@role='logo']">
  <h3>Logos and Trademarks</h3>
  <xsl:apply-templates/>
</xsl:template>


<xsl:template match="simplesect[@role='disclaimer']">
  <h3>Disclaimer</h3>
  <xsl:apply-templates/>
</xsl:template>


<xsl:template match="colophon">
  <xt:document href="colophon.htm" method="html">
    <html>
      <head>
        <title>
          <xsl:value-of select="title"/>
        </title>
        <link rel="stylesheet" type="text/css" href="../style/style1.css"/>
        <xsl:call-template name="meta-data"/>
      </head>

      <xsl:value-of select="$dblnewline"/>
      <body>
        <a href="index.htm">
          <img src="gifs/smbanner.gif" usemap="#srchmap" border="0"/>
        </a>

        <map name="srchmap">
          <area shape="rect" coords="0,0,466,65" href="index.htm">
            <xsl:attribute name="alt">
              <xsl:value-of select="/book/title"/>
            </xsl:attribute>
          </area>
	  <area shape="rect" coords="467,0,514,18" href="jobjects/fsearch.htm">
            <xsl:attribute name="alt">
              <xsl:text>Search this book</xsl:text>
            </xsl:attribute>
          </area>
        </map>

        <xsl:apply-templates/>

        <xsl:comment>BOTTOM NAV BAR</xsl:comment>

        <xsl:value-of select="$dblnewline"/>
        <hr width="515" align="left"/>
        <xsl:comment>LIBRARY-NAV-BAR</xsl:comment>      
        <xsl:call-template name="copyright"/>

        <xsl:value-of select="$dblnewline"/>
        <xsl:comment>END OF FILE</xsl:comment>

        <xsl:value-of select="$dblnewline"/>
      </body>
    </html>
  </xt:document>
</xsl:template>



<!--
========================================================================
                          FILE TEMPLATES
========================================================================
-->



<!--
file
====
This template generates a new HTML file to contain either a
first-level section, a chapter opening plus first section, or a part
page.

The head element contains metadata and a link to a CSS stylesheet.
Before and after the main content are two sets of links (navbars) for
navigation in the book.

-->
<xsl:template name="file">
  <xsl:variable name="prev-link">
    <xsl:call-template name="previous-file"/>
  </xsl:variable>
  <xsl:variable name="next-link">
    <xsl:call-template name="next-file"/>
  </xsl:variable>

  <html>
    <head>
      <title><xsl:value-of select="title"/></title>
      <xsl:value-of select="$dblnewline"/>
      <xsl:comment> STYLESHEET </xsl:comment>
      <xsl:value-of select="$dblnewline"/>
      <link rel="stylesheet" type="text/css" href="../style/style1.css"/>
      <xsl:value-of select="$dblnewline"/>
      <xsl:comment> METADATA </xsl:comment>
      <xsl:value-of select="$dblnewline"/>
      <xsl:call-template name="meta-data"/>
    </head>
    <xsl:value-of select="$dblnewline"/>
    <body>
      <xsl:value-of select="$dblnewline"/>
      <xsl:comment> START OF BODY </xsl:comment>
      <xsl:value-of select="$dblnewline"/>

      <!-- Banner -->

      <xsl:value-of select="$dblnewline"/>
      <xsl:comment> TOP BANNER </xsl:comment>
      <xsl:value-of select="$dblnewline"/>
      <a href="index.htm">
        <img src="gifs/smbanner.gif" 
             usemap="#banner-map" 
             border="0"
             alt="Book Home"/>
      </a>
      <map name="banner-map">
        <xsl:comment> **REPLACE WITH BANNER-MAP** </xsl:comment>
      </map>

      <!-- Top Nav Bar -->

      <xsl:value-of select="$dblnewline"/>
      <xsl:comment> TOP NAV BAR </xsl:comment>
      <xsl:value-of select="$dblnewline"/>

      <xsl:call-template name="nav-bar-top">
        <xsl:with-param name="prev-link">
          <xsl:value-of select="$prev-link"/>
        </xsl:with-param>
        <xsl:with-param name="next-link">
          <xsl:value-of select="$next-link"/>
        </xsl:with-param>
      </xsl:call-template>

      <hr width="515" align="left"/>

      <!-- Section body -->

      <xsl:value-of select="$dblnewline"/>
      <xsl:comment> SECTION BODY </xsl:comment>
      <xsl:apply-templates/>

      <!-- Bottom Nav Bar -->

      <xsl:value-of select="$dblnewline"/>
      <xsl:comment> BOTTOM NAV BAR </xsl:comment>
      <xsl:value-of select="$dblnewline"/>
      <hr width="515" align="left"/>
      <xsl:call-template name="nav-bar-bot">
        <xsl:with-param name="prev-link">
          <xsl:value-of select="$prev-link"/>
        </xsl:with-param>
        <xsl:with-param name="next-link">
          <xsl:value-of select="$next-link"/>
        </xsl:with-param>
      </xsl:call-template>
      <hr width="515" align="left"/>

      <!-- Library Nav Bar -->

      <xsl:value-of select="$dblnewline"/>
      <xsl:comment> LIBRARY NAV BAR </xsl:comment>      
      <xsl:value-of select="$dblnewline"/>
      <img src="../gifs/smnavbar.gif"
           usemap="#library-map"
           border="0"
           alt="Library Navigation Links"/>
      <xsl:call-template name="copyright"/>
      <map name="library-map">
        <xsl:comment> **REPLACE WITH LIBRARY-MAP** </xsl:comment>
      </map>

      <!-- End of file -->

      <xsl:value-of select="$dblnewline"/>
      <xsl:comment> END OF BODY </xsl:comment>
      <xsl:value-of select="$dblnewline"/>
    </body>
  </html>
</xsl:template>


<!--
nav-bar-top
===========
Create a set of three navigation buttons: previous, up, and next.
The "previous" and "next" buttons are represented by images, whereas
"up" is the title of the referenced object.

"Previous" is a link to the file that precedes the current file in
canonical book order. For example, "ch04_02.htm" precedes
"ch04_03.htm".

"Up" is a link to the parent of the element that the current file
represents. For example, "ch02_01.htm" is the chapter-level file and
therefore is above "ch02_08.htm". Similarly, the part page is above
the chapters it contains, and the book is the top-level element.

"Next" is a link to the following file. For example, "appa_11.htm"
follows "appa_10.htm".

-->
<xsl:template name="nav-bar-top">
  <xsl:param name="prev-link" value="error"/>
  <xsl:param name="next-link" value="error"/>
  <xsl:variable name="up-link">
    <xsl:call-template name="parent-file"/>
  </xsl:variable>
  <xsl:variable name="up-title">
    <xsl:call-template name="parent-title"/>
  </xsl:variable>

  <div class="navbar">
    <table width="515" border="0">
      <tr>

        <td align="left" valign="top" width="172">
          <xsl:if test="boolean(normalize-space($prev-link))">
            <a href="{$prev-link}">
              <img src="../gifs/txtpreva.gif" alt="Previous" border="0"/>
            </a>
          </xsl:if>
        </td>

        <td align="center" valign="top" width="171">
          <xsl:if test="boolean(normalize-space($up-link))">
            <a href="{$up-link}">
              <xsl:value-of select="$up-title"/>
            </a>
          </xsl:if>
        </td>

        <td align="right" valign="top" width="172">
          <xsl:if test="boolean(normalize-space($next-link))">
            <a href="{$next-link}">
              <img src="../gifs/txtnexta.gif" alt="Next" border="0"/>
            </a>
          </xsl:if>
        </td>

      </tr>
    </table>
  </div>
</xsl:template>


<!--
nav-bar-bot
===========
Like nav-bar-top, but with additional row: section titles and index
link.  "Up" has been replaced with a link to "home".

-->
<xsl:template name="nav-bar-bot">
  <xsl:param name="prev-link" value="error"/>
  <xsl:param name="next-link" value="error"/>

  <div class="navbar">
    <table width="515" border="0">
      <tr>
        <td align="left" valign="top" width="172">
          <xsl:if test="boolean(normalize-space($prev-link))">
            <a href="{$prev-link}">
              <img src="../gifs/txtpreva.gif" alt="Previous" border="0"/>
            </a>
          </xsl:if>
        </td>
        <td align="center" valign="top" width="171">
          <a href="index.htm">
            <img src="../gifs/txthome.gif" alt="Home" border="0"/>
          </a>
        </td>
        <td align="right" valign="top" width="172">
          <xsl:if test="boolean(normalize-space($next-link))">
            <a href="{$next-link}">
              <img src="../gifs/txtnexta.gif" alt="Next" border="0"/>
            </a>
          </xsl:if>
        </td>
      </tr>
      <tr>
        <td align="left" valign="top" width="172">
          <xsl:call-template name="previous-title"/>
        </td>
        <td align="center" valign="top" width="171">
          <a href="index/">
            <img src="../gifs/index.gif" alt="Home" border="0"/>
          </a>
        </td>
        <td align="right" valign="top" width="172">
          <xsl:call-template name="next-title"/>
        </td>
      </tr>
    </table>
  </div>
</xsl:template>


<!--
toc
===
Build a list of high-level elements

-->
<xsl:template name="toc">
  <xsl:if test="copyrightpg">
    <a href="copyrght.htm">Copyright Page</a>
  </xsl:if>

  <xsl:if test="count(preface)>0">
    <p class="toc">
      <xsl:for-each select="preface">
        <a>
          <xsl:attribute name="href">
            <xsl:call-template name="filename"/>
          </xsl:attribute>
          <xsl:value-of select="title"/>
        </a>
        <br/>
      </xsl:for-each>
    </p>
  </xsl:if>

  <xsl:if test="count(chapter)>0">
    <p class="toc">
      <xsl:for-each select="chapter">
        <a>
          <xsl:attribute name="href">
            <xsl:call-template name="filename"/>
            </xsl:attribute>
            <xsl:text>Chapter </xsl:text>
            <xsl:value-of select="position()"/>
            <xsl:text>: </xsl:text>
          <i><xsl:value-of select="title"/></i>
        </a>
        <br/>
      </xsl:for-each>
    </p>
  </xsl:if>

  <xsl:if test="count(appendix)>0">
    <p class="toc">
      <xsl:for-each select="appendix">
        <a>
          <xsl:attribute name="href">
            <xsl:call-template name="filename"/>
          </xsl:attribute>
          <xsl:text>Appendix </xsl:text>
          <xsl:number value="position()" format="A"/>
          <xsl:text>: </xsl:text>
          <i><xsl:value-of select="title"/></i>
        </a>
        <br/>
      </xsl:for-each>
    </p>
  </xsl:if>

  <xsl:for-each select="part">
    <p class="toc">
      <h3><a>
        <xsl:attribute name="href">
          <xsl:call-template name="filename"/>
        </xsl:attribute>
        <xsl:text>Part </xsl:text>
        <xsl:value-of select="position()"/>
        <xsl:text>: </xsl:text>
        <xsl:value-of select="title"/>
      </a></h3>
      <xsl:for-each select="preface">
        <a>
          <xsl:attribute name="href">
            <xsl:call-template name="filename"/>
          </xsl:attribute>
          <xsl:value-of select="title"/>
        </a>
        <br/>
      </xsl:for-each>
      <xsl:for-each select="chapter">
        <a>
          <xsl:attribute name="href">
            <xsl:call-template name="filename"/>
          </xsl:attribute>
          <xsl:text>Chapter </xsl:text>
          <xsl:value-of select="count(preceding::chapter)+1"/>
          <xsl:text>: </xsl:text>
          <i><xsl:value-of select="title"/></i>
        </a>
        <br/>
      </xsl:for-each>
      <xsl:for-each select="appendix">
        <a>
          <xsl:attribute name="href">
            <xsl:call-template name="filename"/>
          </xsl:attribute>
          <xsl:text>Appendix </xsl:text>
          <xsl:number value="count(preceding::appendix)+1" format="A"/>
          <xsl:text>: </xsl:text>
          <i><xsl:value-of select="title"/></i>
        </a>
        <br/>
      </xsl:for-each>
    </p>
  </xsl:for-each>

  <xsl:if test="colophon">
    <a href="colophon.htm">Colophon</a>
  </xsl:if>
</xsl:template>


<xsl:template name="index-links">
  <a href="index/idx_0.htm">Symbols</a> |
  <a href="index/idx_a.htm">A</a> |
  <a href="index/idx_b.htm">B</a> |
  <a href="index/idx_c.htm">C</a> |
  <a href="index/idx_d.htm">D</a> |
  <a href="index/idx_e.htm">E</a> |
  <a href="index/idx_f.htm">F</a> |
  <a href="index/idx_g.htm">G</a> |
  <a href="index/idx_h.htm">H</a> |
  <a href="index/idx_i.htm">I</a> |
  <a href="index/idx_j.htm">J</a> |
  <a href="index/idx_k.htm">K</a> |
  <a href="index/idx_l.htm">L</a> |
  <a href="index/idx_m.htm">M</a> |
  <a href="index/idx_n.htm">N</a> |
  <a href="index/idx_o.htm">O</a> |
  <a href="index/idx_p.htm">P</a> |
  <a href="index/idx_q.htm">Q</a> |
  <a href="index/idx_r.htm">R</a> |
  <a href="index/idx_s.htm">S</a> |
  <a href="index/idx_t.htm">T</a> |
  <a href="index/idx_u.htm">U</a> |
  <a href="index/idx_v.htm">V</a> |
  <a href="index/idx_w.htm">W</a> |
  <a href="index/idx_x.htm">X</a> |
  <a href="index/idx_y.htm">Y</a> |
  <a href="index/idx_x.htm">Z</a>
</xsl:template>


<xsl:template name="copyright">
  <p>
    <font size="-1">
      <a href="copyrght.htm">
        <xsl:text>Copyright &#169; 2000</xsl:text>
      </a>
      <xsl:text> O'Reilly &amp; Associates. </xsl:text>
      <xsl:text>All rights reserved.</xsl:text>
    </font>
  </p>
</xsl:template>


<xsl:template name="mini-toc">
  <div class="htmltoc">
    <h4 class="tochead">Contents:</h4>
    <p>
      <xsl:for-each select="../sect1">
        <a>
          <xsl:attribute name="href">
            <xsl:call-template name="filename"/>
          </xsl:attribute>
          <xsl:value-of select="title"/>
        </a>
        <br/>
      </xsl:for-each>
    </p>
  </div> 
</xsl:template>


<xsl:template name="meta-data">
  <xsl:param name="author">
    <xsl:call-template name="author"/>
  </xsl:param>
  <xsl:param name="isbn">
    <xsl:call-template name="isbn"/>
  </xsl:param>
  <xsl:param name="title">
    <xsl:value-of select="title"/>
  </xsl:param>

  <xsl:value-of select="$dblnewline"/>
  <xsl:comment>Dublin Core Metadata</xsl:comment>

  <xsl:value-of select="$dblnewline"/>
  <meta name="DC.Creator" content="{$author}"/>
  <meta name="DC.Date" content=""/>
  <meta name="DC.Format" content="text/xml" scheme="MIME"/>
  <meta name="DC.Generator" content="XSLT stylesheet, xt by James Clark"/>
  <meta name="DC.Identifier" content=""/>
  <meta name="DC.Language" content="en-US"/>
  <meta name="DC.Publisher" content="O'Reilly &amp; Associates, Inc."/>
  <meta name="DC.Source" content="{$isbn}" scheme="ISBN"/>
  <meta name="DC.Subject.Keyword" content=""/>
  <meta name="DC.Title" content="{$title}"/>
  <meta name="DC.Type" content="Text.Monograph"/>
  <xsl:value-of select="$dblnewline"/>
</xsl:template>



<!--
========================================================================
                            NAVIGATION LINKS
========================================================================
-->



<!--
previous-file
=============
Return the name of the file that precedes the current one.

Chapters take the form chXX_YY.htm, where XX is the chapter number
(01, 02, etc.), and YY is the sect1 number (01, 02, etc.). Each
chapter file contains the first section (if there is one), and so is
named ch01_01.htm, for example. Every chapter is assumed to contain at
least one section.

Appendixes take the form appX_YY.htm, where X is a lower-case letter,
and YY is the same as above. We assume that no appendix can be
followed by a chapter, which we use in the ordering of rules below.

A part page takes the form partX.htm, where X is the part
number. Part pages are assumed to be short, so we don't bother to
separate out any sections.

-->
<xsl:template name="previous-file">
  <xsl:choose>

    <!-- 1. Previous page is a part (I am a chapter) -->

    <xsl:when test="parent::part/@number and
                    not(preceding-sibling::appendix or
                        preceding-sibling::chapter or
                        preceding-sibling::preface)">
      <xsl:text>part</xsl:text>
      <xsl:value-of select="../@number"/>
      <xsl:text>.htm</xsl:text>
    </xsl:when>

    <!-- 2. Previous page is chapter (I am a section) -->

    <xsl:when test="parent::appendix/@number and
                    not(preceding-sibling::sect1)">
      <xsl:text>app</xsl:text>
      <xsl:number value="../@number" format="a"/>
      <xsl:text>_01.htm</xsl:text>
    </xsl:when>

    <xsl:when test="parent::chapter/@number and
                    not(preceding-sibling::sect1)">
      <xsl:text>ch</xsl:text>
      <xsl:number value="../@number" format="01"/>
      <xsl:text>_01.htm</xsl:text>
    </xsl:when>

    <xsl:when test="parent::preface and not(preceding-sibling::sect1)">
      <xsl:text>ch00_01.htm</xsl:text>
    </xsl:when>

    <!-- 3. Previous page is chapter (I am a chapter) -->

    <xsl:when test="preceding-sibling::appendix[1]/@number and
                    not(preceding-sibling::appendix[1]/sect1)">
      <xsl:text>app</xsl:text>
      <xsl:number value="preceding-sibling::appendix[1]/@number" format="a"/>
      <xsl:text>_01.htm</xsl:text>
    </xsl:when>

    <xsl:when test="preceding-sibling::chapter[1]/@number and
                    not(preceding-sibling::chapter[1]/sect1)">
      <xsl:text>ch</xsl:text>
      <xsl:number value="preceding-sibling::chapter[1]/@number" format="01"/>
      <xsl:text>_01.htm</xsl:text>
    </xsl:when>

    <xsl:when test="preceding-sibling::preface and
                    not(preceding-sibling::preface/sect1)">
      <xsl:text>ch00_01.htm</xsl:text>
    </xsl:when>

    <!-- 4. Previous page is chapter (I am a part) -->

    <xsl:when test="preceding-sibling::part[1]/appendix[-1]/@number and
                    not(preceding-sibling::part[1]/appendix[-1]/sect1)">
      <xsl:text>app</xsl:text>
      <xsl:number value="preceding-sibling::part[1]/appendix[-1]/@number" 
        format="a"/>
      <xsl:text>_01.htm</xsl:text>
    </xsl:when>

    <xsl:when test="preceding-sibling::part[1]/chapter[-1]/@number and
                    not(preceding-sibling::part[1]/chapter[-1]/sect1)">
      <xsl:text>ch</xsl:text>
      <xsl:number value="preceding::part[1]/chapter[-1]/@number" format="01"/>
      <xsl:text>_01.htm</xsl:text>
    </xsl:when>

    <xsl:when test="preceding-sibling::part[1]/preface and
                    not(preceding-sibling::part[1]/preface/sect1)">
      <xsl:text>ch00_01.htm</xsl:text>
    </xsl:when>

    <!-- 5. Previous page is section in another chapter 
            (I am a section, chapter, or part) -->

    <xsl:when test="preceding::sect1[1]/@number">
      <xsl:choose>
        <xsl:when test="preceding::sect1[1]/parent::appendix">
          <xsl:text>app</xsl:text>
          <xsl:number value="substring-before(preceding::sect1[1]/@number,'.')"
            format="a"/> 
        </xsl:when>
        <xsl:otherwise>
          <xsl:text>ch</xsl:text>
          <xsl:number value="substring-before(preceding::sect1[1]/@number,'.')"
            format="01"/>
        </xsl:otherwise>
      </xsl:choose>
      <xsl:text>_</xsl:text>
      <xsl:number value="substring-after(preceding::sect1[1]/@number,'.')" 
        format="01"/> 
      <xsl:text>.htm</xsl:text>
    </xsl:when>

  </xsl:choose>
</xsl:template>


<!--
next-file
=========
Return the name of the file that follows the current one.

-->
<xsl:template name="next-file">
  <xsl:choose>

    <!-- 1. Next page is a section (I am a section) -->

    <xsl:when test="following-sibling::sect1[1]/@number">
      <xsl:choose>
        <xsl:when test="parent::appendix/@number">
          <xsl:text>app</xsl:text>
          <xsl:number value="../@number" format="a"/>
        </xsl:when>
        <xsl:when test="parent::chapter/@number">
          <xsl:text>ch</xsl:text>
          <xsl:number value="../@number" format="01"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:text>ch00</xsl:text>
        </xsl:otherwise>
      </xsl:choose>
      <xsl:text>_</xsl:text>
      <xsl:number 
        value="substring-after(following-sibling::sect1[1]/@number,'.')" 
        format="01"/>
      <xsl:text>.htm</xsl:text>
    </xsl:when>

    <!-- 2. Next page is a section (I am a chapter) -->

    <xsl:when test="child::sect1[2]/@number">
      <xsl:choose>
        <xsl:when test="self::appendix/@number">
          <xsl:text>app</xsl:text>
          <xsl:number value="@number" format="a"/>
        </xsl:when>
        <xsl:when test="self::chapter/@number">
          <xsl:text>ch</xsl:text>
          <xsl:number value="@number" format="01"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:text>ch00</xsl:text>
        </xsl:otherwise>
      </xsl:choose>
      <xsl:text>_02.htm</xsl:text>
    </xsl:when>

    <!-- 3. Next page is a chapter (I am a section) -->

    <xsl:when test="../following-sibling::chapter[1]/@number">
      <xsl:text>ch</xsl:text>
      <xsl:number value="../following-sibling::chapter[1]/@number" 
        format="01"/>
      <xsl:text>_01.htm</xsl:text>
    </xsl:when>

    <xsl:when test="../following-sibling::appendix[1]/@number">
      <xsl:text>app</xsl:text>
      <xsl:number value="../following-sibling::appendix[1]/@number" 
        format="a"/>
      <xsl:text>_01.htm</xsl:text>
    </xsl:when>

    <!-- 4. Next page is a chapter (I am a chapter) -->

    <xsl:when test="following-sibling::chapter[1]/@number">
      <xsl:text>ch</xsl:text>
      <xsl:number value="following-sibling::chapter[1]/@number" format="01"/>
      <xsl:text>_01.htm</xsl:text>
    </xsl:when>

    <xsl:when test="following-sibling::appendix[1]/@number">
      <xsl:text>app</xsl:text>
      <xsl:number value="following-sibling::appendix[1]/@number" format="a"/>
      <xsl:text>_01.htm</xsl:text>
    </xsl:when>

    <!-- 5. Next page is a chapter (I am a part) -->

    <xsl:when test="child::preface">
      <xsl:text>ch00_01.htm</xsl:text>
    </xsl:when>

    <xsl:when test="child::chapter[1]/@number">
      <xsl:text>ch</xsl:text>
      <xsl:number value="child::chapter[1]/@number" format="01"/>
      <xsl:text>_01.htm</xsl:text>
    </xsl:when>

    <xsl:when test="child::appendix[1]/@number">
      <xsl:text>app</xsl:text>
      <xsl:number value="child::appendix[1]/@number" format="a"/>
      <xsl:text>_01.htm</xsl:text>
    </xsl:when>

    <!-- 6. Next page is a part (I am a section or chapter) -->

    <xsl:when test="following::part[1]/@number">
      <xsl:text>part</xsl:text>
      <xsl:value-of select="following::part[1]/@number"/>
      <xsl:text>.htm</xsl:text>
    </xsl:when>

  </xsl:choose>
</xsl:template>


<!--
parent-file
===========
Return the filename for an element that is above the current element.

-->
<xsl:template name="parent-file">
  <xsl:choose>

    <xsl:when test="parent::appendix/@number">
      <xsl:text>app</xsl:text>
      <xsl:number value="../@number" format="a"/>
      <xsl:text>_01.htm</xsl:text>
    </xsl:when>
  
    <xsl:when test="parent::chapter/@number">
      <xsl:text>ch</xsl:text>
      <xsl:number value="../@number" format="01"/>
      <xsl:text>_01.htm</xsl:text>
    </xsl:when>
  
    <xsl:when test="parent::part/@number">
      <xsl:text>part</xsl:text>
      <xsl:value-of select="../@number"/>
      <xsl:text>.htm</xsl:text>
    </xsl:when>
  
    <xsl:when test="parent::preface">ch00_01.htm</xsl:when>
  
    <xsl:otherwise>index.htm</xsl:otherwise>
  </xsl:choose>
</xsl:template>


<!--
previous-title
==============
Return the title of the preceding file.

-->
<xsl:template name="previous-title">
  <xsl:choose>

    <!-- 1. Previous page is a part (I am a chapter) -->

    <xsl:when test="parent::part/@number and
                    not(preceding-sibling::appendix or
                        preceding-sibling::chapter or
                        preceding-sibling::preface)">
      <xsl:text>Part </xsl:text>
      <xsl:value-of select="../@number"/>
      <xsl:text>. </xsl:text>
      <xsl:value-of select="../title"/>
    </xsl:when>

    <!-- 2. Previous page is chapter (I am a section) -->

    <xsl:when test="parent::appendix/@number and
                    not(preceding-sibling::sect1)">
      <xsl:text>Appendix </xsl:text>
      <xsl:number value="../@number" format="A"/>
      <xsl:text>. </xsl:text>
      <xsl:value-of select="../title"/>
    </xsl:when>

    <xsl:when test="parent::chapter/@number and 
                    not(preceding-sibling::sect1)">
      <xsl:text>Chapter </xsl:text>
      <xsl:value-of select="../@number"/>
      <xsl:text>. </xsl:text>
      <xsl:value-of select="../title"/>
    </xsl:when>

    <xsl:when test="parent::preface and not(preceding-sibling::sect1)">
      <xsl:text>0. Preface</xsl:text>
    </xsl:when>

    <!-- 3. Previous page is chapter (I am a chapter) -->

    <xsl:when test="preceding-sibling::appendix[1]/@number and
                    not(preceding-sibling::appendix[1]/sect1)">
      <xsl:text>Appendix </xsl:text>
      <xsl:number value="preceding-sibling::appendix[1]/@number" format="A"/>
      <xsl:text>. </xsl:text>
      <xsl:value-of select="preceding-sibling::appendix[1]/title"/>
    </xsl:when>

    <xsl:when test="preceding-sibling::chapter[1]/@number and
                    not(preceding-sibling::chapter[1]/sect1)">
      <xsl:text>Chapter </xsl:text>
      <xsl:value-of select="preceding-sibling::chapter[1]/@number"/>
      <xsl:text>. </xsl:text>
      <xsl:value-of select="preceding-sibling::chapter[1]/title"/>
    </xsl:when>

    <xsl:when test="preceding-sibling::preface and
                    not(preceding-sibling::preface[1]/sect1)">
      <xsl:text>0. Preface</xsl:text>
    </xsl:when>

    <!-- 4. Previous page is chapter (I am a part) -->

    <xsl:when test="preceding-sibling::part[1]/appendix[-1]/@number and
                    not(preceding-sibling::part[1]/appendix[-1]/sect1)">
      <xsl:text>Appendix </xsl:text>
      <xsl:number value="preceding-sibling::part[1]/appendix[-1]/@number" 
        format="A"/>
      <xsl:text>. </xsl:text>
      <xsl:value-of select="preceding-sibling::part[1]/appendix[-1]/title"/>
    </xsl:when>

    <xsl:when test="preceding-sibling::part[1]/chapter[-1]/@number and
                    not(preceding-sibling::part[1]/chapter[-1]/sect1)">
      <xsl:text>Chapter </xsl:text>
      <xsl:value-of select="preceding-sibling::part[1]/chapter[-1]/@number"/>
      <xsl:text>. </xsl:text>
      <xsl:value-of select="preceding-sibling::part[1]/chapter[-1]/title"/>
    </xsl:when>

    <xsl:when test="preceding-sibling::part[1]/preface and
                    not(preceding-sibling::part[1]/preface/sect1)">
      <xsl:text>Preface</xsl:text>
    </xsl:when>

    <!-- 5. Previous page is section in another chapter 
            (I am a section, chapter, or part) -->

    <xsl:when test="preceding::sect1[1]/@number">
      <xsl:choose>
        <xsl:when test="preceding::sect1[1]/parent::appendix">
          <xsl:number value="substring-before(preceding::sect1[1]/@number,'.')"
            format="A"/> 
        </xsl:when>
        <xsl:otherwise>
          <xsl:value-of 
            select="substring-before(preceding::sect1[1]/@number,'.')"/>
        </xsl:otherwise>
      </xsl:choose>
      <xsl:text>.</xsl:text>
      <xsl:value-of select="substring-after(preceding::sect1[1]/@number,'.')"/>
      <xsl:text>. </xsl:text>
      <xsl:value-of select="preceding::sect1[1]/title"/>
    </xsl:when>

  </xsl:choose>
</xsl:template>


<!--
next-title
==========
Return the title of the section that follows the current one.

-->
<xsl:template name="next-title">
  <xsl:choose>

    <!-- 1. Next page is a section (I am a section) -->

    <xsl:when test="following-sibling::sect1[1]/@number">
      <xsl:choose>
        <xsl:when test="parent::appendix/@number">
          <xsl:number value="../@number" format="A"/>
        </xsl:when>
        <xsl:when test="parent::chapter/@number">
          <xsl:value-of select="../@number"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:text>0</xsl:text>
        </xsl:otherwise>
      </xsl:choose>
      <xsl:text>.</xsl:text> 
      <xsl:value-of
        select="substring-after(following-sibling::sect1[1]/@number,'.')"/>
      <xsl:text>. </xsl:text> 
      <xsl:value-of select="following-sibling::sect1[1]/title"/>
    </xsl:when>

    <!-- 2. Next page is a section (I am a chapter) -->

    <xsl:when test="child::sect1[2]/@number">
      <xsl:choose>
        <xsl:when test="self::appendix/@number">
          <xsl:number value="@number" format="A"/>
        </xsl:when>
        <xsl:when test="self::chapter/@number">
          <xsl:value-of select="@number"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:text>0</xsl:text>
        </xsl:otherwise>
      </xsl:choose>
      <xsl:text>.</xsl:text> 
      <xsl:value-of
        select="substring-after(child::sect1[2]/@number,'.')"/>
      <xsl:text>. </xsl:text> 
      <xsl:value-of select="child::sect1[2]/title"/>
    </xsl:when>

    <!-- 3. Next page is a chapter (I am a section) -->

    <xsl:when test="../following-sibling::chapter/@number">
      <xsl:value-of select="../following-sibling::chapter[1]/@number"/>
      <xsl:text>. </xsl:text>
      <xsl:value-of select="../following-sibling::chapter[1]/title"/>
    </xsl:when>

    <xsl:when test="../following-sibling::appendix/@number">
      <xsl:number value="../following-sibling::appendix[1]/@number" 
        format="A"/>
      <xsl:text>. </xsl:text>
      <xsl:value-of select="../following-sibling::appendix[1]/title"/>
    </xsl:when>

    <!-- 4. Next page is a chapter (I am a chapter) -->

    <xsl:when test="following-sibling::chapter/@number">
      <xsl:value-of select="following-sibling::chapter[1]/@number"/>
      <xsl:text>. </xsl:text>
      <xsl:value-of select="following-sibling::chapter[1]/title"/>
    </xsl:when>

    <xsl:when test="following-sibling::appendix/@number">
      <xsl:number value="following-sibling::appendix[1]/@number" format="A"/>
      <xsl:text>. </xsl:text>
      <xsl:value-of select="following-sibling::appendix[1]/title"/>
    </xsl:when>

    <!-- 5. Next page is a chapter (I am a part) -->

    <xsl:when test="child::preface">
      <xsl:text>0. Preface</xsl:text>
    </xsl:when>

    <xsl:when test="child::chapter/@number">
      <xsl:value-of select="child::chapter[1]/@number"/>
      <xsl:text>. </xsl:text>
      <xsl:value-of select="child::chapter[1]/title"/>
    </xsl:when>

    <xsl:when test="child::appendix/@number">
      <xsl:number value="child::appendix[1]/@number" format="A"/>
      <xsl:text>. </xsl:text>
      <xsl:value-of select="child::appendix[1]/title"/>
    </xsl:when>

    <!-- 6. Next page is a part (I am a section or chapter) -->

    <xsl:when test="following::part/@number">
      <xsl:text>Part </xsl:text>
      <xsl:value-of select="following::part[1]/@number"/>
      <xsl:text>. </xsl:text>
      <xsl:value-of select="following::part[1]/title"/>
    </xsl:when>

  </xsl:choose>
</xsl:template>


<!--
parent-title
============
Return the title for an element that is above the current element.

-->
<xsl:template name="parent-title">
  <xsl:choose>

    <!-- 1. Parent is a chapter -->

    <xsl:when test="parent::appendix">
      <xsl:text>Appendix </xsl:text>
      <xsl:number value="../@number" format="A"/>
      <xsl:text>: </xsl:text>
      <xsl:value-of select="../title"/>
    </xsl:when>

    <xsl:when test="parent::chapter">
      <xsl:text>Chapter </xsl:text>
      <xsl:value-of select="../@number"/>
      <xsl:text>: </xsl:text>
      <xsl:value-of select="../title"/>
    </xsl:when>

    <xsl:when test="parent::preface">Preface</xsl:when>

    <!-- 2. Parent is a part -->

    <xsl:when test="parent::part">
      <xsl:text>Part </xsl:text>
      <xsl:value-of select="../@number"/>
      <xsl:text>: </xsl:text>
      <xsl:value-of select="../title"/>
    </xsl:when>

    <!-- 3. Parent is the book page (TOC) -->

    <xsl:otherwise>
      <xsl:value-of select="/book/title"/>
    </xsl:otherwise>

  </xsl:choose>
</xsl:template>



<!--
========================================================================
                            BOOK INFO
========================================================================
-->



<!--
author
======
Return a string containing authors' names.

-->
<xsl:template name="author">
  <xsl:for-each select="/book/bookinfo/authorgroup/author">
    <xsl:value-of select="firstname"/>
    <xsl:text> </xsl:text>
    <xsl:value-of select="surname"/>
    <xsl:choose>
      <xsl:when test="count(following::author)>1">
        <xsl:text>, </xsl:text>
      </xsl:when>
      <xsl:when test="count(following::author)=1">
        <xsl:text> and </xsl:text>
      </xsl:when>
    </xsl:choose>
  </xsl:for-each>
</xsl:template>


<!--
isbn
====
Return a string containing the ISBN.

-->
<xsl:template name="isbn">
  <xsl:value-of select="/book/bookinfo/isbn"/>
</xsl:template>


<!--
edition
=======
Return a string containing the edition number.

-->
<xsl:template name="edition">
  <xsl:value-of select="/book/bookinfo/edition"/>
  <xsl:text> edition</xsl:text>
</xsl:template>


<!--
pubdate
=======
Return a string containing the last-published date.

-->
<xsl:template name="pubdate">
  <xsl:value-of select="/book/bookinfo/pubdate"/>
</xsl:template>


<!--
nickname
========
Return a string containing the book's nickname.

-->
<xsl:template name="nickname">
  <xsl:value-of select="/book/bookinfo/productname[@role='nickname']"/>
</xsl:template>



<!--
========================================================================
                          END OF FILE
========================================================================
-->



</xsl:stylesheet>
