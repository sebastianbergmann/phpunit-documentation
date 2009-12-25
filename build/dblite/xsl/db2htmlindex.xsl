<?xml version="1.0"?>

<!--
========================================================================
XSLT Stylesheet by Erik Ray
Copyright 2000 O'Reilly and Associates
$Id: db2htmlindex.xsl,v 1.3 2002/09/03 17:37:28 eray Exp $

Creates HTML a temporary file containing all <indexterm>s from a book
with extra information in attributes, such as title and ordinal value.

Input: DocBook Lite XML document
Output: XML file with <indexterm>s
========================================================================
-->


<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:xt="http://www.jclark.com/xt"
                extension-element-prefixes="xt"
		version="1.0">




<xsl:variable name="newline">
<xsl:text>
</xsl:text>
</xsl:variable>

<xsl:variable name="dblnewline">
<xsl:text>

</xsl:text>
</xsl:variable>



<xsl:template match="indexterm[*]">
  <xsl:choose>
    <xsl:when test="@class='endofrange'"/>
    <xsl:otherwise>
      <indexterm>
        <xsl:attribute name="id">
          <xsl:value-of select="@id"/>
        </xsl:attribute>
        <xsl:attribute name="file">
          <xsl:call-template name="filename"/>
        </xsl:attribute>
        <xsl:attribute name="sect">
          <xsl:call-template name="sect-number"/>
        </xsl:attribute>
        <xsl:apply-templates/>
      </indexterm>
      <xsl:value-of select="$dblnewline"/>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>


<xsl:template match="indexterm/*">
  <xsl:if test="position()=1">
    <xsl:value-of select="$newline"/>
  </xsl:if>
  <xsl:copy>
    <xsl:if test="@sortas">
      <xsl:attribute name="sortas">
        <xsl:value-of select="@sortas"/>
      </xsl:attribute>
    </xsl:if>
    <xsl:apply-templates/>
  </xsl:copy>
  <xsl:value-of select="$newline"/>
</xsl:template>


<xsl:template match="indexterm//text()">
  <xsl:value-of select="."/>
</xsl:template>


<xsl:template match="text()"/>


<!--
sect-number
=============
Return number of object in current chapter.

-->
<xsl:template name="sect-number">

  <xsl:variable name="chaplevel">
    <xsl:choose>
      <xsl:when test="ancestor::appendix">
        <xsl:number value="ancestor-or-self::appendix/@label" format="A"/>
      </xsl:when>
      <xsl:when test="ancestor::chapter">
        <xsl:value-of select="ancestor-or-self::chapter/@label"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:text>0</xsl:text>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:variable>

  <xsl:choose>
    <xsl:when test="ancestor::sect4">
      <xsl:value-of select="$chaplevel"/>
      <xsl:text>.</xsl:text>
      <xsl:value-of select="substring-after(ancestor::sect4/@label,'.')"/>
      <xsl:text>. </xsl:text>
      <xsl:value-of select="ancestor::sect4/title"/>
    </xsl:when>

    <xsl:when test="ancestor::sect3">
      <xsl:value-of select="$chaplevel"/>
      <xsl:text>.</xsl:text>
      <xsl:value-of select="substring-after(ancestor::sect3/@label,'.')"/>
      <xsl:text>. </xsl:text>
      <xsl:value-of select="ancestor::sect3/title"/>
    </xsl:when>

    <xsl:when test="ancestor::sect2">
      <xsl:value-of select="$chaplevel"/>
      <xsl:text>.</xsl:text>
      <xsl:value-of select="substring-after(ancestor::sect2/@label,'.')"/>
      <xsl:text>. </xsl:text>
      <xsl:value-of select="ancestor::sect2/title"/>
    </xsl:when>

    <xsl:when test="ancestor::sect1">
      <xsl:value-of select="$chaplevel"/>
      <xsl:text>.</xsl:text>
      <xsl:value-of select="substring-after(ancestor::sect1/@label,'.')"/>
      <xsl:text>. </xsl:text>
      <xsl:value-of select="ancestor::sect1/title"/>
    </xsl:when>

    <xsl:when test="ancestor::appendix">
      <xsl:value-of select="$chaplevel"/>
      <xsl:text>. </xsl:text>
      <xsl:value-of select="ancestor::appendix/title"/>
    </xsl:when>

    <xsl:when test="ancestor::chapter">
      <xsl:value-of select="$chaplevel"/>
      <xsl:text>. </xsl:text>
      <xsl:value-of select="ancestor::chapter/title"/>
    </xsl:when>

    <xsl:when test="ancestor::preface">
      <xsl:value-of select="$chaplevel"/>
      <xsl:text>. </xsl:text>
      <xsl:value-of select="ancestor::preface/title"/>
    </xsl:when>

    <xsl:when test="ancestor::glossary">
      <xsl:text>Gloss</xsl:text>
    </xsl:when>

  </xsl:choose>
