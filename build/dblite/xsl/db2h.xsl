<?xml version="1.0"?>
<!-- =====================================================================
             XSLT Stylesheet to convert DocBook XML into HTML
                  Copyright 2002 O'Reilly and Associates
                       Contact: tools@oreilly.com
====================================================================== -->

<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                version="1.0"
>

<xsl:output method="xml"/>

<xsl:variable name="newline">
<xsl:text>
</xsl:text>
</xsl:variable>

<xsl:variable name="dblnewline">
<xsl:text>

</xsl:text>
</xsl:variable>


<!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
                             DEFAULT RULE

    Report any element for which there is no specific rule handling it,
    but allow processing to go to children.

-->
<xsl:template match="*" priority="-5">
  <xsl:message>
    <xsl:text>Unhandled element: </xsl:text>
    <xsl:value-of select="local-name(..)"/>
    <xsl:text>/</xsl:text>
    <xsl:value-of select="local-name(.)"/>
  </xsl:message>
  <xsl:apply-templates/>
</xsl:template>


<xsl:template match="processing-instruction()">
  <xsl:copy/>
</xsl:template>

<xsl:template match="processing-instruction('lbr')">
  <xsl:text> </xsl:text>
</xsl:template>


<xsl:template match="/">
  <allfiles>
    <xsl:apply-templates/>
  </allfiles>
</xsl:template>


<!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
                             PAGE FORMATTING
-->

<xsl:template name="css">
  <style type="text/css">
    <xsl:text>
body {
  background-color: #cccccc;
  color: black;
}

.toc1 {
  color: #333333;
  font-size: 3em;
  font-family: sans-serif;
}
.toc2 {
  color: #333333;
  font-size: 1.6em;
  font-family: sans-serif;
}
.toc3 {
  color: #333333;
  font-size: 1.2em;
  font-family: sans-serif;
}
.toc4 {
  color: #333333;
  font-size: 0.9em;
  font-family: sans-serif;
}
.head0 {
  color: #333333;
  font-size: 2.4em;
  font-family: sans-serif;
}
.head1 {
  color: #333333;
  font-size: 1.8em;
  font-family: sans-serif;
}
.head2 {
  color: #333333;
  font-size: 1.4em;
  font-family: sans-serif;
}
.head3 {
  color: #333333;
  font-size: 1.2em;
  font-family: sans-serif;
}
.head4 {
  color: #333333;
  font-size: 1em;
  font-family: sans-serif;
}
.lineannotation {
  color: gray;
}
</xsl:text>
  </style>
</xsl:template>


<xsl:template name="toc">
  <html file="book.html">
    <head>
      <title>
        <xsl:value-of select="/book/title"/>
      </title>
      <xsl:call-template name="css"/>
    </head>
    <body>
      <h1 class="toc1">
        <xsl:value-of select="/book/title"/>
      </h1>
      <h4 class="toc4">
        <xsl:if test="/book/bookinfo/edition">
          <xsl:call-template name="edition"/>
	  <xsl:text> - </xsl:text>
        </xsl:if>
        <xsl:text>By </xsl:text>
        <xsl:call-template name="authors"/>
      </h4>
      <xsl:for-each select="*">
        <xsl:call-template name="toc-chap"/>
      </xsl:for-each>
    </body>
  </html>
</xsl:template>


<xsl:template name="toc-chap">
  <xsl:if test="title">
    <h3 class="toc3">
      <xsl:choose>
        <xsl:when test="self::part">
          <xsl:text>Part </xsl:text>
          <xsl:number format="I" value="count(preceding::part) +1"/>
          <xsl:text>. </xsl:text>
        </xsl:when>
        <xsl:when test="self::appendix">
          <xsl:text>Appendix </xsl:text>
          <xsl:number format="A" value="count(preceding::appendix) +1"/>
          <xsl:text>. </xsl:text>
        </xsl:when>
        <xsl:when test="self::chapter">
          <xsl:text>Chapter </xsl:text>
          <xsl:number format="1" value="count(preceding::chapter) +1"/>
          <xsl:text>. </xsl:text>
        </xsl:when>
      </xsl:choose>
      <a>
        <xsl:attribute name="href">
          <xsl:call-template name="filename"/>
        </xsl:attribute>
        <xsl:value-of select="title"/>
      </a>
    </h3>
    <xsl:value-of select="$newline"/>
  </xsl:if>
