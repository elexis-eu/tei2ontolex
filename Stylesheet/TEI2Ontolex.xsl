<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xs="http://www.w3.org/2001/XMLSchema"
    exclude-result-prefixes="xs" version="1.0" xmlns="http://lari-datasets.ilc.cnr.it/nenu_sample#"
    xml:base="http://lari-datasets.ilc.cnr.it/nenu_sample" xmlns:void="http://rdfs.org/ns/void#"
    xmlns:owl="http://www.w3.org/2002/07/owl#" xmlns:ns="http://creativecommons.org/ns#"
    xmlns:lime="http://www.w3.org/ns/lemon/lime" xmlns:xsd="http://www.w3.org/2001/XMLSchema#"
    xmlns:rdfs="http://www.w3.org/2000/01/rdf-schema#" xmlns:lexinfo="http://www.lexinfo.net/ontology/2.0/lexinfo#"
    xmlns:lexicog="http://www.w3.org/ns/lemon/lexicog#" xmlns:dct="http://purl.org/dc/terms/"
    xmlns:bibo="http://purl.org/ontology/bibo/" xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"
    xmlns:terms="http://purl.org/dc/terms/" xmlns:xml="http://www.w3.org/XML/1998/namespace"
    xmlns:ontolex="http://www.w3.org/ns/lemon/ontolex#" xmlns:vann="http://purl.org/vocab/vann/"
    xmlns:dc="http://purl.org/dc/elements/1.1/" xmlns:lime1="http://www.w3.org/ns/lemon/lime#"
    xmlns:tei="http://www.tei-c.org/ns/1.0" xmlns:skos="http://www.w3.org/2004/02/skos/core#">

    <xsl:variable name="LexiconURI" select="'http://www.mylexica.perso/PLI1906'"/>

    <xsl:output indent="yes" method="xml"/>

    <xsl:template match="/">
        <rdf:RDF>
            <xsl:apply-templates select="descendant::tei:entry"/>
        </rdf:RDF>
    </xsl:template>

    <xsl:template match="tei:entry">
        <xsl:choose>
            <xsl:when test="tei:gramGrp/tei:pos/@expand = 'locution'">
                <owl:NamedIndividual rdf:about="{$LexiconURI}#{@xml:id}">
                    <rdf:type rdf:resource="http://www.w3.org/ns/lemon/ontolex#MultiwordExpression"/>
                    <xsl:apply-templates/>
                </owl:NamedIndividual>
            </xsl:when>
            <xsl:otherwise>
                <ontolex:LexicalEntry rdf:ID="{@xml:id}">
                    <xsl:apply-templates/>
                </ontolex:LexicalEntry>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <xsl:template match="tei:form[@type = 'lemma']">
        <ontolex:canonicalForm>
            <rdf:Description>
                <xsl:apply-templates/>
                <xsl:if test="form[@type = 'variant']">
                    <xsl:apply-templates select="form[@type = 'variant']"/>
                </xsl:if>
            </rdf:Description>
        </ontolex:canonicalForm>
    </xsl:template>

    <xsl:template match="tei:orth">
        <xsl:variable name="workingLanguage" select="ancestor-or-self::*[@xml:lang][1]/@xml:lang"/>
        <ontolex:writtenRep xml:lang="{$workingLanguage}">
            <xsl:apply-templates/>
        </ontolex:writtenRep>
    </xsl:template>

    <xsl:template match="tei:orth/tei:seg">
        <xsl:apply-templates/>
    </xsl:template>

    <xsl:template match="tei:pron">
        <xsl:variable name="workingLanguage" select="ancestor-or-self::*[@xml:lang][1]/@xml:lang"/>
        <xsl:variable name="languageWithNotation">
            <xsl:choose>
                <xsl:when test="@notation">
                    <xsl:value-of select="concat($workingLanguage,'-fon',@notation)"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:value-of select="$workingLanguage"/>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <ontolex:phoneticRep xml:lang="{$languageWithNotation}">
            <xsl:apply-templates/>
        </ontolex:phoneticRep>
    </xsl:template>

    <xsl:template match="tei:pron/tei:seg">
        <xsl:apply-templates/>
    </xsl:template>

    <xsl:template match="tei:form[@type = 'lemma']/tei:form[@type = 'variant']">
        <xsl:apply-templates/>
    </xsl:template>

    <xsl:template match="tei:gramGrp">
        <xsl:apply-templates/>
    </xsl:template>

    <xsl:template match="tei:pos">
        <xsl:if test="not(@expan = 'locution')">
            <xsl:variable name="lexinfoCategory">
                <xsl:choose>
                    <xsl:when test="@expand = 'nom'">Noun</xsl:when>
                    <xsl:when test="@expand = 'préposition'">Preposition</xsl:when>
                    <xsl:when test="@expand = 'adjectif'">Adjective</xsl:when>
                    <xsl:when test="@expand = 'verbe'">Verb</xsl:when>
                    <xsl:when test="@expand = 'adverbe'">Adverb</xsl:when>
                    <xsl:when test="@expand = 'pronom'">Pronoun</xsl:when>
                    <xsl:when test="@expand = 'article'">ArticlePOS</xsl:when>
                    <xsl:when test="@expand = 'conjonction'">Conjunction</xsl:when>
                    <xsl:when test="@expand = 'interjection'">Interjection</xsl:when>
                    <xsl:when test="@expand = 'préfixe'">Prefix</xsl:when>
                    <xsl:otherwise>
                        <xsl:message>RemainsToBeDetermined: <xsl:value-of select="@expand"/></xsl:message>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:variable>
            <lexinfo:partOfSpeech rdf:resource="http://www.lexinfo.net/ontology/2.0/lexinfo#{$lexinfoCategory}"/>
        </xsl:if>
    </xsl:template>

    <xsl:template match="tei:gen">
        <xsl:variable name="lexinfoGender">
            <xsl:choose>
                <xsl:when test="@expand = 'masculin'">masculine</xsl:when>
                <xsl:when test="@expand = 'féminin'">feminine</xsl:when>
                <xsl:otherwise>RemainsToBeDetermined</xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <lexinfo:gender rdf:resource="http://www.lexinfo.net/ontology/2.0/lexinfo#{$lexinfoGender}"/>
    </xsl:template>


    <!-- Punctuations are not kept in Ontolex -->

    <xsl:template match="tei:pc"/>

    <!-- Sense related transformation in two ways: a) reference within an entry and b) creation of the actual LexicalSense node -->

    <xsl:template match="tei:sense">
        <ontolex:sense>
            <rdf:Description>
                <xsl:apply-templates/>
            </rdf:Description>
        </ontolex:sense>
    </xsl:template>

    <xsl:template match="tei:usg">
        <lexinfo:register>
            <rdf:Description>
                <xsl:apply-templates/>
            </rdf:Description>
        </lexinfo:register>
    </xsl:template>

    <xsl:template match="tei:def">
        <xsl:variable name="workingLanguage" select="ancestor-or-self::*[@xml:lang][1]/@xml:lang"/>
        <skos:definition xml:lang="{$workingLanguage}">
            <xsl:apply-templates/>
        </skos:definition>
    </xsl:template>

    <xsl:template match="tei:cit[@type = 'example' or @type = 'quote']">
        <lexicog:usageExample>
            <xsl:apply-templates/>
        </lexicog:usageExample>
    </xsl:template>

    <xsl:template match="tei:cit[@type = 'example' or @type = 'quote']/quote">
        <xsl:variable name="workingLanguage" select="ancestor-or-self::*[@xml:lang][1]/@xml:lang"/>
        <rdf:value xml:lang="{$workingLanguage}">
            <xsl:apply-templates/>
        </rdf:value>
    </xsl:template>

    <xsl:template match="tei:etym">
        <lexinfo:etymology>
            <xsl:apply-templates/>
        </lexinfo:etymology>
    </xsl:template>

    <xsl:template match="tei:etym/*">
        <xsl:apply-templates/>
    </xsl:template>
    
    <xsl:template match="tei:etym/text()[ normalize-space() = '']">
        <xsl:text> </xsl:text>
    </xsl:template>

    <xsl:template match="tei:bibl">
        <dct:source>
            <xsl:apply-templates/>
        </dct:source>
    </xsl:template>

    <xsl:template match="tei:author">
        <dc:creator>
            <xsl:apply-templates/>
        </dc:creator>
    </xsl:template>


    <xsl:template match="tei:title">
        <dc:title>
            <xsl:apply-templates/>
        </dc:title>
    </xsl:template>

    <xsl:template match="tei:date">
        <dc:date>
            <xsl:apply-templates/>
        </dc:date>
    </xsl:template>

    <xsl:template match="tei:publisher">
        <dc:publisher>
            <xsl:apply-templates/>
        </dc:publisher>
    </xsl:template>

    <!-- Small annotation elements or intermediate text that disappear in Ontolex -->

    <xsl:template match="tei:emph">
        <xsl:apply-templates/>
    </xsl:template>

    <xsl:template match="tei:form/text()"/>

    <xsl:template match="text()[normalize-space() = '']"/>

    <!-- Copy all template to account for possible missed elements -->
    <xsl:template match="@* | node()">
        <xsl:choose>
            <xsl:when test="name()">
                <xsl:message>
                    <xsl:value-of select="name()"/>
                </xsl:message>
            </xsl:when>
            <!--  <xsl:when test="attribute()">
                <xsl:message>
                    <xsl:value-of select="concat('@', name())"/>
                </xsl:message>
            </xsl:when>-->
        </xsl:choose>

        <xsl:copy>
            <xsl:apply-templates select="@* | node()"/>
        </xsl:copy>
    </xsl:template>

</xsl:stylesheet>
