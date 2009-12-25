<?xml version="1.0"?>

<!--
========================================================================
XSLT Stylesheet to convert DocBook XML into Perl's POD format
Copyright 2001 O'Reilly and Associates
$Id: db2pod.xsl,v 1.1.1.1 2002/03/26 20:08:21 eray Exp $
========================================================================
-->



<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                version="1.0"
>


<!-- ===================================================================
                            GLOBAL STUFF
==================================================================== -->

<!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
                              SETTINGS
-->
<xsl:output method="text"/>
<xsl:strip-space elements="appendix blockquote book caution chapter
  colophon epigraph example footnote important informaltable
  itemizedlist listitem member note orderedlist preface row sect1
  sect2 sect3 sect4 sidebar simplelist simplesect table tbody tgroup
  thead tip variablelist varlistentry warning"/> 


<!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
                              VARIABLES

    newline, dblnewline          create blank lines in output text

-->
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
<xsl:template match="*">
  <xsl:message>
    <xsl:text>Unhandled element: </xsl:text>
    <xsl:value-of select="local-name(.)"/>
  </xsl:message>
  <xsl:apply-templates/>
</xsl:template>


<!-- ===================================================================
                            HIERARCHICAL ELEMENTS
==================================================================== -->

<xsl:template match="book">
  <xsl:apply-templates/>
</xsl:template>

<xsl:template match="bookinfo"/>
<xsl:template match="copyrightpg"/>
<xsl:template match="toc"/>


<!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
                             CHAPTER LEVEL

-->
<xsl:template match="appendix | chapter | colophon | preface">
  <xsl:text>=begin chapter</xsl:text>
  <xsl:value-of select="$newline"/>
  <xsl:call-template name="anchor"/>
  <!-- <xsl:call-template name="legend"/> -->
  <xsl:apply-templates/>
  <xsl:value-of select="$newline"/>
</xsl:template>


<!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
                                SECTIONS

-->
<xsl:template match="sect1 | sect2 | sect3 | sect4 | simplesect">
  <xsl:call-template name="anchor"/>
  <xsl:apply-templates/>
</xsl:template>


<!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
                                TITLES

-->
<xsl:template match="chapter/title | appendix/title | preface/title">
  <xsl:text>=head0 </xsl:text>
  <xsl:apply-templates/>
  <xsl:value-of select="$dblnewline"/>
</xsl:template>

<xsl:template match="sect1/title">
  <xsl:text>=head1 </xsl:text>
  <xsl:apply-templates/>
  <xsl:value-of select="$dblnewline"/>
</xsl:template>

<xsl:template match="sect2/title">
  <xsl:text>=head2 </xsl:text>
  <xsl:apply-templates/>
  <xsl:value-of select="$dblnewline"/>
</xsl:template>

<xsl:template match="sect3/title">
  <xsl:text>=head3 </xsl:text>
  <xsl:apply-templates/>
  <xsl:value-of select="$dblnewline"/>
</xsl:template>

<xsl:template match="sect4/title">
  <xsl:text>=head4 </xsl:text>
  <xsl:apply-templates/>
  <xsl:value-of select="$dblnewline"/>
</xsl:template>

<xsl:template match="title"/>


<!-- ===================================================================
                             BLOCK ELEMENTS
==================================================================== -->

<!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
                             GENERIC BLOCKS

    Simply surround the content in begin/end directives.

-->
<xsl:template match="example | sidebar"> 
  <xsl:text>=begin </xsl:text>
  <xsl:value-of select="local-name(.)"/>
  <xsl:value-of select="$newline"/>
  <xsl:call-template name="anchor"/>
  <xsl:value-of select="$newline"/>
  <xsl:apply-templates/>
  <xsl:value-of select="$newline"/>
  <xsl:text>=end </xsl:text>
  <xsl:value-of select="local-name(.)"/>
  <xsl:value-of select="$dblnewline"/>
</xsl:template>