</xsl:template>


<!--
filename
========
Return the filename that contains the current node.

-->
<xsl:template name="filename">
  <xsl:choose>
    <xsl:when test="self::appendix">
      <xsl:text>app</xsl:text>
      <xsl:number value="count(preceding::appendix)+1" format="a"/>
      <xsl:text>_01.htm</xsl:text>
    </xsl:when>

    <xsl:when test="self::chapter">
      <xsl:text>ch</xsl:text>
      <xsl:number value="count(preceding::chapter)+1" format="01"/>
      <xsl:text>_01.htm</xsl:text>
    </xsl:when>

    <xsl:when test="self::part">
      <xsl:text>part</xsl:text>
      <xsl:number value="count(preceding::part)+1" format="1"/>
      <xsl:text>.htm</xsl:text>
    </xsl:when>

    <xsl:when test="self::preface">ch00_01.htm</xsl:when>

    <xsl:when test="self::glossary">gloss.htm</xsl:when>

    <xsl:when test="parent::appendix">
      <xsl:text>app</xsl:text>
      <xsl:number value="count(preceding::appendix)+1" format="a"/>
      <xsl:text>_</xsl:text>
      <xsl:number value="count(preceding-sibling::sect1)+1" format="01"/>
      <xsl:text>.htm</xsl:text>
    </xsl:when>

    <!-- I am a sect1 -->

    <xsl:when test="parent::chapter">
      <xsl:text>ch</xsl:text>
      <xsl:number value="count(preceding::chapter)+1" format="01"/>
      <xsl:text>_</xsl:text>
      <xsl:number value="count(preceding-sibling::sect1)+1" format="01"/>
      <xsl:text>.htm</xsl:text>
    </xsl:when>

    <xsl:when test="parent::preface">
      <xsl:text>ch00_</xsl:text>
      <xsl:number value="count(preceding-sibling::sect1)+1" format="01"/>
      <xsl:text>.htm</xsl:text>
    </xsl:when>

    <xsl:when test="parent::glossary">gloss.htm</xsl:when>

    <!-- I am inside a sect1 -->

    <xsl:when test="ancestor::appendix">
      <xsl:text>app</xsl:text>
      <xsl:number value="count(preceding::appendix)+1" format="a"/>
      <xsl:text>_</xsl:text>
      <xsl:number value="count(ancestor::sect1/preceding-sibling::sect1)+1"
          format="01"/>
      <xsl:text>.htm</xsl:text>
    </xsl:when>

    <xsl:when test="ancestor::chapter">
      <xsl:text>ch</xsl:text>
      <xsl:number value="count(preceding::chapter)+1" format="01"/>
      <xsl:text>_</xsl:text>
      <xsl:number value="count(ancestor::sect1/preceding-sibling::sect1)+1"
          format="01"/>
      <xsl:text>.htm</xsl:text>
    </xsl:when>

    <xsl:when test="ancestor::preface">
      <xsl:text>ch00_</xsl:text>
      <xsl:number value="count(ancestor::sect1/preceding-sibling::sect1)+1"
          format="01"/>
      <xsl:text>.htm</xsl:text>
    </xsl:when>

    <xsl:when test="ancestor::glossary">gloss.htm</xsl:when>

    <xsl:otherwise>index.htm</xsl:otherwise>
  </xsl:choose>
</xsl:template>



<!--
========================================================================
                          END OF FILE
========================================================================
-->


</xsl:stylesheet>
