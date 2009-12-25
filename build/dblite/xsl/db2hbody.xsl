<?xml version="1.0"?>

<!--
========================================================================
XSLT Stylesheet to convert DocBook XML into HTML
Copyright 2000 O'Reilly and Associates
$Id: db2hbody.xsl,v 1.24 2003/01/24 21:11:43 eray Exp $

Generates the body of HTML files, leaving the header and footer
for a Perl script to do.
========================================================================
-->

<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                version="1.0"
>

<xsl:include href="sect1.xsl"/>
<xsl:include href="chapter.xsl"/>
<xsl:include href="bookpage.xsl"/>

<xsl:output method="xml"/>

<xsl:variable name="verbose">0</xsl:variable>

<xsl:variable name="newline">
<xsl:text>
</xsl:text>
</xsl:variable>

<xsl:variable name="dblnewline">
<xsl:text>

</xsl:text>
</xsl:variable>

<xsl:template match="/">
  <files>
    <xsl:apply-templates/>
  </files>
</xsl:template>


<xsl:template match="processing-instruction()">
  <xsl:copy/>
</xsl:template>


<xsl:template match="sepfile">
  <xsl:apply-templates/>
</xsl:template>


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


<!--
========================================================================
                          HIERARCHICAL ELEMENTS
========================================================================
-->



<xsl:template match="book">
  <xsl:call-template name="bookpage"/>
  <xsl:apply-templates select="preface"/>
  <xsl:apply-templates select="part | chapter | appendix"/>
  <xsl:apply-templates select="bibliography | glossary"/>
  <xsl:apply-templates select="colophon"/>
</xsl:template>


<xsl:template match="  appendix 
                     | chapter
                     | dedication
                     | preface
                     | bibliography
                     | glossary
                     | colophon
                     | part">
  <xsl:call-template name="chapter"/>
</xsl:template>


<xsl:template match="index">
  <xsl:if test="$verbose = 1">
    <xsl:message>
      <xsl:text>  </xsl:text>
      <xsl:text>Index</xsl:text>
      <xsl:value-of select="$newline"/>
    </xsl:message>
  </xsl:if>
  <file>
    <xsl:attribute name="name">index/index.htm</xsl:attribute>
    <label>Index</label>
    <number></number>
  </file>
</xsl:template>


<xsl:template match="simplesect | partintro">
  <xsl:if test="$verbose = 1">
    <xsl:message>
      <xsl:text>    </xsl:text>
      <xsl:text>Preamble</xsl:text>
      <xsl:value-of select="$newline"/>
    </xsl:message>
  </xsl:if>
  <xsl:apply-templates/>
</xsl:template>


<xsl:template match="sect1">
  <xsl:choose>
    <xsl:when test="preceding-sibling::sect1">
      <xsl:call-template name="sect1"/>
    </xsl:when>
    <xsl:otherwise>
      <div class="sect1">
        <xsl:call-template name="drop-anchor"/>
        <xsl:apply-templates/>
      </div>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>


<xsl:template match="sect2">
  <xsl:call-template name="drop-anchor"/>
  <div class="sect2">
    <xsl:apply-templates/>
  </div>
</xsl:template>


<xsl:template match="sect3">
  <xsl:call-template name="drop-anchor"/>
  <div class="sect3">
    <xsl:apply-templates/>
  </div>
</xsl:template>


<xsl:template match="sect4">
  <xsl:call-template name="drop-anchor"/>
  <div class="sect4">
    <xsl:apply-templates/>
  </div>
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


<!--
========= Part
-->
<xsl:template match="part/title">
  <h1 class="chapter">
    <xsl:text>Part </xsl:text>
    <xsl:call-template name="chaplevel"/>
    <xsl:text>. </xsl:text>
    <xsl:apply-templates/>
  </h1>
  <xsl:if test="$verbose = 1">
    <xsl:message>
      <xsl:text>Transforming Part </xsl:text>
      <xsl:number format="I" value="count(preceding::part)+1"/>
      <xsl:value-of select="$newline"/>
    </xsl:message>
  </xsl:if>
</xsl:template>


<!--
========= Appendix
-->

