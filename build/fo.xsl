<?xml version='1.0'?>

<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:fo="http://www.w3.org/1999/XSL/Format"
                xmlns:xslthl="http://xslthl.sf.net"
                exclude-result-prefixes="xslthl"
				version="1.0">
  <xsl:import href="docbook-xsl/fo/docbook.xsl"/>

  <xsl:param name="body.font.family">serif,wqy,Mincho</xsl:param>
  <xsl:param name="monospace.font.family">monospace,wqyMono,Gothic</xsl:param>
  <xsl:param name="sans.font.family">sans-serif,wqy,Gothic</xsl:param>
  <xsl:param name="title.font.family">sans-serif,wqy,Gothic</xsl:param>

  <xsl:param name="default.image.width">14.25cm</xsl:param>

  <xsl:attribute-set name="formal.object.properties">
     <xsl:attribute name="keep-together.within-column">auto</xsl:attribute>
  </xsl:attribute-set>

  <xsl:template match="entry/literal/text()|entrytbl/literal/text()">
    <xsl:call-template name="string.subst">
      <xsl:with-param name="string" select="." />
      <xsl:with-param name="target" select="'_'" />
      <xsl:with-param name="replacement" select="'_&#8203;'" />
    </xsl:call-template>
  </xsl:template>


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

    <xsl:param name="shade.verbatim" select="1"/>
    <xsl:attribute-set name="shade.verbatim.style">
      <xsl:attribute name="background-color">#EDF7FF</xsl:attribute>
      <xsl:attribute name="border-width">0.5pt</xsl:attribute>
      <xsl:attribute name="border-style">solid</xsl:attribute>
      <xsl:attribute name="border-color">#D3E0EB</xsl:attribute>
      <xsl:attribute name="padding">3pt</xsl:attribute>
      <xsl:attribute name="font-size">9pt</xsl:attribute>
    </xsl:attribute-set>

    <xsl:template match="programlisting|screen|synopsis">
      <xsl:param name="suppress-numbers" select="'0'"/>
      <xsl:variable name="id"><xsl:call-template name="object.id"/></xsl:variable>

      <xsl:variable name="content">
        <xsl:choose>
          <xsl:when test="$suppress-numbers = '0'
                          and @linenumbering = 'numbered'
                          and $use.extensions != '0'
                          and $linenumbering.extension != '0'">
            <xsl:call-template name="number.rtf.lines">
              <xsl:with-param name="rtf">
            <xsl:call-template name="apply-highlighting"/>
              </xsl:with-param>
            </xsl:call-template>
          </xsl:when>
          <xsl:otherwise>
        <xsl:call-template name="apply-highlighting"/>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:variable>

      <xsl:choose>
        <xsl:when test="$shade.verbatim != 0">
          <fo:block id="{$id}"
                    xsl:use-attribute-sets="monospace.verbatim.properties shade.verbatim.style" codehl="php">
            <xsl:choose>
              <xsl:when test="$hyphenate.verbatim != 0 and function-available('exsl:node-set')">
                <xsl:apply-templates select="exsl:node-set($content)" mode="hyphenate.verbatim"/>
              </xsl:when>
              <xsl:otherwise>
                <xsl:copy-of select="$content"/>
              </xsl:otherwise>
            </xsl:choose>
          </fo:block>
        </xsl:when>
        <xsl:otherwise>
          <fo:block id="{$id}"
                    xsl:use-attribute-sets="monospace.verbatim.properties" codehl="php">
            <xsl:choose>
              <xsl:when test="$hyphenate.verbatim != 0 and function-available('exsl:node-set')">
                <xsl:apply-templates select="exsl:node-set($content)" mode="hyphenate.verbatim"/>
              </xsl:when>
              <xsl:otherwise>
                <xsl:copy-of select="$content"/>
              </xsl:otherwise>
            </xsl:choose>
          </fo:block>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:template>
</xsl:stylesheet>