<xsl:template match="attribution | blockquote | caution | comment |
  epigraph | important | note | programlisting | screen | tip |
  warning">
  <xsl:text>=begin </xsl:text>
  <xsl:value-of select="local-name(.)"/>
  <xsl:value-of select="$newline"/>
  <xsl:apply-templates/>
  <xsl:value-of select="$newline"/>
  <xsl:text>=end </xsl:text>
  <xsl:value-of select="local-name(.)"/>
  <xsl:value-of select="$dblnewline"/>
</xsl:template>


<!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
                             PARAGRAPHS

    Text delimited with blank lines.

-->
<xsl:template match="para">
  <xsl:apply-templates/>
  <xsl:value-of select="$dblnewline"/>
</xsl:template>

<xsl:template match="footnote/para">
  <xsl:apply-templates/>
</xsl:template>


<!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
                                 LISTS

-->
<xsl:template match="itemizedlist | orderedlist | simplelist | variablelist">
  <xsl:text>=over 4</xsl:text>
  <xsl:value-of select="$dblnewline"/>
  <xsl:apply-templates/>
  <xsl:text>=back</xsl:text>
  <xsl:value-of select="$dblnewline"/>
</xsl:template>


<xsl:template match="varlistentry">
  <xsl:apply-templates/>
</xsl:template>


<xsl:template match="varlistentry/term | member">
  <xsl:text>=item </xsl:text>
  <xsl:value-of select="."/>
  <xsl:value-of select="$dblnewline"/>
</xsl:template>


<xsl:template match="varlistentry/listitem">
  <xsl:apply-templates/>
</xsl:template>


 <xsl:template match="itemizedlist/listitem">
  <xsl:text>=item *</xsl:text>
  <xsl:value-of select="$dblnewline"/>
  <xsl:apply-templates/>
</xsl:template>


<xsl:template match="orderedlist/listitem">
  <xsl:text>=item *</xsl:text>
  <xsl:value-of select="$dblnewline"/>
  <xsl:apply-templates/>
</xsl:template>


<!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
                                 FIGURES

-->
<xsl:template match="figure">
  <xsl:text>=begin figure </xsl:text>
  <xsl:value-of select="title"/>
  <xsl:value-of select="$newline"/>
  <xsl:call-template name="anchor"/>
  <xsl:value-of select="$newline"/>
  <xsl:text disable-output-escaping="yes">F&lt;</xsl:text>
  <xsl:value-of select="graphic/@fileref"/>
  <xsl:text disable-output-escaping="yes">&gt;</xsl:text>
  <xsl:value-of select="$newline"/>
  <xsl:text>=end figure</xsl:text>
  <xsl:value-of select="$dblnewline"/>
</xsl:template>


<xsl:template match="graphic">
  <xsl:text>=for graphic</xsl:text>
  <xsl:value-of select="@fileref"/>
  <xsl:value-of select="$dblnewline"/>
</xsl:template>


<!-- ===================================================================
                                TABLES
==================================================================== -->

<xsl:template match="table | informaltable">
  <xsl:text>=begin table html </xsl:text>
  <xsl:value-of select="title"/>
  <xsl:value-of select="$newline"/>
  <xsl:call-template name="anchor"/>
  <xsl:value-of select="$newline"/>
  <xsl:text disable-output-escaping="yes">&lt;table&gt;</xsl:text>
  <xsl:value-of select="$newline"/>
  <xsl:apply-templates/>
  <xsl:text disable-output-escaping="yes">&lt;/table&gt;</xsl:text>
  <xsl:value-of select="$newline"/>
  <xsl:text>=end table</xsl:text>
  <xsl:value-of select="$dblnewline"/>
</xsl:template>


<xsl:template match="colspec | tgroup | thead | tbody">
  <xsl:apply-templates/>
</xsl:template>


<xsl:template match="row">
  <xsl:text disable-output-escaping="yes">&lt;tr&gt;</xsl:text>
  <xsl:apply-templates/>
  <xsl:text disable-output-escaping="yes">&lt;/tr&gt;</xsl:text>
  <xsl:value-of select="$newline"/>
</xsl:template>