<xsl:template match="appendix/title">
  <h1 class="chapter">
    <xsl:text>Appendix </xsl:text>
    <xsl:call-template name="chaplevel"/>
    <xsl:text>. </xsl:text>
    <xsl:apply-templates/>
  </h1>
  <xsl:variable name="role" select="../@role"/>
  <xsl:if test="not($role='notoc') and 
                count(following-sibling::sect1)>0">
    <xsl:value-of select="$newline"/>
    <xsl:call-template name="mini-toc"/>
  </xsl:if>
  <xsl:if test="$verbose = 1">
    <xsl:message>
      <xsl:text>  </xsl:text>
      <xsl:text>Transforming Appendix </xsl:text>
      <xsl:number format="A" value="count(preceding::appendix)+1"/>
      <xsl:value-of select="$newline"/>
    </xsl:message>
  </xsl:if>
</xsl:template>


<!--
========= Chapter
-->
<xsl:template match="chapter/title">
  <h1 class="chapter">
    <xsl:text>Chapter </xsl:text>
    <xsl:call-template name="chaplevel"/>
    <xsl:text>. </xsl:text>
    <xsl:apply-templates/>
  </h1>
  <xsl:variable name="role" select="../@role"/>
  <xsl:if test="not($role='notoc') and 
                count(following-sibling::sect1)>0">
    <xsl:value-of select="$newline"/>
    <xsl:call-template name="mini-toc"/>
  </xsl:if>
  <xsl:if test="$verbose = 1">
    <xsl:message>
      <xsl:text>  </xsl:text>
      <xsl:text>Transforming Chapter </xsl:text>
      <xsl:number format="1" value="count(preceding::chapter)+1"/>
      <xsl:value-of select="$newline"/>
   </xsl:message>
  </xsl:if>
</xsl:template>


<!--
========= Dedication
-->
<xsl:template match="dedication/title">
  <h1 class="chapter">Dedication</h1>
  <xsl:if test="$verbose = 1">
    <xsl:message>
      <xsl:text>  </xsl:text>
      <xsl:text>Transforming Dedication</xsl:text>
      <xsl:value-of select="$newline"/>
    </xsl:message>
  </xsl:if>
</xsl:template>


<!--
========= Colophon
-->
<xsl:template match="colophon/title">
  <h1 class="chapter">Colophon</h1>
  <xsl:if test="$verbose = 1">
    <xsl:message>
      <xsl:text>  </xsl:text>
      <xsl:text>Transforming Colophon</xsl:text>
      <xsl:value-of select="$newline"/>
    </xsl:message>
  </xsl:if>
</xsl:template>


<!--
========= Preface
-->
<xsl:template match="preface/title">
  <h1 class="chapter">Preface</h1>
  <xsl:if test="$verbose = 1">
    <xsl:message>
      <xsl:text>  </xsl:text>
      <xsl:text>Transforming Preface</xsl:text>
      <xsl:value-of select="$newline"/>
    </xsl:message>
  </xsl:if>
</xsl:template>


<!--
========= Bibliography
-->
<xsl:template match="bibliography/title">
  <h1 class="chapter">Bibliography</h1>
  <xsl:if test="$verbose = 1">
    <xsl:message>
      <xsl:text>  </xsl:text>
      <xsl:text>Transforming Bibliography</xsl:text>
      <xsl:value-of select="$newline"/>
    </xsl:message>
  </xsl:if>
</xsl:template>


<!--
========= Section
-->

<xsl:template match="sect1/title | section/title">
  <h2 class="sect1">
    <xsl:choose>
      <xsl:when test="../@label">
        <xsl:value-of select="../@label"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:text>0.</xsl:text>
        <xsl:value-of select="count(../preceding-sibling::sect1)+1"/>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:text>. </xsl:text>
    <xsl:apply-templates/>
  </h2>
  <xsl:if test="$verbose = 1">
    <xsl:message>
      <xsl:text>    </xsl:text>
      <xsl:text>Section </xsl:text>
      <xsl:if test="not(../@label)">
        <xsl:text>0.</xsl:text>
        <xsl:value-of select="count(../preceding-sibling::sect1)+1"/>
      </xsl:if>
      <xsl:value-of select="../@label"/>
      <xsl:text>. </xsl:text>
      <xsl:value-of select="$newline"/>
    </xsl:message>
  </xsl:if>
