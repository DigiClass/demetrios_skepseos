<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xpath-default-namespace="http://www.tei-c.org/ns/1.0"
    xmlns:ds="http://demetrios.ch/ns/" version="2.0">
    <xsl:output method="html" indent="no"/>

    <xsl:variable name="mastervar">
        <xsl:element name="group">
            <xsl:for-each select="doc('../xml/masterlist.xml')//ds:file[@name]">
                <xsl:variable name="id" select="@name"/>
                <xsl:variable name="filepath" select="concat('../xml/',$id,'.xml')"/>
                <xsl:value-of select="$id"/>
                <xsl:element name="text" namespace="http://www.tei-c.org/ns/1.0">
                    <xsl:attribute name="xml:id" select="$id"/>
                    <xsl:copy-of select="doc($filepath)//body" copy-namespaces="yes"/>
                </xsl:element>
            </xsl:for-each>
        </xsl:element>
    </xsl:variable>

    <xsl:template match="ds:files">
        <xsl:for-each select="ds:file">
            <xsl:result-document href="{concat('../html/',@name,'.html')}">
                <xsl:apply-templates select="doc(concat('../xml/',@name,'.xml'))"/>
            </xsl:result-document>
        </xsl:for-each>
        
        <xsl:call-template name="indices"/>
        <xsl:call-template name="number"/>
       <xsl:call-template name="editors"/>
        <xsl:call-template name="fragments"/>
        <xsl:call-template name="testimonia"/>
        
    </xsl:template>

    <xsl:template match="/">
        <html>
            <head>
                <title>The fragments of Demetrios of Skepsis</title>
                <xsl:call-template name="headerscripts"/>
            </head>
            <body>

                <div id="banner" align="center">
                    <div><div><h1>Demetrios of Skepsis</h1></div></div>
                </div>
            

                <xsl:call-template name="menu">
                    <xsl:with-param name="context">
                            <xsl:if test="//TEI[starts-with(@xml:id,'f')]">
                                <xsl:text>by</xsl:text>
                            </xsl:if>
                    </xsl:with-param>
                </xsl:call-template>

                <xsl:if test="not(//TEI/@xml:id=('bibliography','introduction'))">
                    <div id="navigation">
                    <h4 style="margin-left: 616px; margin-bottom: 50px;">
                        <xsl:variable name="currid" select="//TEI/@xml:id"/>
                        <xsl:choose>
                            <xsl:when test="$mastervar//text[@xml:id=$currid][preceding-sibling::text[@xml:id!='introduction']]">
                                <a href="{$mastervar//text[@xml:id=$currid]/preceding-sibling::text[1]/@xml:id}.html">Previous</a>
                            </xsl:when>
                            <xsl:otherwise>
                                <span style="color:gray;">Previous</span>
                            </xsl:otherwise>
                        </xsl:choose>
                        | <xsl:choose>
                            <xsl:when test="$mastervar//text[@xml:id=$currid][following-sibling::text[not(@xml:id=('bibliography', 'introduction'))]]">
                                <a href="{$mastervar//text[@xml:id=$currid]/following-sibling::text[1]/@xml:id}.html">Next</a>
                            </xsl:when>
                            <xsl:otherwise>
                                <span style="color:gray;">Next</span>
                            </xsl:otherwise>
                        </xsl:choose>
                    </h4>
                </div></xsl:if>

                <xsl:apply-templates/>

            </body>
        </html>
    </xsl:template>
    
    <xsl:template name="headerscripts">
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
        <link rel="stylesheet" type="text/css" href="demetrios.css"/>
        <script type="text/javascript" src="http://isawnyu.github.com/awld-js/lib/requirejs/require.min.js"/>
        <script type="text/javascript" src="http://isawnyu.github.com/awld-js/awld.js"/>
        <script type="text/javascript">
                    awld.init();
                </script>
        <script type="text/javascript">
                    function show_menu(menu_id){
                    var menu = document.getElementById(menu_id);
                    if(menu.style.display == 'block'){
                    menu.style.display = 'none';
                    }else {
                    menu.style.display = 'block';                    
                    }
                    }
                </script>
    </xsl:template>
    
    <xsl:template name="menu">
        <xsl:param name="context"/>
        <div id="menu" style="float:left; padding-left:20px">
                <ul>
                    <li><a href="introduction.html">Introduction</a></li>
                    <li><a type="button" onclick="show_menu('texts')" href="#">Texts</a>
                        <ul id="texts">
                            <xsl:attribute name="class">
                                <xsl:choose>
                                    <xsl:when test="starts-with($context,'by')">
                                        <xsl:text>unhidden_menu</xsl:text>
                                    </xsl:when>
                                    <xsl:otherwise>
                                        <xsl:text>hidden_menu</xsl:text>
                                    </xsl:otherwise>
                                </xsl:choose>
                            </xsl:attribute>
                            <li><a type="button" onclick="show_menu('bynum')" href="#">By Number</a>
                                   <!--<ul class="hidden_menu" id="bynum">
                                <xsl:for-each-group select="$mastervar//text[not(@xml:id=('bibliography', 'introduction'))]" group-by="substring(@xml:id,1,3)">
                                    <li><a href="{current-grouping-key()}.html">
                                        <xsl:value-of select="upper-case(current-grouping-key())"/>
                                    </a></li>
                                </xsl:for-each-group>
                            </ul>-->
                                    <ul id="bynum">
                                        <xsl:attribute name="class">
                                            <xsl:choose>
                                                <xsl:when test="$context='bynum'">
                                                    <xsl:text>unhidden_menu</xsl:text>
                                                </xsl:when>
                                            <xsl:otherwise>
                                                <xsl:text>hidden_menu</xsl:text>
                                            </xsl:otherwise>
                                        </xsl:choose>
                                        </xsl:attribute>
                                        <xsl:for-each-group select="$mastervar//text[not(@xml:id=('bibliography','introduction'))]" group-by="substring(@xml:id,1,3)">
                                        <li><a href="{current-grouping-key()}.html">
                                            <xsl:value-of select="upper-case(current-grouping-key())"/>
                                        </a></li>
                                    </xsl:for-each-group>
                                </ul></li>
                            <li><a onclick="show_menu('byed')" href="#">By Editor</a> 
                                <ul id="byed">
                                    <xsl:attribute name="class">
                                        <xsl:choose>
                                            <xsl:when test="$context='byed'">
                                                <xsl:text>unhidden_menu</xsl:text>
                                            </xsl:when>
                                            <xsl:otherwise>
                                                <xsl:text>hidden_menu</xsl:text>
                                            </xsl:otherwise>
                                        </xsl:choose>
                                    </xsl:attribute>
                                    <xsl:for-each-group select="$mastervar//text[not(@xml:id=('bibliography','introduction'))]" group-by="substring(@xml:id,4)">
                                        <li><a href="{current-grouping-key()}.html">
                                            <xsl:value-of select="concat(upper-case(substring(current-grouping-key(),1,1)),substring(current-grouping-key(),2))"/>
                                        </a></li>
                                    </xsl:for-each-group>
                                </ul></li>
                            <li><a type="button" onclick="show_menu('bytype')" href="#">By Type</a> 
                                <ul id="bytype">
                                    <xsl:attribute name="class">
                                        <xsl:choose>
                                            <xsl:when test="$context='bytype'">
                                                <xsl:text>unhidden_menu</xsl:text>
                                            </xsl:when>
                                            <xsl:otherwise>
                                                <xsl:text>hidden_menu</xsl:text>
                                            </xsl:otherwise>
                                        </xsl:choose>
                                    </xsl:attribute>
                                    <xsl:for-each-group select="$mastervar//seg[@resp='demetrios']" group-by="@resp">
                                        <li><a href="verbatim.html">Verbatim quotations</a></li>
                                    </xsl:for-each-group>
                                    <xsl:for-each-group select="$mastervar//seg[@type='testimonium']" group-by="@type">
                                        <li><a href="testimonia.html">Testimonia</a></li>
                                    </xsl:for-each-group>
                                </ul></li>
                        </ul>
                    </li> 
                    <li><a type="button" onclick="show_menu('indices')" href="#">Indices</a> 
                                <ul style="list-style-type:none;" id="indices">
                                    <xsl:attribute name="class">
                                        <xsl:choose>
                                            <xsl:when test="$context='indices'">
                                                <xsl:text>unhidden_menu</xsl:text>
                                            </xsl:when>
                                            <xsl:otherwise>
                                                <xsl:text>hidden_menu</xsl:text>
                                            </xsl:otherwise>
                                        </xsl:choose>
                                    </xsl:attribute>
                                    <li><a href="persons.html">Persons</a></li>
                                <li><a href="placenames.html">Place names</a></li>
                            </ul>
                    </li>
                    <li><a href="bibliography.html">Bibliography</a></li>
                </ul>
            
        </div>
    </xsl:template>

    <xsl:template match="teiHeader"/>
    
    
    <!-- structure -->
    <xsl:template name="number">
        <xsl:for-each-group select="$mastervar//text[not(@xml:id=('bibliography','introduction'))]" group-by="substring(@xml:id,1,3)">
            <xsl:result-document href="{current-grouping-key()}.html" method="xhtml" doctype-system="http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
                <html>
                    <head>
                        <title>Texts</title>
                        <xsl:call-template name="headerscripts"/>
                    </head>
                    <body>
                        <div id="banner">
                            <div><div><h1>Demetrios of Skepsis</h1></div></div>
                        </div>
                        
                        <xsl:call-template name="menu">
                            <xsl:with-param name="context">
                                <xsl:text>bynum</xsl:text>
                            </xsl:with-param>
                        </xsl:call-template>
                        
                        <xsl:for-each select="$mastervar//text[starts-with(@xml:id,current-grouping-key())]">
                            <blockquote>
                                <xsl:apply-templates/>
                            </blockquote>
                        </xsl:for-each>
                        
                    </body>
                </html>
            </xsl:result-document>
        </xsl:for-each-group>
    </xsl:template>
    
    <xsl:template name="editors">
        <xsl:for-each-group select="$mastervar//text[not(@xml:id=('bibliography','introduction'))]" group-by="substring(@xml:id,4)">
            <xsl:result-document href="{current-grouping-key()}.html" method="xhtml" doctype-system="http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
                <html>
                    <head>
                        <title>Texts</title>
                        <xsl:call-template name="headerscripts"/>
                    </head>
                    <body>
                        <div id="banner">
                            <div><div><h1>Demetrios of Skepsis</h1></div></div>
                        </div>
                        
                        <xsl:call-template name="menu">
                            <xsl:with-param name="context">
                                <xsl:text>byed</xsl:text>
                            </xsl:with-param>
                        </xsl:call-template>
                        <xsl:for-each select="$mastervar//text[ends-with(@xml:id,current-grouping-key())]">
                            <blockquote>
                                <xsl:apply-templates/>
                            </blockquote>
                        </xsl:for-each>
                        
                    </body>
                </html>
            </xsl:result-document>
        </xsl:for-each-group>
    </xsl:template>
    
    <xsl:template name="fragments">
        <xsl:for-each-group select="$mastervar//seg[@resp='demetrios']" group-by="@resp">
            <xsl:result-document href="verbatim.html" method="xhtml" doctype-system="http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
                <html>
                    <head>
                        <title>Texts</title>
                        <xsl:call-template name="headerscripts"/>
                    </head>
                    <body>
                        <div id="banner">
                            <div><div><h1>Demetrios of Skepsis</h1></div></div>
                        </div>
                        
                        <xsl:call-template name="menu">
                            <xsl:with-param name="context">
                                <xsl:text>bytype</xsl:text>
                            </xsl:with-param>
                        </xsl:call-template>
                        <xsl:for-each select="$mastervar//seg[@resp='demetrios']">
                            <xsl:choose>
                                <xsl:when test="ancestor::div[@type='translation']">
                                    <blockquote>
                                <xsl:apply-templates/>
                            </blockquote>
                            <br/>
                                </xsl:when>
                                <xsl:otherwise>
                                    <blockquote>
                                        <xsl:element name="h4"><xsl:value-of select="ancestor::body/head"/>
                                        <xsl:text> </xsl:text>
                                            <a href="{ancestor::text/@xml:id}.html"><xsl:value-of select="preceding-sibling::seg[@type='context'][1]/ref[1]"/></a></xsl:element>
                                        <xsl:apply-templates/>
                                    </blockquote>
                                </xsl:otherwise>
                            </xsl:choose>
                        </xsl:for-each>
                        
                    </body>
                </html>
            </xsl:result-document>
        </xsl:for-each-group>
    </xsl:template>
    
    <xsl:template name="testimonia">
        <xsl:for-each-group select="$mastervar//seg[@type='testimonium']" group-by="@type">
            <xsl:result-document href="testimonia.html" method="xhtml" doctype-system="http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
                <html>
                    <head>
                        <title>Texts</title>
                        <xsl:call-template name="headerscripts"/>
                    </head>
                    <body>
                        <div id="banner">
                            <div><div><h1>Demetrios of Skepsis</h1></div></div>
                        </div>
                        
                        <xsl:call-template name="menu">
                            <xsl:with-param name="context">
                                <xsl:text>bytype</xsl:text>
                            </xsl:with-param>
                        </xsl:call-template>
                        <xsl:for-each select="$mastervar//seg[@type='testimonium']">
                            <xsl:choose>
                                <xsl:when test="ancestor::div[@type='translation']">
                                    <blockquote>
                                        <xsl:apply-templates/>
                                    </blockquote>
                                    <br/>
                                </xsl:when>
                                <xsl:otherwise>
                                    <blockquote>
                                        <xsl:element name="h4"><xsl:value-of select="ancestor::body/head"/>
                                            <xsl:text> </xsl:text>
                                            <a href="{ancestor::text/@xml:id}.html"><xsl:value-of select="preceding-sibling::seg[@type='context'][1]/ref[1]"/></a></xsl:element>
                                        <xsl:apply-templates/>
                                    </blockquote>
                                </xsl:otherwise>
                            </xsl:choose>
                        </xsl:for-each>
                        
                    </body>
                </html>
            </xsl:result-document>
        </xsl:for-each-group>
    </xsl:template>
    
    <!-- indices -->
    <xsl:template  name="indices">
        <xsl:result-document href="placenames.html" method="xhtml" doctype-system="http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
            <html>
                <head>
                    <title>Index</title>
                    <xsl:call-template name="headerscripts"/>
                </head>
                <body>
                    <div id="banner">
                        <div><div><h1>Demetrios of Skepsis</h1></div></div>
                    </div>
                    
                    <xsl:call-template name="menu">
                        <xsl:with-param name="context">
                            <xsl:text>indices</xsl:text>
                        </xsl:with-param>
                    </xsl:call-template>
                    
                    <h1 style="margin-left:600px;">Index of places</h1>
                    
                    
                    <xsl:if test="$mastervar//placeName[@type='region']">
                        <h3 style="margin-left:300px;">Regions</h3>
                        <ul style="margin-left:300px;">
                        <xsl:for-each-group select="$mastervar//placeName[@type='region']" group-by="@nymRef">
                            <xsl:sort order="ascending" select="translate(normalize-unicode(@nymRef,'NFD'),'&#x0301;&#x0313;&#x0314;&#x0342;','')"/>
                            <xsl:call-template name="print-lemmas"/>
                        </xsl:for-each-group>
                    </ul>
                    </xsl:if>
                    <br/>
                    <xsl:if test="$mastervar//placeName[@type='city']">
                        <h3 style="margin-left:300px;">Cities</h3>
                        <ul style="margin-left:300px;">
                            <xsl:for-each-group select="$mastervar//placeName[@type='city']" group-by="@nymRef">
                                <xsl:sort order="ascending" select="translate(normalize-unicode(@nymRef,'NFD'),'&#x0301;&#x0313;&#x0314;&#x0342;','')"/>
                                <xsl:call-template name="print-lemmas"/>
                            </xsl:for-each-group>
                        </ul>
                    </xsl:if>
                    <br/>
                    <xsl:if test="$mastervar//placeName[@type='sanctuary']">
                        <h3 style="margin-left:300px;">Sanctuaries</h3>
                        <ul style="margin-left:300px;">
                            <xsl:for-each-group select="$mastervar//placeName[@type='sanctuary']" group-by="@nymRef">
                                <xsl:sort order="ascending" select="translate(normalize-unicode(@nymRef,'NFD'),'&#x0301;&#x0313;&#x0314;&#x0342;','')"/>
                                <xsl:call-template name="print-lemmas"/>
                            </xsl:for-each-group>
                        </ul>
                    </xsl:if>
                    <br/>
                    <xsl:if test="$mastervar//geogName[@type='river']">
                        <h3 style="margin-left:300px;">Rivers</h3>
                        <ul style="margin-left:300px;">
                            <xsl:for-each-group select="$mastervar//geogName[@type='river']" group-by="@nymRef">
                                <xsl:sort order="ascending" select="translate(normalize-unicode(@nymRef,'NFD'),'&#x0301;&#x0313;&#x0314;&#x0342;','')"/>
                               <xsl:call-template name="print-lemmas"/>
                            </xsl:for-each-group>
                        </ul>
                    </xsl:if>
                    <br/>
                    <xsl:if test="$mastervar//geogName[@type='mountain']">
                        <h3 style="margin-left:300px;">Mountains</h3>
                        <ul style="margin-left:300px;">
                            <xsl:for-each-group select="$mastervar//geogName[@type='mountain']" group-by="@nymRef">
                                <xsl:sort order="ascending" select="translate(normalize-unicode(@nymRef,'NFD'),'&#x0301;&#x0313;&#x0314;&#x0342;','')"/>
                                <xsl:call-template name="print-lemmas"/>
                            </xsl:for-each-group>
                        </ul>
                    </xsl:if>
                    <br/>
                    <xsl:if test="$mastervar//geogName[@type='plain']">
                        <h3 style="margin-left:300px;">Plains</h3>
                        <ul style="margin-left:300px;">
                            <xsl:for-each-group select="$mastervar//geogName[@type='plain']" group-by="@nymRef">
                                <xsl:sort order="ascending" select="translate(normalize-unicode(@nymRef,'NFD'),'&#x0301;&#x0313;&#x0314;&#x0342;','')"/>
                                <xsl:call-template name="print-lemmas"/>
                            </xsl:for-each-group>
                        </ul>
                    </xsl:if>
                    <br/>
                    <xsl:if test="$mastervar//geogName[@type='sea']">
                        <h3 style="margin-left:300px;">Seas</h3>
                        <ul style="margin-left:300px;">
                            <xsl:for-each-group select="$mastervar//geogName[@type='sea']" group-by="@nymRef">
                                <xsl:sort order="ascending" select="translate(normalize-unicode(@nymRef,'NFD'),'&#x0301;&#x0313;&#x0314;&#x0342;','')"/>
                                <xsl:call-template name="print-lemmas"/>
                            </xsl:for-each-group>
                        </ul>
                    </xsl:if>
                    <br/>
                    <xsl:if test="$mastervar//geogName[@type='island']">
                        <h3 style="margin-left:300px;">Islands</h3>
                        <ul style="margin-left:300px;">
                            <xsl:for-each-group select="$mastervar//geogName[@type='island']" group-by="@nymRef">
                                <xsl:sort order="ascending" select="translate(normalize-unicode(@nymRef,'NFD'),'&#x0301;&#x0313;&#x0314;&#x0342;','')"/>
                                <xsl:call-template name="print-lemmas"/>
                            </xsl:for-each-group>
                        </ul>
                    </xsl:if>
                    <br/>
                    <xsl:if test="$mastervar//placeName[@type='ethnic']">
                        <h3 style="margin-left:300px;">Ethnic names</h3>
                        <ul style="margin-left:300px;">
                            <xsl:for-each-group select="$mastervar//placeName[@type='ethnic']" group-by="@nymRef">
                                <xsl:sort order="ascending" select="translate(normalize-unicode(@nymRef,'NFD'),'&#x0301;&#x0313;&#x0314;&#x0342;','')"/>
                                <xsl:call-template name="print-lemmas"/>
                            </xsl:for-each-group>
                        </ul>
                    </xsl:if>
                    <br/>
                </body>
            </html>
        </xsl:result-document>
        
        <xsl:result-document href="persons.html" method="xhtml" doctype-system="http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
            <html>
                <head>
                    <title>Index</title>
                    <xsl:call-template name="headerscripts"/>
                </head>
                <body>
                    <div id="banner">
                        <div><div><h1>Demetrios of Skepsis</h1></div></div>
                    </div>
                    
                    <xsl:call-template name="menu">
                        <xsl:with-param name="context">
                            <xsl:text>indices</xsl:text>
                        </xsl:with-param>
                    </xsl:call-template>
                    
                    <h1 style="margin-left:600px;">Index of persons</h1>
                    
                    
                    <xsl:if test="$mastervar//persName">
                        <h3 style="margin-left:300px;">Attested persons</h3>
                        <ul style="margin-left:300px;">
                            <xsl:for-each-group select="$mastervar//persName" group-by="@nymRef">
                                <xsl:for-each select="(@nymRef)">
                                    <xsl:sort/>
                                <li>
                                        <xsl:value-of select="."/>
                                </li>
                                </xsl:for-each>
                            </xsl:for-each-group>
                        </ul>
                    </xsl:if>
                    <br/>
                </body>
            </html>
        </xsl:result-document>
    </xsl:template>
    
    <xsl:template name="print-lemmas">
        <li>
            <xsl:variable name="placecontent">
                <xsl:for-each select="tokenize(@nymRef, ' ')">
                    <xsl:value-of select="."/>
                    <xsl:if test="position()!=last()">
                        <xsl:text>, </xsl:text>
                    </xsl:if>
                </xsl:for-each>
            </xsl:variable>
            <xsl:choose>
                <xsl:when test="@ref">
                    <a href="{@ref}">
                        <xsl:value-of select="$placecontent"/>
                    </a>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:value-of select="$placecontent"/>
                </xsl:otherwise>
            </xsl:choose>
        </li>
    </xsl:template>




    <!-- Text templates -->

    <!-- structure -->
    <xsl:template match="text/body/div[@type='edition']">
        <div id="content"
            style="margin-left: 300px; margin-right:300px;
            height:auto;
            margin-bottom: 100px;
            text-align:left;">
            <xsl:choose>
                <xsl:when test="matches(@n,'[a-z]')">
                    <xsl:value-of select="@n"/>) </xsl:when>
                <xsl:otherwise/>
            </xsl:choose>
            <xsl:apply-templates/>
        </div>
    </xsl:template>


    <xsl:template match="body/head">
        <h3 style="margin-left: 300px; margin-right:300px; margin-bottom: 50px; text-align:center;">
            <xsl:apply-templates/>
        </h3>
    </xsl:template>

    <xsl:template match="div/head">
        <h3 align="center">
            <xsl:apply-templates/>
        </h3>
    </xsl:template>

    <xsl:template match="text/body/div[@type='apparatus']">
        <h4
            style="margin-left: 300px;
            margin-right:300px;
            margin-bottom: 10px;
            text-align: left;">
            <xsl:value-of select="concat(upper-case(substring(@type,1,1)),substring(@type,2))"/>
        </h4>
        <xsl:choose>
            <xsl:when test="/node()[text()]">
                <div id="apparatus"
                    style="width:55%;
                margin-left: 300px;
                margin-bottom: 50px;
                margin-top: 10px;
                text-align:left;">
                    <xsl:apply-templates/>
                </div>
            </xsl:when>
            <xsl:otherwise/>
        </xsl:choose>
    </xsl:template>

    <xsl:template match="text/body/div[@type='commentary']">
        <h4
            style="margin-left: 300px; margin-right:300px;
            margin-bottom: 10px;
            text-align: left;">
            <xsl:value-of select="concat(upper-case(substring(@type,1,1)),substring(@type,2))"/>
        </h4>
        <xsl:choose>
            <xsl:when test="/node()[text()]">
                <div id="commentary"
                    style="
                    margin-left: 300px; margin-right:300px;
            margin-bottom: 50px;
            margin-top: 10px;
            text-align:left;">
                    <xsl:apply-templates/>
                </div>
            </xsl:when>
            <xsl:otherwise/>
        </xsl:choose>
    </xsl:template>

    <xsl:template match="text/body/div[@type='translation']">
        <h4
            style="margin-left: 300px; margin-right:300px;
            margin-bottom: 10px;
            text-align: left;">
            <xsl:value-of select="concat(upper-case(substring(@type,1,1)),substring(@type,2))"/>
        </h4>
        <div id="transaltion"
            style="margin-left: 300px; margin-right:300px;
            margin-bottom: 50px;
            margin-top: 10px;
            text-align:left;">
            <xsl:choose>
                <xsl:when test="/node()[text()]">
                    <xsl:apply-templates/>
                </xsl:when>
                <xsl:otherwise/>
            </xsl:choose>
        </div>
    </xsl:template>


    <xsl:template match="seg">
        <xsl:element name="div">
            <xsl:attribute name="type">
                <xsl:text>citation</xsl:text>
            </xsl:attribute>
            <xsl:attribute name="style">
                <xsl:text>margin-left:100px;
            margin-top:50px;
            margin-bottom:50px;
            text-align:left;</xsl:text>
                <xsl:if test="descendant::l">
                    <xsl:text>line-height: 175%;</xsl:text>
                </xsl:if>
            </xsl:attribute>
            <xsl:choose>
                <xsl:when test="@resp='strabo'"/>
                <xsl:when test="@resp='homer'"/>
                <xsl:otherwise>
                    <i>(<xsl:value-of
                            select="concat(upper-case(substring(@resp,1,1)),substring(@resp,2))"
                        />:)</i>
                </xsl:otherwise>
            </xsl:choose>
            <xsl:apply-templates/>
        </xsl:element>
    </xsl:template>

    <xsl:template match="seg[@type='cf']"> Cf.<xsl:apply-templates/>
        <br/>
    </xsl:template>

    <xsl:template match="ab/seg[@type='context']">
        <p>
            <xsl:choose>
                <xsl:when test="matches(@n,'[a-z]')">
                    <xsl:value-of select="@n"/>) </xsl:when>
                <xsl:otherwise/>
            </xsl:choose>
            <xsl:apply-templates/>
        </p>
    </xsl:template>



    <xsl:template match="seg//supplied">
        <xsl:text>&lt;</xsl:text>
        <xsl:apply-templates/>
        <xsl:text>&gt;</xsl:text>
    </xsl:template>


    <xsl:template match="p">
        <p>
            <xsl:apply-templates/>
        </p>
    </xsl:template>

    <xsl:template match="l">
        <xsl:apply-templates/>
        <xsl:if test="following-sibling::l">
            <xsl:element name="br"/>
        </xsl:if>
    </xsl:template>

    <xsl:template match="quote">
        <xsl:text>"</xsl:text>
        <xsl:apply-templates/>
        <xsl:text>"</xsl:text>
    </xsl:template>

    <xsl:template match="add">
        <xsl:text>(</xsl:text>
        <xsl:apply-templates/>
        <xsl:text>)</xsl:text>
    </xsl:template>

    <xsl:template match="num">
        <xsl:apply-templates/>' </xsl:template>

    <xsl:template match="seg[not(@type='testimonium')]/title">
        <i>
            <xsl:apply-templates/>
        </i>
    </xsl:template>



    <xsl:template match="floatingText">
        <i>
            <xsl:text>...</xsl:text>
            <xsl:apply-templates/>
            <xsl:text>...</xsl:text>
        </i>
    </xsl:template>
    
    <xsl:template match="floatingText/body/ab">
        <p style="inline">
            <xsl:apply-templates/>
        </p>
    </xsl:template>


    <!-- apparatus -->

    <xsl:template match="rdg">
        <xsl:apply-templates/>
        <xsl:if test="@cert='low'">
            <xsl:apply-templates select="rdg"/>
            <xsl:text>?</xsl:text>
        </xsl:if>
        <xsl:if test="@resp">
            <xsl:for-each select="tokenize(@resp,' ')">
            <xsl:text> </xsl:text>
            <xsl:element name="a">
                <xsl:attribute name="href">
                    <xsl:value-of select="concat('bibliography.html#',substring-after(.,'#'))"/>
                </xsl:attribute>
                <xsl:attribute name="title">
                    <xsl:value-of select="normalize-space(doc('../xml/bibliography.xml')//*[@xml:id=substring-after(current(),'#')])"/>
                </xsl:attribute>
                <xsl:choose>
                    <xsl:when test="doc('../xml/bibliography.xml')//msDesc[@xml:id=substring-after(current(),'#')]">
                        <xsl:value-of select="doc('../xml/bibliography.xml')//msDesc[@xml:id=substring-after(current(),'#')]//msName"/>
                    </xsl:when>
                    <xsl:when test="doc('../xml/bibliography.xml')//bibl[@xml:id=substring-after(current(),'#')]//*[@role='principal']/surname">
                        <xsl:value-of select="doc('../xml/bibliography.xml')//bibl[@xml:id=substring-after(current(),'#')]//*[@role='principal']/surname[1]"/>
                    </xsl:when>
                    <xsl:when test="doc('../xml/bibliography.xml')//bibl[@xml:id=substring-after(current(),'#')]//*[@role='principal']">
                        <xsl:value-of select="doc('../xml/bibliography.xml')//bibl[@xml:id=substring-after(current(),'#')]//*[@role='principal']"/>
                    </xsl:when>
                    <xsl:when test="doc('../xml/bibliography.xml')//bibl[@xml:id=substring-after(current(),'#')]//(author|editor)[1]/surname">
                        <xsl:value-of select="doc('../xml/bibliography.xml')//bibl[@xml:id=substring-after(current(),'#')]//(author|editor)[1]/surname"/>
                    </xsl:when>
                    <xsl:when test="doc('../xml/bibliography.xml')//bibl[@xml:id=substring-after(current(),'#')]//(author|editor)">
                        <xsl:value-of select="doc('../xml/bibliography.xml')//bibl[@xml:id=substring-after(current(),'#')]//(author|editor)[1]"/>
                    </xsl:when>
                </xsl:choose>
            </xsl:element>
            </xsl:for-each>
            <!--<xsl:choose>
                <xsl:when test="contains(@resp,' ')">
                    <xsl:variable name="sources" select="//sourceDesc//listBibl"/>
                    <xsl:for-each select="tokenize(@resp,' ')">
                        <xsl:if test="$sources//bibl[@xml:id=substring-after(current(),'#')]">
                            <xsl:text> </xsl:text>
                        </xsl:if>
                        <xsl:value-of select="$sources//*[@xml:id=substring-after(current(),'#')]"/>
                        <xsl:if
                            test="$sources//bibl[@xml:id=substring-after(current(),'#')]
                            and not(position()=last())">
                            <xsl:text> </xsl:text>
                        </xsl:if>
                    </xsl:for-each>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:value-of select="//*[@xml:id=substring-after(current()/@resp,'#')]"/>
                </xsl:otherwise>
            </xsl:choose>--> 
        </xsl:if>
        <xsl:if test="following-sibling::*">
            <xsl:text>,</xsl:text>
        </xsl:if>
        <xsl:choose>
            <xsl:when test="@type='omitted'">
                <xsl:value-of select="rdg"/> (em.) </xsl:when>
            <xsl:when test="@type='deleted'">
                <xsl:value-of select="rdg"/> (del.) </xsl:when>
            <xsl:when test="@type='supplied'">
                <xsl:value-of select="rdg"/> (suppl.) </xsl:when>
            <xsl:when test="@type='added'">
                <xsl:value-of select="rdg"/> (add.) </xsl:when>
        </xsl:choose>
    </xsl:template>


    <xsl:template match="anchor">
        <xsl:element name="a">
            <xsl:attribute name="href">
                <xsl:text>#</xsl:text>
                <xsl:value-of select="@xml:id"/>
            </xsl:attribute>
            <xsl:attribute name="title">
                <xsl:variable name="appcontent">
                    <xsl:apply-templates
                        select="//app[substring-after(@from,'#')=current()/@xml:id]/."/>
                </xsl:variable>
                <xsl:value-of select="normalize-space($appcontent)"/>
            </xsl:attribute>
            <xsl:attribute name="id">
                <xsl:value-of select="concat('ref-',@xml:id)"/>
            </xsl:attribute>
            <xsl:element name="sup">
                <xsl:value-of select="substring-after(@xml:id,'app')"/>
            </xsl:element>
        </xsl:element>
    </xsl:template>

    <xsl:template match="listApp">
        <hr/>
        <p class="sub">
            <xsl:apply-templates/>
        </p>
    </xsl:template>


    <xsl:template match="app">
        <xsl:if test="preceding-sibling::app">
            <xsl:element name="br"/>
        </xsl:if>
        <xsl:element name="a">
            <xsl:attribute name="href">
                <xsl:value-of select="concat('#ref-',substring-after(@from,'#'))"/>
            </xsl:attribute>
            <xsl:attribute name="title">
                <xsl:text>return to text</xsl:text>
            </xsl:attribute>
            <xsl:attribute name="id">
                <xsl:value-of select="substring-after(@from,'#')"/>
            </xsl:attribute>
            <xsl:element name="sup">
                <xsl:value-of select="substring-after(@from,'#app')"/>
            </xsl:element>
        </xsl:element>
        <xsl:apply-templates/>
    </xsl:template>


    <!-- bibliography -->

    <xsl:template match="listBibl">
        <ul>
            <xsl:apply-templates/>
        </ul>
    </xsl:template>

    <xsl:template match="bibl[parent::listBibl]">
        <li>
            <a id="{@xml:id}"><xsl:comment>empty</xsl:comment></a>
            <xsl:apply-templates/>
        </li>
    <br/>
    </xsl:template>
    
    <xsl:template match="msDesc[parent::listBibl]">
        <li>
            <a id="{@xml:id}"><xsl:comment>empty</xsl:comment></a>
            <xsl:apply-templates select="descendant::msName"/>
            <xsl:text>, </xsl:text>
            <xsl:apply-templates select="descendant::idno"/>
        </li>
    </xsl:template>
    
    <xsl:template match="div[@type='editions']">
        <div id="content"
            style="margin-left: 300px; margin-right:300px;
            height:auto;
            margin-bottom: 100px;
            text-align:left;
            color:#000000;">
            <xsl:apply-templates/>
        </div>
    </xsl:template>
    
    <xsl:template match="div[@type='collections']">
        <div id="content"
            style="width:55%;
            height:auto;
            margin-left: 300px;
            margin-bottom: 100px;
            text-align:left;
            color:#000000;">
            <xsl:apply-templates/>
        </div>
    </xsl:template>

    <xsl:template match="div[@type='manuscripts']">
        <div id="content"
            style="width:55%;
            height:auto;
            margin-left: 300px;
            margin-bottom: 100px;
            text-align:left;
            color:#000000;">
            <xsl:apply-templates/>
        </div>
    </xsl:template>
    
    <xsl:template match="bibl/title">
        <i>
            <xsl:apply-templates/>
        </i>
    </xsl:template>
    
    <xsl:template match="relatedItem"/>
    
    <xsl:template match="biblScope[@type='pp']">
        p. <xsl:apply-templates/>
    </xsl:template>



    <!-- references, links -->
    <xsl:template match="ref">
        <xsl:choose>
            <xsl:when test="ancestor::seg[@resp='homer']">
                <a>
                    <xsl:attribute name="href">
                        <xsl:value-of select="@target"/>
                    </xsl:attribute>
                    <i>
                        <xsl:apply-templates/>
                    </i>
                </a>
                <br/>
            </xsl:when>
            <xsl:otherwise>
                <a>
                    <xsl:attribute name="href">
                        <xsl:value-of select="@target"/>
                    </xsl:attribute>
                    <i>
                        <xsl:apply-templates/>
                    </i>
                </a>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <xsl:template match="geogName[@ref]">
        <a>
            <xsl:attribute name="href">
                <xsl:value-of select="@ref"/>
            </xsl:attribute>
            <xsl:apply-templates/>
        </a>
    </xsl:template>

    <xsl:template match="placeName[@ref]">
        <a>
            <xsl:attribute name="href">
                <xsl:value-of select="@ref"/>
            </xsl:attribute>
            <xsl:apply-templates/>
        </a>
    </xsl:template>
 

   



</xsl:stylesheet>
