<?xml version='1.0'?>

<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version='1.0'>
  <xsl:import href="docbook-xsl/fo/docbook.xsl"/>

  <xsl:param name="paper.type">A4</xsl:param>

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
  </l:i18n>
</xsl:stylesheet>