</xsl:template>


<xsl:template match="sect2/title | section/section/title">
  <h3 class="sect2">
    <xsl:value-of select="../@label"/>
    <xsl:text>. </xsl:text>
    <xsl:apply-templates/>
  </h3>
</xsl:template>


<xsl:template match="sect3/title | section/section/section/title">
  <h3 class="sect3">
    <xsl:value-of select="../@label"/>
    <xsl:text>. </xsl:text>
    <xsl:apply-templates/>
  </h3>
</xsl:template>


<xsl:template match="sect4/title |
                     section/section/section/section/title">
  <h4 class="sect4">
    <xsl:value-of select="../@label"/>
    <xsl:text>. </xsl:text>
    <xsl:apply-templates/>
  </h4>
</xsl:template>


<!--
========= Example
-->

<xsl:template match="example/title">
  <h4 class="objtitle">
    <xsl:text>Example </xsl:text>
    <xsl:value-of select="../@label"/>
    <xsl:text>. </xsl:text>
    <xsl:apply-templates/>
  </h4>
</xsl:template>


<!--
========= Figure
-->

<xsl:template match="figure/title">
  <h4 class="objtitle">
    <xsl:text>Figure </xsl:text>
    <xsl:value-of select="../@label"/>
    <xsl:text>. </xsl:text>
    <xsl:apply-templates/>
  </h4>
</xsl:template>


<!--
========= Table
-->

<xsl:template match="table/title">
  <h4 class="objtitle">
    <xsl:text>Table </xsl:text>
    <xsl:value-of select="../@label"/>
    <xsl:text>. </xsl:text>
    <xsl:apply-templates/>
  </h4>
</xsl:template>


<!--
========= Generic
-->

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

<xsl:template match="remark">
  <p>
    <font color="red"><i>
      <xsl:apply-templates/>
    </i></font>
  </p>
</xsl:template>


<xsl:template match="blockquote">
  <blockquote class="blockquote">
    <xsl:apply-templates/>
  </blockquote>
</xsl:template>


<xsl:template match="epigraph">
  <blockquote class="epigraph">
    <xsl:apply-templates/>
  </blockquote>
</xsl:template>


<xsl:template match="attribution">
  <p class="attribution">
    <xsl:apply-templates/>
  </p>
</xsl:template>


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


<xsl:template match="programlisting | screen | literallayout">
  <blockquote>
    <pre class="code">
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


<xsl:template match="graphic">
  <img>
    <xsl:attribute name="src">
      <xsl:value-of select="@fileref"/>
    </xsl:attribute>
    <xsl:attribute name="alt">
      <xsl:text>Figure </xsl:text>
      <xsl:value-of select="../@label"/>
    </xsl:attribute>
    <xsl:if test="@width">
      <xsl:attribute name="width">
        <xsl:value-of select="@width"/>
      </xsl:attribute>
    </xsl:if>
    <xsl:if test="@height">
      <xsl:attribute name="height">
        <xsl:value-of select="@height"/>
      </xsl:attribute>
    </xsl:if>
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
              <xsl:text>NOTE:</xsl:text>
            </xsl:when>
            <xsl:when test="self::tip">
              <xsl:text>TIP:</xsl:text>
            </xsl:when>
            <xsl:when test="self::warning">
              <xsl:text>WARNING:</xsl:text>
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
      <xsl:number count="footnote" level="any" format="1"/>
    </xsl:attribute>
    <xsl:text>[</xsl:text>
      <xsl:number count="footnote" level="any" format="1"/>
    <xsl:text>]</xsl:text>
  </a>
</xsl:template>


<xsl:template match="footnote/para">
  <a>
    <xsl:attribute name="name">
      <xsl:text>FOOTNOTE-</xsl:text>
      <xsl:number count="footnote" level="any" format="1"/>
    </xsl:attribute>
  </a>
  <p>
    <xsl:if test="count(preceding-sibling::para)=0">
      <xsl:text>[</xsl:text>
        <xsl:number count="footnote" level="any" format="1"/>
      <xsl:text>]</xsl:text>
    </xsl:if>
    <xsl:apply-templates/>
  </p>