</xsl:template>


<xsl:template name="filename">
  <xsl:choose>
    <xsl:when test="self::chapter">
      <xsl:text>ch</xsl:text>
      <xsl:number format="01" 
          value="count(preceding::chapter)+1"/>
    </xsl:when>
    <xsl:when test="self::appendix">
      <xsl:text>app</xsl:text>
      <xsl:number format="a" 
          value="count(preceding::appendix)+1"/>
    </xsl:when>
    <xsl:when test="self::preface">
      <xsl:text>ch00</xsl:text>
    </xsl:when>
    <xsl:when test="self::bibliography">
      <xsl:text>biblio</xsl:text>
    </xsl:when>
    <xsl:when test="self::glossary">
      <xsl:text>gloss</xsl:text>
    </xsl:when>
    <xsl:when test="self::part">
      <xsl:text>part</xsl:text>
      <xsl:number format="1" value="count(preceding::part)+1"/>
    </xsl:when>
    <xsl:when test="self::colophon">
      <xsl:text>colo</xsl:text>
    </xsl:when>
    <xsl:when test="self::dedication">
      <xsl:text>ded</xsl:text>
    </xsl:when>
    <xsl:otherwise>
      <xsl:text>unknown</xsl:text>
    </xsl:otherwise>
  </xsl:choose>
  <xsl:text>.html</xsl:text>
</xsl:template>


<xsl:template name="linkbar">
  <h4 class="head4">
    <xsl:if test="preceding-sibling::chapter
                | preceding-sibling::appendix
                | preceding-sibling::preface
                | preceding-sibling::part
                | preceding-sibling::foreword
                | preceding-sibling::dedication
                | preceding-sibling::bibliography
                | preceding-sibling::colophon
                | preceding-sibling::glossary">
      <a>
        <xsl:attribute name="href">
          <xsl:for-each select="preceding-sibling::*[1]">
            <xsl:call-template name="filename"/>
          </xsl:for-each>
        </xsl:attribute>
        <xsl:text>Previous</xsl:text>
      </a>
      <xsl:text> - </xsl:text>
    </xsl:if>
    <a>
      <xsl:attribute name="href">book.html</xsl:attribute>
      <xsl:text>TOC</xsl:text>
    </a>
    <xsl:if test="following-sibling::chapter
                | following-sibling::appendix
                | following-sibling::preface
                | following-sibling::part
                | following-sibling::foreword
                | following-sibling::dedication
                | following-sibling::bibliography
                | following-sibling::colophon
                | following-sibling::glossary">
      <xsl:text> - </xsl:text>
      <a>
        <xsl:attribute name="href">
          <xsl:for-each select="following-sibling::*[1]">
            <xsl:call-template name="filename"/>
          </xsl:for-each>
        </xsl:attribute>
        <xsl:text>Next</xsl:text>
      </a>
    </xsl:if>
  </h4>
</xsl:template>


<!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
                          HIERARCHICAL ELEMENTS
-->

<xsl:template match="book">
  <xsl:call-template name="toc"/>
  <xsl:apply-templates/>
</xsl:template>


<xsl:template match="bookinfo"/>


<xsl:template match="appendix
                   | chapter
                   | dedication
                   | preface
                   | bibliography
                   | glossary
                   | colophon
                   | part">
  <html>
    <xsl:attribute name="file">
      <xsl:call-template name="filename"/>
    </xsl:attribute>
    <head>
      <title>
        <xsl:value-of select="/book/title"/>
      </title>
      <xsl:call-template name="css"/>
    </head>
    <body>
      <xsl:call-template name="linkbar"/>
      <xsl:apply-templates/>
      <xsl:if test=".//footnote">
        <hr/>
        <h4 class="head4">Footnotes</h4>
        <blockquote>
          <xsl:for-each select=".//footnote">
              <xsl:call-template name="output-footnote"/>
          </xsl:for-each>
        </blockquote>
      </xsl:if>
      <hr/>
      <xsl:call-template name="linkbar"/>
    </body>
  </html>
