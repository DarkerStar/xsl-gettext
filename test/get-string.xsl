<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
  <xsl:import href="../strings.xsl"/>
  <xsl:output method="text"/>
  <xsl:param name="id"/>
  <xsl:param name="n">-</xsl:param>
  <xsl:param name="lang">en</xsl:param>
  <xsl:param name="fallback"/>
  <xsl:variable name="strings-file">test/strings.xml</xsl:variable>
  <xsl:template match="/">
    <xsl:call-template name="get-string">
      <xsl:with-param name="id" select="$id"/>
      <xsl:with-param name="n" select="$n"/>
      <xsl:with-param name="lang" select="$lang"/>
      <xsl:with-param name="fallback" select="$fallback"/>
    </xsl:call-template>
  </xsl:template>
</xsl:stylesheet>