</xsl:template>


<xsl:template match="footnoteref">
  <a>
    <xsl:attribute name="href">
      <xsl:text>#FOOTNOTE-</xsl:text>
      <xsl:for-each select="id(@linkend)">
        <xsl:number count="footnote" level="any" format="1"/>
      </xsl:for-each>
    </xsl:attribute>
    <xsl:text>[</xsl:text>
    <xsl:for-each select="id(@linkend)">
      <xsl:number count="footnote" level="any" format="1"/>
    </xsl:for-each>
    <xsl:text>]</xsl:text>
  </a>
</xsl:template>


<!--
========================================================================
                             XREFS
========================================================================
-->


<xsl:template match="link">
  <xsl:variable name="ident">
    <xsl:value-of select="@linkend"/>
  </xsl:variable>
  <a>
    <xsl:attribute name="href">
      <xsl:for-each select="//*[@id=$ident]">
        <xsl:call-template name="filename"/>
	<xsl:if test="ancestor::appendix | 
                      ancestor::chapter |
                      ancestor::preface">
          <xsl:text>#</xsl:text>
          <xsl:value-of select="$ident"/>
        </xsl:if>
      </xsl:for-each>
    </xsl:attribute>
    <xsl:apply-templates/>
  </a>
</xsl:template>


<!-- 
this is deprecated in Safari books in favor of <link> which
contains the content of the A element.
-->
<xsl:template match="xref">
  <xsl:variable name="ident">
    <xsl:value-of select="@linkend"/>
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
        <xsl:when test="self::appendix">
          <xsl:text>Appendix </xsl:text>
          <xsl:call-template name="chaplevel"/>
          <xsl:text>, "</xsl:text>
          <xsl:value-of select="title"/>
          <xsl:text>"</xsl:text>
        </xsl:when>

        <xsl:when test="self::chapter">
          <xsl:text>Chapter </xsl:text>
          <xsl:call-template name="chaplevel"/>
          <xsl:text>, "</xsl:text>
          <xsl:value-of select="title"/>
          <xsl:text>"</xsl:text>
        </xsl:when>

        <xsl:when test="self::part">
          <xsl:text>Part </xsl:text>
          <xsl:call-template name="chaplevel"/>
          <xsl:text>, "</xsl:text>
          <xsl:value-of select="title"/>
          <xsl:text>"</xsl:text>
        </xsl:when>

        <xsl:when test="self::preface">
          <xsl:text>the Preface</xsl:text>
        </xsl:when>

        <xsl:when test="self::sect1 and ancestor::preface">
          <xsl:text>Section 0.</xsl:text>
          <xsl:value-of select="count(preceding-sibling::sect1)+1"/>
          <xsl:text>, "</xsl:text>
          <xsl:value-of select="title"/>
          <xsl:text>"</xsl:text>
        </xsl:when>

        <xsl:when test="self::sect1 or
                        self::sect2 or
                        self::sect3 or
                        self::sect4">
          <xsl:text>Section </xsl:text>
          <xsl:value-of select="@label"/>
          <xsl:text>, "</xsl:text>
          <xsl:value-of select="title"/>
          <xsl:text>"</xsl:text>
        </xsl:when>

        <xsl:when test="self::figure">
          <xsl:text>Figure </xsl:text>
          <xsl:value-of select="@label"/>
        </xsl:when>

        <xsl:when test="self::example">
          <xsl:text>Example </xsl:text>
          <xsl:value-of select="@label"/>
        </xsl:when>

        <xsl:when test="self::table">
          <xsl:text>Table </xsl:text>
          <xsl:value-of select="@label"/>
        </xsl:when>

        <xsl:when test="self::refentry">
          <xsl:text>Reference </xsl:text>
          <xsl:value-of select="@label"/>
        </xsl:when>

        <xsl:when test="self::sidebar">
          <xsl:text>the sidebar "</xsl:text>
          <xsl:value-of select="title"/>
          <xsl:text>"</xsl:text>
        </xsl:when>

        <xsl:otherwise>
          <xsl:text>{XREF}</xsl:text>
        </xsl:otherwise>

      </xsl:choose>
    </a>
  </xsl:for-each>
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