</xsl:template>


<xsl:template match="simplesect | partintro">
    <xsl:apply-templates/>
</xsl:template>


<xsl:template match="sect1 | refsect1">
  <xsl:value-of select="$newline"/>
  <div class="sect1">
    <xsl:call-template name="drop-anchor"/>
    <xsl:value-of select="$newline"/>
    <xsl:apply-templates/>
    <xsl:value-of select="$newline"/>
  </div>
  <xsl:value-of select="$newline"/>
</xsl:template>


<xsl:template match="sect2 | refsect2">
  <xsl:value-of select="$newline"/>
  <div class="sect2">
    <xsl:call-template name="drop-anchor"/>
    <xsl:value-of select="$newline"/>
    <xsl:apply-templates/>
    <xsl:value-of select="$newline"/>
  </div>
  <xsl:value-of select="$newline"/>
</xsl:template>


<xsl:template match="sect3">
  <xsl:value-of select="$newline"/>
  <div class="sect3">
    <xsl:call-template name="drop-anchor"/>
    <xsl:value-of select="$newline"/>
    <xsl:apply-templates/>
    <xsl:value-of select="$newline"/>
  </div>
  <xsl:value-of select="$newline"/>
</xsl:template>


<xsl:template match="sect4">
  <xsl:value-of select="$newline"/>
  <div class="sect4">
    <xsl:call-template name="drop-anchor"/>
    <xsl:value-of select="$newline"/>
    <xsl:apply-templates/>
    <xsl:value-of select="$newline"/>
  </div>
  <xsl:value-of select="$newline"/>
</xsl:template>


<!--
=========== drop-anchor

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

<xsl:template match="part/title">
  <h1 class="head0">
    <xsl:number format="I" value="count(preceding::part) +1"/>
    <xsl:text>. </xsl:text>
    <xsl:apply-templates/>
  </h1>
</xsl:template>

<xsl:template match="appendix/title">
  <h1 class="head0">
    <xsl:number format="A" value="count(preceding::appendix) +1"/>
    <xsl:text>. </xsl:text>
    <xsl:apply-templates/>
  </h1>
</xsl:template>

<xsl:template match="chapter/title">
  <h1 class="head0">
    <xsl:number format="1" value="count(preceding::chapter) +1"/>
    <xsl:text>. </xsl:text>
    <xsl:apply-templates/>
  </h1>
</xsl:template>

<xsl:template match="dedication/title">
  <h1 class="head0">Dedication</h1>
</xsl:template>

<xsl:template match="glossary/title">
  <h1 class="head0">Glossary</h1>
</xsl:template>

<xsl:template match="colophon/title">
  <h1 class="head0">Colophon</h1>
</xsl:template>

<xsl:template match="preface/title">
  <h1 class="head0">Preface</h1>
</xsl:template>

<xsl:template match="bibliography/title">
  <h1 class="head0">Bibliography</h1>
</xsl:template>

<xsl:template match="sect1/title">
  <h2 class="head1">
    <xsl:number format="1" 
        value="count(parent::sect1/preceding-sibling::sect1)+1"/>
    <xsl:text>. </xsl:text>
    <xsl:apply-templates/>
  </h2>
</xsl:template>

<xsl:template match="sect2/title">
  <h3 class="head2">
    <xsl:number format="1" 
        value="count(ancestor::sect1/preceding-sibling::sect1)+1"/>
    <xsl:text>.</xsl:text>
    <xsl:number format="1" 
        value="count(parent::sect2/preceding-sibling::sect2)+1"/>
    <xsl:text>. </xsl:text>
    <xsl:apply-templates/>
  </h3>
</xsl:template>

<xsl:template match="sect3/title">
  <h3 class="head3">
    <xsl:apply-templates/>
  </h3>
</xsl:template>

<xsl:template match="sect4/title">
  <h4 class="head4">
    <xsl:apply-templates/>
  </h4>
</xsl:template>

