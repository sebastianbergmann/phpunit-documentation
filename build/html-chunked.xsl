<?xml version='1.0'?>

<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version='1.0'>
  <xsl:import href="docbook-xsl/xhtml/chunk.xsl"/>

  <xsl:param name="default.encoding" select="'utf-8'"/>
  <xsl:param name="html.stylesheet" select="'docbook.css'"/>
  <xsl:param name="html.stylesheet.type" select="'text/css'"/>
  <xsl:param name="toc.section.depth" select="'3'"/>
  <xsl:param name="use.id.function" select="1"/>
  <xsl:param name="generate.toc">book toc</xsl:param>
  <xsl:param name="toc.section.depth" select="1"/>
  <xsl:param name="toc.max.depth" select="3"/>
  <xsl:param name="local.l10n.xml" select="document('')"/>

  <xsl:param name="chunk.section.depth" select="0"/>
  <xsl:param name="chunk.first.sections" select="0"/>
  <xsl:param name="chunk.fast" select="0"/>
  <xsl:param name="chunk.quietly" select="1"/>
  <xsl:param name="using.chunker" select="1"/>
  <xsl:param name="chunker.output.cdata-section-elements"/>
  <xsl:param name="chunker.output.encoding" select="'utf-8'"/>
  <xsl:param name="chunker.output.media-type"/>
  <xsl:param name="chunker.output.method" select="'html'"/>
  <xsl:param name="chunker.output.standalone" select="'no'"/>
  <xsl:param name='use.id.as.filename' select="1"/>

  <l:i18n xmlns:l="http://docbook.sourceforge.net/xmlns/l10n/1.0">
    <l:l10n language="de">
      <l:context name="title">
        <l:template name="example" text="Beispiel %n: %t"/>
      </l:context>
      <l:context name="xref-number-and-title">
        <l:template name="part" text="Teil %n"/>
        <l:template name="appendix" text="Anhang %n"/>
        <l:template name="chapter" text="Kapitel %n"/>
        <l:template name="example" text="Beispiel %n"/>
        <l:template name="figure" text="Abbildung %n"/>
        <l:template name="table" text="Tabelle %n"/>
      </l:context>
      <l:gentext key="Index" text=""/>
      <l:gentext key="index" text=""/>
    </l:l10n>
    <l:l10n language="en">
      <l:context name="title">
        <l:template name="example" text="Example %n: %t"/>
      </l:context>
      <l:context name="xref-number-and-title">
        <l:template name="part" text="Part %n"/>
        <l:template name="appendix" text="Appendix %n"/>
        <l:template name="chapter" text="Chapter %n"/>
        <l:template name="example" text="Example %n"/>
        <l:template name="figure" text="Figure %n"/>
        <l:template name="table" text="Table %n"/>
      </l:context>
      <l:gentext key="Index" text=""/>
      <l:gentext key="index" text=""/>
    </l:l10n>
    <l:l10n language="ja">
      <l:context name="title">
        <l:template name="example" text="例 %n: %t"/>
      </l:context>
      <l:context name="xref-number-and-title">
        <l:template name="part" text="パート %n"/>
        <l:template name="appendix" text="付録 %n"/>
        <l:template name="chapter" text="第 %n 章"/>
        <l:template name="example" text="例 %n"/>
        <l:template name="figure" text="図 %n"/>
        <l:template name="table" text="表 %n"/>
      </l:context>
      <l:gentext key="Index" text=""/>
      <l:gentext key="index" text=""/>
    </l:l10n>
	 <l:l10n language="pt_br">
      <l:context name="title">
        <l:template name="example" text="Exemplo %n: %t"/>
      </l:context>
      <l:context name="xref-number-and-title">
        <l:template name="part" text="Parte %n"/>
        <l:template name="appendix" text="Apêndice %n"/>
        <l:template name="chapter" text="Capítulo %n"/>
        <l:template name="example" text="Exemplo %n"/>
        <l:template name="figure" text="Figura %n"/>
        <l:template name="table" text="Tabela %n"/>
      </l:context>
      <l:gentext key="Index" text=""/>
      <l:gentext key="index" text=""/>
    </l:l10n>
    <l:l10n language="zh_cn">
      <l:context name="title">
        <l:template name="example" text="例 %n: %t"/>
      </l:context>
      <l:context name="xref-number-and-title">
        <l:template name="part" text="%n 部分"/>
        <l:template name="appendix" text="附录 %n"/>
        <l:template name="chapter" text="第 %n 章"/>
        <l:template name="example" text="例 %n"/>
        <l:template name="figure" text="图 %n"/>
        <l:template name="table" text="表 %n"/>
      </l:context>
      <l:gentext key="Index" text=""/>
      <l:gentext key="index" text=""/>
    </l:l10n>
  </l:i18n>
</xsl:stylesheet>