<xsl:template match="colspec"/>
<xsl:template match="spanspec"/>


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
  <i class="systemitem"><xsl:apply-templates/></i>
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
  <xsl:call-template name="proc-refentry"/>
</xsl:template>


<xsl:template match="refentry/refentry">
  <blockquote>
    <xsl:call-template name="proc-refentry"/>
  </blockquote>
</xsl:template>


<xsl:template name="proc-refentry">
  <xsl:call-template name="drop-anchor"/>
  <xsl:apply-templates select=".//indexterm"/>
  <xsl:if test="$verbose = 1">
    <xsl:message>
      <xsl:text>    </xsl:text>
      <xsl:text>Refentry </xsl:text>
      <xsl:choose>
        <xsl:when test="@label">
          <xsl:value-of select="@label"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:value-of select="count(preceding-sibling::refentry)+1"/>
        </xsl:otherwise>
      </xsl:choose>
      <xsl:text>. </xsl:text>
      <xsl:value-of select="$newline"/>
    </xsl:message>
  </xsl:if>
  <xsl:choose>
    <xsl:when test="refnamediv/refpurpose">
      <xsl:call-template name="refentry-style1"/>
    </xsl:when>
    <xsl:otherwise>
      <xsl:call-template name="refentry-style2"/>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>


<xsl:template name="refentry-style1">
<!--
refname                          refpurpose
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
refmiscinfo[1]               refmiscinfo[2]
-->
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
    <xsl:apply-templates select="refentry"/>
  </div>
</xsl:template>


<xsl:template name="refentry-style2">
<!--
refname                      refmiscinfo[1]
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
refmiscinfo[2]               refmiscinfo[3]
-->
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
	  <xsl:apply-templates select="refmeta/refmiscinfo[1]"/>
        </td>
      </tr>
    </table>
    <hr width="515" size="3" noshade="true" align="left" color="black"/>
    <table width="515" border="0" cellpadding="5">
      <tr>
        <td align="left">
	  <xsl:apply-templates select="refmeta/refmiscinfo[2]"/>
        </td>
        <td align="right">
	  <xsl:apply-templates select="refmeta/refmiscinfo[3]"/>
        </td>
      </tr>
    </table>
    <xsl:for-each select="refsynopsisdiv/synopsis">
      <pre><xsl:apply-templates/></pre>
    </xsl:for-each>
    <xsl:apply-templates select="refsynopsisdiv/*"/>
    <xsl:apply-templates select="refsect1"/>
    <xsl:apply-templates select="refentry"/>
  </div>
</xsl:template>


<xsl:template match="refsect1">
  <xsl:apply-templates/>
</xsl:template>


<xsl:template match="refmiscinfo">
  <tt>
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
      <xsl:value-of select="@id"/>
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


<!--
========= chaplevel

Return string with label-number for the ancestor that is at the
chapter level.

-->

<xsl:template name="chaplevel">
  <xsl:choose>
    <xsl:when test="ancestor-or-self::preface">
      <xsl:text>0</xsl:text>
    </xsl:when>
    <xsl:when test="ancestor-or-self::chapter">
      <xsl:number count="chapter" level="any" format="1"/>
    </xsl:when>
    <xsl:when test="ancestor-or-self::appendix">
      <xsl:number count="appendix" level="any" format="A"/>
    </xsl:when>
    <xsl:when test="ancestor-or-self::part">
      <xsl:number count="part" level="any" format="I"/>
    </xsl:when>
  </xsl:choose>
</xsl:template>


<!--
========= label

Return string containing the full label-number of an element and/or
its title.

-->