<xsl:template match="refsect1/title">
  <h2 class="head1">
    <xsl:number format="1" 
        value="count(parent::refsect1/preceding-sibling::refsect1)+1"/>
    <xsl:text>. </xsl:text>
    <xsl:apply-templates/>
  </h2>
</xsl:template>

<xsl:template match="refsect2/title">
  <h3 class="head2">
    <xsl:number format="1" 
        value="count(ancestor::refsect1/preceding-sibling::refsect1)+1"/>
    <xsl:text>.</xsl:text>
    <xsl:number format="1" 
        value="count(parent::refsect2/preceding-sibling::refsect2)+1"/>
    <xsl:text>. </xsl:text>
    <xsl:apply-templates/>
  </h3>
</xsl:template>

<xsl:template match="example/title">
  <h4 class="head4">
    <xsl:text>Example </xsl:text>
    <xsl:number format="1" count="example" 
        from="chapter|appendix" level="any"/>
    <xsl:text>. </xsl:text>
    <xsl:apply-templates/>
  </h4>
</xsl:template>

<xsl:template match="figure/title">
  <h4 class="head4">
    <xsl:text>Figure </xsl:text>
    <xsl:number format="1" count="figure" 
        from="chapter|appendix" level="any"/>
    <xsl:text>. </xsl:text>
    <xsl:apply-templates/>
  </h4>
</xsl:template>

<xsl:template match="table/title">
  <h4 class="head4">
    <xsl:text>Table </xsl:text>
    <xsl:number format="1" count="figure" 
        from="chapter|appendix" level="any"/>
    <xsl:text>. </xsl:text>
    <xsl:apply-templates/>
  </h4>
</xsl:template>

<xsl:template match="title">
  <h4 class="head4">
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
</xsl:template>


<xsl:template match="blockquote">
  <blockquote>
    <xsl:apply-templates/>
  </blockquote>
</xsl:template>


<xsl:template match="remark">
  <blockquote>
    <font color="red"><i>
      <xsl:apply-templates/>
    </i></font>
  </blockquote>
</xsl:template>


<xsl:template match="programlisting | screen | literallayout">
  <blockquote>
    <pre class="code">
      <xsl:apply-templates/>
    </pre>
  </blockquote>
</xsl:template>


<xsl:template match="example">
  <div class="example">
    <xsl:call-template name="drop-anchor"/>
    <xsl:apply-templates/>
  </div>
</xsl:template>


<xsl:template match="figure">
  <div class="figure">
    <xsl:call-template name="drop-anchor"/>
    <xsl:apply-templates select="*[not(self::title)]"/>
  </div>
  <xsl:apply-templates select="title"/>
</xsl:template>


<xsl:template match="graphic">
  <img>
    <xsl:attribute name="src">
      <xsl:value-of select="@fileref"/>
    </xsl:attribute>
  </img>
</xsl:template>


<xsl:template match="sidebar">
  <xsl:call-template name="drop-anchor"/>
  <blockquote>
    <table border="1" cellpadding="6">
      <tr><td>
        <xsl:apply-templates/>
        <xsl:for-each select=".//footnote | .//footnoteref">
          <blockquote class="footnote">
            <xsl:apply-templates/>
          </blockquote>
        </xsl:for-each>
      </td></tr>
    </table>
  </blockquote>
</xsl:template>


<xsl:template match="caution">
  <xsl:call-template name="drop-anchor"/>
  <blockquote class="note">
    <h4 class="objtitle">
      <xsl:text>CAUTION</xsl:text>
    </h4>
    <xsl:apply-templates/>
  </blockquote>
</xsl:template>

<xsl:template match="important">
  <xsl:call-template name="drop-anchor"/>
  <blockquote class="note">
    <h4 class="objtitle">
      <xsl:text>IMPORTANT</xsl:text>
    </h4>
    <xsl:apply-templates/>
  </blockquote>
</xsl:template>

<xsl:template match="note">
  <xsl:call-template name="drop-anchor"/>
  <blockquote class="note">
    <h4 class="objtitle">
      <xsl:text>NOTE</xsl:text>
    </h4>
    <xsl:apply-templates/>
  </blockquote>
