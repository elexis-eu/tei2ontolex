<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xs="http://www.w3.org/2001/XMLSchema"
    exclude-result-prefixes="xs" version="2.0" xmlns="http://lari-datasets.ilc.cnr.it/nenu_sample#"
    xml:base="http://lari-datasets.ilc.cnr.it/nenu_sample" xmlns:void="http://rdfs.org/ns/void#"
    xmlns:owl="http://www.w3.org/2002/07/owl#" xmlns:ns="http://creativecommons.org/ns#"
    xmlns:lime="http://www.w3.org/ns/lemon/lime" xmlns:xsd="http://www.w3.org/2001/XMLSchema#"
    xmlns:rdfs="http://www.w3.org/2000/01/rdf-schema#" xmlns:lexinfo="http://www.lexinfo.net/ontology/2.0/lexinfo#"
    xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#" xmlns:terms="http://purl.org/dc/terms/"
    xmlns:xml="http://www.w3.org/XML/1998/namespace" xmlns:ontolex="http://www.w3.org/ns/lemon/ontolex#"
    xmlns:vann="http://purl.org/vocab/vann/" xmlns:dc="http://purl.org/dc/elements/1.1/"
    xmlns:lime1="http://www.w3.org/ns/lemon/lime#" xpath-default-namespace="http://www.tei-c.org/ns/1.0"
    xmlns:skos="http://www.w3.org/2004/02/skos/core#">

    <xsl:variable name="LexiconURI" select="'http://www.mylexica.perso/PLI1906'"/>

    <xsl:output indent="yes" method="xml"/>

    <xsl:template match="/">
        <rdf:RDF>
            <xsl:apply-templates select="descendant::entry"/>
        </rdf:RDF>
    </xsl:template>

    <xsl:template match="entry">
        <xsl:choose>
            <xsl:when test="gramGrp/pos/@expand = 'locution'">
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

    <xsl:template match="form[@type = 'lemma']">
        <ontolex:canonicalForm>
            <rdf:Description>
                <xsl:apply-templates/>
            </rdf:Description>
        </ontolex:canonicalForm>
    </xsl:template>

    <xsl:template match="orth">
        <ontolex:writtenRep xml:lang="fr">
            <xsl:apply-templates/>
        </ontolex:writtenRep>
    </xsl:template>

    <xsl:template match="pron">
        <ontolex:phoneticRep xml:lang="fr">
            <xsl:apply-templates/>
        </ontolex:phoneticRep>
    </xsl:template>

    <xsl:template match="gramGrp">
        <xsl:apply-templates/>
    </xsl:template>

    <xsl:template match="pos">
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

    <xsl:template match="gen">
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

    <xsl:template match="pc"/>

    <!-- Sense related transformation in two ways: a) reference within an entry and b) creation of the actual LexicalSense node -->

    <xsl:template match="sense">
        <ontolex:sense>
            <xsl:apply-templates/>
        </ontolex:sense>
    </xsl:template>

    <xsl:template match="def">
        <rdf:Description>
            <skos:definition xml:lang="fr">
                <xsl:apply-templates/>
            </skos:definition>
        </rdf:Description>
    </xsl:template>

    <!-- Copy all template to account for possible missed elemnts -->
    <xsl:template match="@* | node()">
        <xsl:choose>
            <xsl:when test="element()">
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