<xsl:template name="label">
  <xsl:choose>
    <xsl:when test="ancestor-or-self::preface/@role='copyrightpg'">
      <xsl:text>Copyright Page</xsl:text>
    </xsl:when>
    <xsl:when test="ancestor-or-self::colophon">
      <xsl:text>Colophon</xsl:text>
    </xsl:when>
    <xsl:when test="ancestor-or-self::index">
      <xsl:text>Index</xsl:text>
    </xsl:when>
    <xsl:when test="ancestor-or-self::dedication">
      <xsl:text>Dedication</xsl:text>
    </xsl:when>
    <xsl:when test="ancestor-or-self::bibliography">
      <xsl:text>Bibliography</xsl:text>
    </xsl:when>
    <xsl:when test="ancestor-or-self::glossary">
      <xsl:text>Glossary</xsl:text>
    </xsl:when>
    <xsl:when test="not(ancestor-or-self::preface) and
                    not(ancestor-or-self::part) and
                    not(ancestor-or-self::chapter) and
                    not(ancestor-or-self::appendix)">
      <xsl:text>Table of Contents</xsl:text>
    </xsl:when>
    <xsl:when test="self::sect1 and ancestor::preface">
      <xsl:text>0.</xsl:text>
      <xsl:value-of select="count(preceding-sibling::sect1)+1"/>
      <xsl:text>. </xsl:text>
      <xsl:value-of select="title"/>
    </xsl:when>
    <xsl:when test="self::preface">
      <xsl:text>Preface</xsl:text>
    </xsl:when>
    <xsl:otherwise>
      <xsl:value-of select="@label"/>
      <xsl:text>. </xsl:text>
      <xsl:value-of select="title"/>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>


<!--
========= filename

Generate a filename that would contain the current node.

-->

<xsl:template name="filename">

  <!-- beginning part -->
  <xsl:choose>
    <xsl:when test="ancestor-or-self::preface/@role='copyrightpg'">
      <xsl:text>copyrght</xsl:text>
    </xsl:when>
    <xsl:when test="ancestor-or-self::index">
      <xsl:text>index/index</xsl:text>
    </xsl:when>
    <xsl:when test="ancestor-or-self::colophon">
      <xsl:text>colophon</xsl:text>
    </xsl:when>
    <xsl:when test="ancestor-or-self::dedication">
      <xsl:text>dedication</xsl:text>
    </xsl:when>
    <xsl:when test="ancestor-or-self::appendix">
      <xsl:text>app</xsl:text>
      <xsl:number count="appendix" level="any" format="a"/>
      <xsl:text>_</xsl:text>
    </xsl:when>
    <xsl:when test="ancestor-or-self::chapter">
      <xsl:text>ch</xsl:text>
      <xsl:number count="chapter" level="any" format="01"/>
      <xsl:text>_</xsl:text>
    </xsl:when>
    <xsl:when test="ancestor-or-self::preface">
      <xsl:text>ch00_</xsl:text>
    </xsl:when>
    <xsl:when test="ancestor-or-self::part">
      <xsl:text>part</xsl:text>
      <xsl:number count="part" level="any" format="1"/>
    </xsl:when>
    <xsl:when test="ancestor-or-self::glossary">
      <xsl:text>gloss</xsl:text>
    </xsl:when>
    <xsl:when test="ancestor-or-self::bibliography">
      <xsl:text>biblio</xsl:text>
    </xsl:when>
    <xsl:when test="ancestor-or-self::book">
      <xsl:text>index</xsl:text>
    </xsl:when>
  </xsl:choose>

  <!-- middle part -->
  <xsl:choose>
    <xsl:when test="ancestor-or-self::part and
                    not( ancestor-or-self::chapter ) and
                    not( ancestor-or-self::appendix )"/>
    <xsl:when test="ancestor-or-self::partintro or
                    ancestor-or-self::glossary or
                    ancestor-or-self::bibliography or
                    ancestor-or-self::preface/@role='copyrightpg' or
                    ancestor-or-self::dedication or
                    ancestor-or-self::index or
                    ancestor-or-self::colophon"/>
    <xsl:when test="ancestor-or-self::sect1">
<!-- fix for LibXSLT wackiness -->

      <xsl:number 
        value="count(ancestor-or-self::sect1/preceding-sibling::sect1)+1"
	format="01"/>

<!-- This seems not to be working correctly for LibXSLT:

      <xsl:number count="sect1" level="any"
                  from="appendix | chapter | preface | part" 
                  format="01"/>