</xsl:template>

<xsl:template match="tip">
  <xsl:call-template name="drop-anchor"/>
  <blockquote class="note">
    <h4 class="objtitle">
      <xsl:text>TIP</xsl:text>
    </h4>
    <xsl:apply-templates/>
  </blockquote>
</xsl:template>

<xsl:template match="warning">
  <xsl:call-template name="drop-anchor"/>
  <blockquote class="note">
    <h4 class="objtitle">
      <xsl:text>WARNING</xsl:text>
    </h4>
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
    <xsl:attribute name="name">
      <xsl:text>FNPTR-</xsl:text>
      <xsl:number format="1" count="footnote" 
          from="chapter|appendix|preface" level="any"/>
    </xsl:attribute>
  </a>
  <a>
    <xsl:attribute name="href">
      <xsl:text>#FOOTNOTE-</xsl:text>
      <xsl:number format="1" count="footnote" 
          from="chapter|appendix|preface" level="any"/>
    </xsl:attribute>
    <xsl:text>[</xsl:text>
      <xsl:number format="1" count="footnote" 
          from="chapter|appendix|preface" level="any"/>
    <xsl:text>]</xsl:text>
  </a>
</xsl:template>


<xsl:template name="output-footnote">
  <a>
    <xsl:attribute name="name">
      <xsl:text>FOOTNOTE-</xsl:text>
      <xsl:number format="1" count="footnote" 
          from="chapter|appendix|preface" level="any"/>
    </xsl:attribute>
  </a>
  <xsl:apply-templates/>
</xsl:template>


<xsl:template match="footnote/para[not(preceding-sibling::*)]">
  <p>
    <a>
      <xsl:attribute name="href">
        <xsl:text>#FNPTR-</xsl:text>
        <xsl:number format="1" count="footnote" 
            from="chapter|appendix|preface" level="any"/>
      </xsl:attribute>
      <xsl:text>[</xsl:text>
      <xsl:number format="1" count="footnote" 
          from="chapter|appendix|preface" level="any"/>
      <xsl:text>]</xsl:text>
    </a>
    <xsl:text> </xsl:text>
    <xsl:apply-templates/>
  </p>
</xsl:template>

<xsl:template match="footnote/para[preceding-sibling::*]">
  <p>
    <xsl:apply-templates/>
  </p>
</xsl:template>


<!--
========================================================================
                             XREFS
========================================================================
-->


<xsl:template match="link">
  <xsl:variable name="linkend">
    <xsl:value-of select="@linkend"/>
  </xsl:variable>
  <a>
    <xsl:attribute name="href">
      <xsl:for-each select="//*[@id='$linkend']">
        <xsl:call-template name="filename"/>
      </xsl:for-each>
    </xsl:attribute>
    <xsl:apply-templates/>
  </a>
</xsl:template>


<xsl:template match="xref">
  <xsl:variable name="linkend">
    <xsl:value-of select="@linkend"/>
  </xsl:variable>
  <xsl:choose>
    <xsl:when test="//*[@id=$linkend]">
      <xsl:for-each select="//*[@id=$linkend]">
        <xsl:call-template name="do-xref"/>
      </xsl:for-each>
    </xsl:when>
    <xsl:otherwise>
      <font color="red">
        <xsl:text>[XREF: </xsl:text>
        <xsl:value-of select="@linkend"/>
        <xsl:text>]</xsl:text>
      </font>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>