<xsl:template match="thead//entry">
  <xsl:text disable-output-escaping="yes">&lt;th&gt;</xsl:text>
  <xsl:apply-templates/>
  <xsl:text disable-output-escaping="yes">&lt;/th&gt;</xsl:text>
</xsl:template>


<xsl:template match="entry">
  <xsl:text disable-output-escaping="yes">&lt;td&gt;</xsl:text>
    <xsl:if test="@spanname">
      <xsl:text> colspan="</xsl:text>
      <xsl:call-template name="getspan">
        <xsl:with-param name="spanname">
          <xsl:value-of select="@spanname"/>
        </xsl:with-param>
      </xsl:call-template>
      <xsl:text disable-output-escaping="yes">"&gt;</xsl:text>
    </xsl:if>
    <xsl:if test="@morerows">
      <xsl:text> rowspan="</xsl:text>
        <xsl:value-of select="@morerows"/>
      <xsl:text disable-output-escaping="yes">"&gt;</xsl:text>
    </xsl:if>
    <xsl:apply-templates/>
  <xsl:text disable-output-escaping="yes">&lt;/td&gt;</xsl:text>
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


<!-- ===================================================================
                              INDEXTERMS
==================================================================== -->

<xsl:template match="indexterm[@class='endofrange']">
  <xsl:value-of select="$newline"/>
  <xsl:text>=for index end-of-range</xsl:text>
  <xsl:value-of select="$newline"/>
  <xsl:text disable-output-escaping="yes">A&lt;</xsl:text>
  <xsl:value-of select="@startref"/>
  <xsl:text disable-output-escaping="yes">&gt;</xsl:text>
  <xsl:value-of select="$dblnewline"/>
</xsl:template>

<xsl:template match="indexterm">
  <xsl:text>=for index </xsl:text>
  <xsl:value-of select="$newline"/>
  <xsl:call-template name="anchor"/>
  <xsl:apply-templates select="primary"/>
  <xsl:if test="secondary">
    <xsl:text>;</xsl:text>
    <xsl:apply-templates select="secondary"/>
  </xsl:if>
  <xsl:if test="tertiary">
    <xsl:text>;</xsl:text>
    <xsl:apply-templates select="tertiary"/>
  </xsl:if>
  <xsl:if test="see | seealso">
    <xsl:text>;;</xsl:text>
    <xsl:apply-templates select="see | seealso"/>
  </xsl:if>
  <xsl:value-of select="$dblnewline"/>
</xsl:template>


<xsl:template match="primary | secondary | tertiary">
  <xsl:apply-templates/>
  <xsl:if test="@sortas">
    <xsl:text>:</xsl:text>
    <xsl:value-of select="@sortas"/>
  </xsl:if>
</xsl:template>


<xsl:template match="see">
  <xsl:text>(see </xsl:text>
  <xsl:value-of select="."/>
  <xsl:text>)</xsl:text>
</xsl:template>


<xsl:template match="seealso">
  <xsl:text>(see also </xsl:text>
  <xsl:value-of select="."/>
  <xsl:text>)</xsl:text>
</xsl:template>


<!-- ===================================================================
                            INLINE ELEMENTS
==================================================================== -->

<xsl:template match="acronym">
  <xsl:apply-templates/>
</xsl:template>


<xsl:template match="citetitle">
  <xsl:text disable-output-escaping="yes">T&lt;</xsl:text>
  <xsl:apply-templates/>
  <xsl:text disable-output-escaping="yes">&gt;</xsl:text>
</xsl:template>


<xsl:template match="command | function | literal">
  <xsl:text disable-output-escaping="yes">C&lt;</xsl:text>
  <xsl:apply-templates/>
  <xsl:text disable-output-escaping="yes">&gt;</xsl:text>
</xsl:template>


<xsl:template match="emphasis | firstterm | foreignphrase | systemitem">
  <xsl:text disable-output-escaping="yes">I&lt;</xsl:text>
  <xsl:apply-templates/>
  <xsl:text disable-output-escaping="yes">&gt;</xsl:text>
</xsl:template>