-->
    </xsl:when>
    <xsl:otherwise>
      <xsl:text>01</xsl:text>
    </xsl:otherwise>
  </xsl:choose>

  <!-- end part -->
  <xsl:text>.htm</xsl:text>
</xsl:template>


<!--
========= mini-toc

Generate a chapter table of contents.

-->

<xsl:template name="mini-toc">
  <div class="htmltoc">
    <h4 class="tochead">Contents:</h4>
    <p>
      <xsl:for-each select="../sect1">
        <xsl:value-of select="$newline"/>
        <a>
          <xsl:attribute name="href">
            <xsl:call-template name="filename"/>
	    <xsl:if test="not( preceding-sibling::sect1 )">
              <xsl:text>#</xsl:text>
              <xsl:value-of select="@id"/>
            </xsl:if>
          </xsl:attribute>
          <xsl:value-of select="title"/>
        </a>
        <br/>
      </xsl:for-each>
    </p>
  </div> 
</xsl:template>


<!--
toc
===
Build a list of high-level elements

-->
<xsl:template name="toc">
  <xsl:if test="preface/@role='copyrightpg'">
    <xsl:value-of select="$newline"/>
    <a href="copyrght.htm">Copyright Page</a>
    <br/>
  </xsl:if>

  <xsl:if test="dedication">
    <xsl:value-of select="$newline"/>
    <a href="dedication.htm">Dedication</a>
    <br/>
  </xsl:if>

  <xsl:if test="count(preface)>0">
    <xsl:value-of select="$newline"/>
    <xsl:for-each select="preface">
      <a>
        <xsl:attribute name="href">
          <xsl:call-template name="filename"/>
        </xsl:attribute>
        <xsl:value-of select="title"/>
      </a>
      <br/>
    </xsl:for-each>
  </xsl:if>

  <xsl:if test="count(chapter)>0">
    <xsl:value-of select="$newline"/>
    <xsl:for-each select="chapter">
      <xsl:value-of select="$newline"/>
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
  </xsl:if>

  <xsl:if test="count(appendix)>0">
    <xsl:value-of select="$newline"/>
    <xsl:for-each select="appendix">
      <xsl:value-of select="$newline"/>
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
  </xsl:if>

  <xsl:for-each select="part">
    <xsl:value-of select="$newline"/>
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
        <xsl:value-of select="$newline"/>
        <a>
          <xsl:attribute name="href">
            <xsl:call-template name="filename"/>
          </xsl:attribute>
          <xsl:value-of select="title"/>
        </a>
        <br/>
      </xsl:for-each>
      <xsl:for-each select="chapter">
        <xsl:value-of select="$newline"/>
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
        <xsl:value-of select="$newline"/>
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

  <xsl:if test="glossary">
    <xsl:value-of select="$newline"/>
    <a href="gloss.htm">Glossary</a>
    <br/>
  </xsl:if>

  <xsl:if test="bibliography">
    <xsl:value-of select="$newline"/>
    <a href="biblio.htm">Bibliography</a>
    <br/>
  </xsl:if>

  <xsl:value-of select="$newline"/>
  <a href="index/index.htm">Index</a>
  <br/>

  <xsl:if test="colophon">
    <xsl:value-of select="$newline"/>
    <a href="colophon.htm">Colophon</a>
  </xsl:if>

</xsl:template>


<!--
authors
=======
Return a string containing authors' names.

-->
<xsl:template name="authors">
  <xsl:for-each select="/book/safarimeta/authorgroup/author">
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
  <xsl:value-of select="/book/safarimeta/isbn"/>
</xsl:template>


<!--
edition
=======
Return a string containing the edition number.

-->
<xsl:template name="edition">
  <xsl:value-of select="/book/safarimeta/edition"/>
  <xsl:text> edition</xsl:text>
</xsl:template>


<!--
pubdate
=======
Return a string containing the last-published date.

-->
<xsl:template name="pubdate">
  <xsl:value-of select="/book/safarimeta/pubdate"/>
</xsl:template>


<!--
book-url
========
Return a string containing the book's nickname.

-->
<xsl:template name="book-url">
  <xsl:value-of select="/book/safarimeta/bibliomisc[@role='catalog-page']"/>
</xsl:template>


</xsl:stylesheet>