<xsl:template name="do-xref">
  <a>
    <xsl:attribute name="href">
      <xsl:call-template name="filename"/>
    </xsl:attribute>
    <xsl:choose>

      <xsl:when test="self::appendix">
        <xsl:text>Appendix </xsl:text>
        <xsl:number format="A" value="count(preceding::appendix) +1"/>
      </xsl:when>

      <xsl:when test="self::chapter">
        <xsl:text>Chapter </xsl:text>
        <xsl:number format="1" value="count(preceding::chapter) +1"/>
      </xsl:when>

      <xsl:when test="self::part">
        <xsl:text>Part </xsl:text>
        <xsl:number format="1" value="count(preceding::part) +1"/>
      </xsl:when>

      <xsl:when test="self::preface">
        <xsl:text>the Preface</xsl:text>
      </xsl:when>

      <xsl:when test="self::sect1 or
                      self::sect2 or
                      self::sect3 or
                      self::sect4 or
                      self::refsect1 or
                      self::refsect2">
        <xsl:text>the section </xsl:text>
        <i>
          <xsl:value-of select="title"/>
        </i>
      </xsl:when>

        <xsl:when test="self::figure">
          <xsl:text>Figure </xsl:text>
          <xsl:number format="1" count="figure" 
              from="chapter|appendix" level="any"/>
        </xsl:when>

        <xsl:when test="self::example">
          <xsl:text>Example </xsl:text>
          <xsl:number format="1" count="example" 
              from="chapter|appendix" level="any"/>
        </xsl:when>

        <xsl:when test="self::table">
          <xsl:text>Table </xsl:text>
          <xsl:number format="1" count="table" 
              from="chapter|appendix" level="any"/>
        </xsl:when>

        <xsl:when test="self::refentry">
          <xsl:text>Reference </xsl:text>
          <xsl:number format="1" count="refentry" 
              from="chapter|appendix" level="any"/>
        </xsl:when>

        <xsl:when test="self::sidebar">
          <xsl:text>the sidebar "</xsl:text>
          <xsl:value-of select="title"/>
          <xsl:text>"</xsl:text>
        </xsl:when>

        <xsl:otherwise>
          <xsl:text>{XREF - UNDEFINED PATTERN}</xsl:text>
        </xsl:otherwise>
    </xsl:choose>
  </a>
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


<xsl:template match="callout">
  <xsl:apply-templates/>
</xsl:template>


<xsl:template match="callout/para">
  <xsl:variable name="idref">
    <xsl:value-of select="parent::callout/@idref"/>
  </xsl:variable>
  <p>
    <xsl:for-each select="//*[@id=$idref]">
      <xsl:choose>
        <xsl:when test="@num">
          <xsl:value-of select="@num"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:value-of select="."/>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:for-each>
    <xsl:text>. </xsl:text>
    <xsl:apply-templates/>
  </p>
</xsl:template>


