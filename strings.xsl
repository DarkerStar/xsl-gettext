<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0" xmlns:s="https://genesismachina.ca/xmlns/strings" xmlns:exsl="http://exslt.org/common" xmlns:dyn="http://exslt.org/dynamic" exclude-result-prefixes="s" extension-element-prefixes="exsl dyn">
  <xsl:output method="text"/>
  <xsl:param name="lang">en</xsl:param>
  <xsl:param name="strings-file">strings.xml</xsl:param>
  <xsl:variable name="strings" select="document($strings-file)/s:strings"/>
  <xsl:template name="get-string">
    <xsl:param name="id"/>
    <xsl:param name="lang" select="$lang"/>
    <xsl:param name="n">-</xsl:param>
    <xsl:param name="fallback"/>
    <xsl:param name="strings" select="$strings"/>
    <xsl:choose>
      <xsl:when test="$strings/s:string[@xml:id = $id]">
        <xsl:call-template name="STRINGS_XML-impl-">
          <xsl:with-param name="id" select="$id"/>
          <xsl:with-param name="lang" select="$lang"/>
          <xsl:with-param name="n" select="$n"/>
          <xsl:with-param name="strings" select="$strings"/>
          <xsl:with-param name="mode">copy</xsl:with-param>
        </xsl:call-template>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="$fallback"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
  <xsl:template name="format-string">
    <xsl:param name="id"/>
    <xsl:param name="lang" select="$lang"/>
    <xsl:param name="n">-</xsl:param>
    <xsl:param name="replacements"/>
    <xsl:param name="strings" select="$strings"/>
    <xsl:call-template name="STRINGS_XML-impl-">
      <xsl:with-param name="id" select="$id"/>
      <xsl:with-param name="lang" select="$lang"/>
      <xsl:with-param name="n" select="$n"/>
      <xsl:with-param name="replacements" select="$replacements"/>
      <xsl:with-param name="strings" select="$strings"/>
      <xsl:with-param name="mode">replace</xsl:with-param>
    </xsl:call-template>
  </xsl:template>
  <xsl:template name="STRINGS_XML-impl-">
    <xsl:param name="id"/>
    <xsl:param name="lang"/>
    <xsl:param name="n"/>
    <xsl:param name="replacements"/>
    <xsl:param name="strings"/>
    <xsl:param name="mode"/>
    <xsl:for-each select="$strings/s:string[@xml:id = $id][1]">
      <xsl:choose>
        <xsl:when test="boolean($lang) and $lang != 'en' and s:s[@xml:lang = $lang]">
          <xsl:call-template name="STRINGS_XML-impl-2-">
            <xsl:with-param name="s" select="s:s[@xml:lang = $lang]"/>
            <xsl:with-param name="n" select="$n"/>
            <xsl:with-param name="replacements" select="$replacements"/>
            <xsl:with-param name="mode" select="$mode"/>
          </xsl:call-template>
        </xsl:when>
        <xsl:when test="boolean($lang) and $lang != 'en' and s:s[starts-with($lang, concat(@xml:lang, '-'))]">
          <xsl:for-each select="s:s[starts-with($lang, concat(@xml:lang, '-'))]">
            <xsl:sort select="@xml:lang" order="descending"/>
            <xsl:if test="position() = 1">
              <xsl:call-template name="STRINGS_XML-impl-2-">
                <xsl:with-param name="s" select="../s:s[@xml:lang = current()/@xml:lang]"/>
                <xsl:with-param name="n" select="$n"/>
                <xsl:with-param name="replacements" select="$replacements"/>
                <xsl:with-param name="mode" select="$mode"/>
              </xsl:call-template>
            </xsl:if>
          </xsl:for-each>
        </xsl:when>
        <xsl:otherwise>
          <xsl:call-template name="STRINGS_XML-impl-2-">
            <xsl:with-param name="s" select="s:s[not(@xml:lang)] | s:s[@xml:lang = 'en']"/>
            <xsl:with-param name="n" select="$n"/>
            <xsl:with-param name="replacements" select="$replacements"/>
            <xsl:with-param name="mode" select="$mode"/>
          </xsl:call-template>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:for-each>
  </xsl:template>
  <xsl:template name="STRINGS_XML-impl-2-">
    <xsl:param name="s"/>
    <xsl:param name="n"/>
    <xsl:param name="replacements"/>
    <xsl:param name="mode"/>
    <xsl:choose>
      <xsl:when test="$n = '-'">
        <xsl:call-template name="STRINGS_XML-impl-3-">
          <xsl:with-param name="s" select="$s[not(@n) or @n = 0][1]"/>
          <xsl:with-param name="replacements" select="$replacements"/>
          <xsl:with-param name="mode" select="$mode"/>
        </xsl:call-template>
      </xsl:when>
      <xsl:otherwise>
        <xsl:variable name="l" select="$s/@xml:lang"/>
        <xsl:variable name="p" select="$s/../../s:plural-forms[@xml:lang = $l] | $s/../../s:plural-forms[starts-with($l, concat(@xml:lang, '-'))]"/>
        <xsl:choose>
          <xsl:when test="not($l) or $l = 'en' or not($p)">
            <xsl:choose>
              <xsl:when test="$n != 1 and $s[@n = 1]">
                <xsl:call-template name="STRINGS_XML-impl-3-">
                  <xsl:with-param name="s" select="$s[@n = 1][1]"/>
                  <xsl:with-param name="replacements" select="$replacements"/>
                  <xsl:with-param name="mode" select="$mode"/>
                </xsl:call-template>
              </xsl:when>
              <xsl:otherwise>
                <xsl:call-template name="STRINGS_XML-impl-3-">
                  <xsl:with-param name="s" select="$s[not(@n) or @n = 0][1]"/>
                  <xsl:with-param name="replacements" select="$replacements"/>
                  <xsl:with-param name="mode" select="$mode"/>
                </xsl:call-template>
              </xsl:otherwise>
            </xsl:choose>
          </xsl:when>
          <xsl:otherwise>
            <xsl:choose>
              <xsl:when test="$p[@xml:lang = $l]">
                <xsl:variable name="f" select="$p/s:form[dyn:evaluate(.)][1]"/>
                <xsl:variable name="form" select="number(boolean($f)) * (1 + count($f/preceding-sibling::s:form))"/>
                <xsl:choose>
                  <xsl:when test="$s[@n = $form]">
                    <xsl:call-template name="STRINGS_XML-impl-3-">
                      <xsl:with-param name="s" select="$s[@n = $form][1]"/>
                      <xsl:with-param name="replacements" select="$replacements"/>
                      <xsl:with-param name="mode" select="$mode"/>
                    </xsl:call-template>
                  </xsl:when>
                  <xsl:otherwise>
                    <xsl:call-template name="STRINGS_XML-impl-3-">
                      <xsl:with-param name="s" select="$s[not(@n) or @n = 0][1]"/>
                      <xsl:with-param name="replacements" select="$replacements"/>
                      <xsl:with-param name="mode" select="$mode"/>
                    </xsl:call-template>
                  </xsl:otherwise>
                </xsl:choose>
              </xsl:when>
              <xsl:otherwise>
                <xsl:for-each select="$p[starts-with($l, concat(@xml:lang, '-'))]">
                  <xsl:sort select="@xml:lang" order="descending"/>
                  <xsl:if test="position() = 1">
                    <xsl:variable name="f" select="s:form[dyn:evaluate(.)][1]"/>
                    <xsl:variable name="form" select="number(boolean($f)) * (1 + count($f/preceding-sibling::s:form))"/>
                    <xsl:choose>
                      <xsl:when test="$s[@n = $form]">
                        <xsl:call-template name="STRINGS_XML-impl-3-">
                          <xsl:with-param name="s" select="$s[@n = $form][1]"/>
                          <xsl:with-param name="replacements" select="$replacements"/>
                          <xsl:with-param name="mode" select="$mode"/>
                        </xsl:call-template>
                      </xsl:when>
                      <xsl:otherwise>
                        <xsl:call-template name="STRINGS_XML-impl-3-">
                          <xsl:with-param name="s" select="$s[not(@n) or @n = 0][1]"/>
                          <xsl:with-param name="replacements" select="$replacements"/>
                          <xsl:with-param name="mode" select="$mode"/>
                        </xsl:call-template>
                      </xsl:otherwise>
                    </xsl:choose>
                  </xsl:if>
                </xsl:for-each>
              </xsl:otherwise>
            </xsl:choose>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
  <xsl:template name="STRINGS_XML-impl-3-">
    <xsl:param name="s"/>
    <xsl:param name="replacements"/>
    <xsl:param name="mode"/>
    <xsl:choose>
      <xsl:when test="$mode = 'replace'">
        <xsl:apply-templates select="$s/node()" mode="STRINGS_XML-replace-">
          <xsl:with-param name="replacements" select="$replacements"/>
        </xsl:apply-templates>
      </xsl:when>
      <xsl:otherwise>
        <xsl:copy-of select="$s/node()"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
  <xsl:template name="STRINGS_XML-replace-impl-">
    <xsl:param name="t"/>
    <xsl:param name="replacements"/>
    <xsl:choose>
      <xsl:when test="contains($t, '${')">
        <xsl:value-of select="substring-before($t, '${')"/>
        <xsl:variable name="tmp" select="substring-after($t, '${')"/>
        <xsl:choose>
          <xsl:when test="contains($tmp, '}')">
            <xsl:variable name="id" select="substring-before($tmp, '}')"/>
            <xsl:if test="string-length($id)">
              <xsl:for-each select="exsl:node-set($s)/s:s[@id = $id][1]">
                <xsl:copy-of select="node()"/>
              </xsl:for-each>
            </xsl:if>
            <xsl:call-template name="STRINGS_XML-replace-impl-">
              <xsl:with-param name="t" select="substring-after($tmp, '}')"/>
              <xsl:with-param name="replacements" select="$replacements"/>
            </xsl:call-template>
          </xsl:when>
          <xsl:otherwise>
            <xsl:text>${</xsl:text>
            <xsl:value-of select="$tmp"/>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="$t"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
  <!-- Replace templates -->
  <xsl:template match="s:string/s:s//*" mode="STRINGS_XML-replace-">
    <xsl:param name="replacements"/>
    <xsl:element name="{local-name()}" namespace="{namespace-uri()}">
      <xsl:apply-templates select="@*" mode="STRINGS_XML-replace-">
        <xsl:with-param name="replacements" select="$replacements"/>
      </xsl:apply-templates>
      <xsl:apply-templates select="node()" mode="STRINGS_XML-replace-">
        <xsl:with-param name="replacements" select="$replacements"/>
      </xsl:apply-templates>
    </xsl:element>
  </xsl:template>
  <xsl:template match="s:string/s:s//@*[not(contains(., '${'))]" mode="STRINGS_XML-replace-">
    <xsl:copy/>
  </xsl:template>
  <xsl:template match="s:string/s:s//text()[not(contains(., '${'))]" mode="STRINGS_XML-replace-">
    <xsl:copy/>
  </xsl:template>
  <xsl:template match="s:string/s:s//@*[contains(., '${')]" mode="STRINGS_XML-replace-">
    <xsl:param name="replacements"/>
    <xsl:attribute name="{local-name()}" namespace="{namespace-uri()}">
      <xsl:call-template name="STRINGS_XML-replace-impl-">
        <xsl:with-param name="t" select="."/>
        <xsl:with-param name="replacements" select="$replacements"/>
      </xsl:call-template>
    </xsl:attribute>
  </xsl:template>
  <xsl:template match="s:string/s:s//text()[contains(., '${')]" mode="STRINGS_XML-replace-">
    <xsl:param name="replacements"/>
    <xsl:call-template name="STRINGS_XML-replace-impl-">
      <xsl:with-param name="t" select="."/>
      <xsl:with-param name="replacements" select="$replacements"/>
    </xsl:call-template>
  </xsl:template>
</xsl:stylesheet>