<xsl:template match="emphasis[@role='bold'] | userinput">
  <xsl:text disable-output-escaping="yes">B&lt;</xsl:text>
  <xsl:apply-templates/>
  <xsl:text disable-output-escaping="yes">&gt;</xsl:text>
</xsl:template>


<xsl:template match="filename">
  <xsl:text disable-output-escaping="yes">F&lt;</xsl:text>
  <xsl:apply-templates/>
  <xsl:text disable-output-escaping="yes">&gt;</xsl:text>
</xsl:template>


<xsl:template match="footnote">
  <xsl:text disable-output-escaping="yes">N&lt;</xsl:text>
  <xsl:apply-templates/>
  <xsl:text disable-output-escaping="yes">&gt;</xsl:text>
</xsl:template>

<xsl:template match="footnoteref">
  <xsl:apply-templates select="id(@linkend)"/>
</xsl:template>



<xsl:template match="replaceable">
  <xsl:text disable-output-escaping="yes">R&lt;</xsl:text>
  <xsl:apply-templates/>
  <xsl:text disable-output-escaping="yes">&gt;</xsl:text>
</xsl:template>


<xsl:template match="superscript">
  <xsl:text>^</xsl:text>
  <xsl:apply-templates/>
</xsl:template>


<xsl:template match="systemitem[@role='url']">
  <xsl:text disable-output-escaping="yes">U&lt;</xsl:text>
  <xsl:value-of select="."/>
  <xsl:text disable-output-escaping="yes">&gt;</xsl:text>
</xsl:template>


<xsl:template match="xref">
  <xsl:text disable-output-escaping="yes">A&lt;</xsl:text>
  <xsl:value-of select="@linkend"/>
  <xsl:text disable-output-escaping="yes">&gt;</xsl:text>
</xsl:template>


<!-- ===================================================================
                            NAMED TEMPLATES
==================================================================== -->

<xsl:template name="anchor">
  <xsl:if test="@id">
    <xsl:text disable-output-escaping="yes">Z&lt;</xsl:text>
    <xsl:value-of select="@id"/>
    <xsl:text disable-output-escaping="yes">&gt;</xsl:text>
    <xsl:value-of select="$newline"/>
  </xsl:if>
</xsl:template>


<xsl:template name="legend">
  <xsl:text disable-output-escaping="yes">=begin comment
||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
                            PSEUDOPOD LEGEND

Interior Sequences
..................
A&lt;&gt;         link anchor (source)
B&lt;&gt;         bold text
C&lt;&gt;         monospace text
E&lt;&gt;         named character
F&lt;&gt;         file name
I&lt;&gt;         italicized text
L&lt;&gt;         link to other manpage (see A&lt;&gt;)
N&lt;&gt;         footnote
R&lt;&gt;         replaceable item
S&lt;&gt;         text with non-breaking spaces
T&lt;&gt;         cited title for book, etc.
U&lt;&gt;         URL
X&lt;&gt;         a single index term of the form:
                  primary:sortas;secondary:sortas;tertiary:sortas;;ETC
                  where ETC is either (see term) or (see also term)
                  only primary term is required
Z&lt;&gt;         link anchor (destination)

Heads
.....
head0                    chapter title
head{1-4}                section title (4 levels)

Command Paragraphs (begin/end Blocks)
.....................................
blockquote               quotation
comment                  ignored text
caution                  admonition
epigraph                 quotation
example                  container
figure CAPTION           figure
important                admonition
note                     admonition
programlisting           literal text
screen                   literal text
sidebar                  container
table html [CAPTION]     table
tip                      admonition
warning                  admonition


Command Paragraphs (for Blocks)
...............................
graphic PATH
indexterm          content form:
                   PRIMARY:SORTAS;SECONDARY:SORTAS;TERTIARY:SORTAS;;ETC
                   where PRIMARY, SECONDARY, TERTIARY are terms
                   SORTAS is a name to sort under
                   ETC is either (see TERM) or (see also TERM)
                   PRIMARY is required, everything else optional

For more information on PSEUDOPOD, write to tools@oreilly.com
||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
=end comment

</xsl:text>
</xsl:template>
</xsl:stylesheet>