<xsl:template match="co">
  <b>
    <xsl:text>(</xsl:text>
    <xsl:choose>
      <xsl:when test="@num">
        <xsl:value-of select="@num"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="."/>
      </xsl:otherwise>
    </xsl:choose>
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


<xsl:template match="glossseealso">
  <xsl:text>See also </xsl:text>
  <xsl:apply-templates/>
</xsl:template>


<xsl:template match="glossdef">
  <dd>
    <xsl:apply-templates/>
  </dd>
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


<xsl:template match="nutentrybody">
  <xsl:apply-templates/>
</xsl:template>


<xsl:template match="nutsynopsis">
  <p><xsl:apply-templates/></p>
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


<xsl:template match="colspec"/>
<xsl:template match="spanspec"/>


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
  <xsl:param name="spanname">
    <xsl:text>span</xsl:text>
  </xsl:param>
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

<xsl:template match="emphasis[@role='ul']">
  <u class="emphasis-underline"><xsl:apply-templates/></u>
</xsl:template>

<xsl:template match="emphasis[@role='rev']">
  <span class="emphasis-reverse"><xsl:apply-templates/></span>
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


<xsl:template match="lineannotation">
  <i class="lineannotation"><xsl:apply-templates/></i>
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

<xsl:template match="systemitem">
  <xsl:apply-templates/>
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
                          BIBLIOGRAPHY
========================================================================
-->


<xsl:template match="bibliodiv">
  <div class="bibliodiv">
    <dl>
      <xsl:apply-templates/>
    </dl>
  </div>
</xsl:template>


<xsl:template match="bibliodiv/title">
  <h3 class="bibliodiv">
    <xsl:apply-templates/>
  </h3>
</xsl:template>


<xsl:template match="biblioentry">
  <xsl:apply-templates/>
</xsl:template>


<xsl:template match="biblioentry/title">
  <xsl:apply-templates/>
</xsl:template>


<xsl:template match="bibliomisc">
  <xsl:apply-templates/>
</xsl:template>


<xsl:template match="authorgroup">
  <dl>
    <xsl:for-each select="author">
      <dt>
        <xsl:value-of select="firstname"/> 
        <xsl:value-of select="surname"/>
      </dt>
    </xsl:for-each>
  </dl>
</xsl:template>


<xsl:template match="copyright">
  <xsl:apply-templates/>
</xsl:template>


<xsl:template match="copyright/year">
  <xsl:apply-templates/>
</xsl:template>


<xsl:template match="isbn">
  <br/>
  <xsl:apply-templates/>
</xsl:template>


<xsl:template match="publisher">
  <br/>
  <xsl:apply-templates/>
</xsl:template>


<xsl:template match="publisher/publishername">
  <xsl:apply-templates/>
</xsl:template>


<xsl:template match="address">
  <xsl:choose>
    <xsl:when test="@format='linespecific'">
      <pre><xsl:apply-templates/></pre>
    </xsl:when>
    <xsl:otherwise>
      <xsl:apply-templates/>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>


<xsl:template match="address/city">
  <br/>
  <xsl:apply-templates/>
</xsl:template>


<xsl:template match="address/state">
  <br/>
  <xsl:apply-templates/>
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
          <xsl:choose>
            <xsl:when test="refnamediv/refname/@format='roman'">
              <font size="+1"><b>
                <xsl:value-of select="refnamediv/refname"/>
              </b></font>
            </xsl:when>
            <xsl:otherwise>
              <font size="+1"><b><i>
                <xsl:value-of select="refnamediv/refname"/>
              </i></b></font>
            </xsl:otherwise>
          </xsl:choose>
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
          <xsl:for-each select="refsynopsisdiv/synopsis">
            <pre><xsl:apply-templates/></pre>
          </xsl:for-each>
	  <xsl:apply-templates select="refmeta/refmiscinfo[1]"/>
        </td>
        <td align="right">
	  <xsl:apply-templates select="refmeta/refmiscinfo[2]"/>
        </td>
      </tr>
    </table>
    <xsl:apply-templates select="refsynopsisdiv/*"/>
    <xsl:apply-templates select="refsect1"/>
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


<xsl:template match="refsynopsisdiv"/>


<xsl:template match="refsynopsisdiv/synopsis"/>


<xsl:template match="link[classref]">
  <xsl:apply-templates/>
</xsl:template>


<xsl:template match="refentry//function">
  <b class="function">
    <xsl:apply-templates/>
  </b>
  <xsl:text> </xsl:text>
</xsl:template>


<xsl:template match="parameter">
  <i class="parameter">
    <xsl:apply-templates/>
  </i>
</xsl:template>


<xsl:template match="refsect1/title">
  <h4 class="refsect1">
    <xsl:apply-templates/>
  </h4>
</xsl:template>


<xsl:template match="refsect2/title">
  <h4 class="refsect2">
    <xsl:apply-templates/>
  </h4>
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
      <xsl:number count="indexterm" level="any"/>
    </xsl:attribute>
  </a>
</xsl:template>


<!--
========================================================================
                       PROCESSING INSTRUCTIONS
========================================================================
-->

<!-- Change line break PI into a space -->
<xsl:template match="processing-instruction('lb')">
  <xsl:text> </xsl:text>
</xsl:template>


<!--
========================================================================
                            NAMED TEMPLATES
========================================================================
-->

<xsl:template name="authors">
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


<xsl:template name="isbn">
  <xsl:value-of select="/book/bookinfo/isbn"/>
</xsl:template>


<xsl:template name="edition">
  <xsl:value-of select="/book/bookinfo/edition"/>
  <xsl:text> edition</xsl:text>
</xsl:template>


<xsl:template name="pubdate">
  <xsl:value-of select="/book/bookinfo/pubdate"/>
</xsl:template>


<xsl:template name="nickname">
  <xsl:value-of select="/book/bookinfo/productname[@role='nickname']"/>
</xsl:template>


</xsl:stylesheet>
