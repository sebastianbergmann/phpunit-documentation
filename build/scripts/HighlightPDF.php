#!/usr/bin/env php
<?php

/**
 * Code freely inspired by http://blog.astrumfutura.com/archives/369-Writing-Professional-Looking-Documentation-With-Docbook,-PHP,-Phing-and-Apache-FOP-Part-1-Getting-Started.html
 * @author Mickael Perraud <mikaelkael@php.net>
 * @license http://creativecommons.org/licenses/by/3.0/legalcode Creative Commons Attribution 3.0 Unported License
 */
class HighlightPDF
{

    private static $_filename;

    private static $_dom;

    private static $_lang;

    public static function main($file)
    {
        self::$_filename = $file;
        self::highlightFile();
    }

    public static function highlightFile()
    {
        self::$_dom = new DOMDocument();
        self::$_dom->load(self::$_filename);
        $xpath = new DOMXPath(self::$_dom);
        $elements = $xpath->query("//fo:block[@codehl]");
        foreach ($elements as $block) {
            $code = self::_highlight($block->nodeValue);
            $code_block = self::_createBlockCode($code);
            foreach ($block->childNodes as $node) {
                $block->removeChild($node);
            }
            $block->appendChild($code_block);
            $block->removeAttribute('codehl');
        }
        self::$_dom->save(self::$_filename);
    }

    private static function _highlight($code)
    {
        $code = trim(
                str_replace(array('&amp;' , '&gt;' , '&lt;' , '&quot;'),
                        array('&' , '' , '' , '>' , '<' , '"'),
                        $code));
        if (substr($code, 0, 5) == '<?php') {
            $codehl = highlight_string($code, true);
        } else {
            $codehl = $code;
        }
        $codehl = str_replace(array('<code>' , '</code>' , '&nbsp;' , '<br />' , "\r"),
                array('' , '' , ' ' , "\n" , "\n"),
                $codehl);
        $codehl = str_replace(array('&gt;' , '&lt;' , '&'), array('$$$$$' , '£££££' , '&amp;'), $codehl);
        $codehl = str_replace(array('$$$$$' , '£££££'), array('&gt;' , '&lt;'), $codehl);
        $codehl = preg_replace("!\n\n\n+!", "\n\n", $codehl);
        $codehl = trim($codehl);
        return $codehl;
    }

    private static function _createBlockCode($code)
    {
        if (substr($code, 0, 5) == '<span') {
            $dom = new DomDocument();
            $dom->loadXML($code);
            $xpath = new DomXPath($dom);
            $parentSpan = $xpath->query('/span')->item(0);
            $block_code = self::$_dom->createElement('fo:inline');
            $block_code->setAttribute('color', substr($parentSpan->getAttributeNode('style')->value, 7, 7));
            $nodes = $xpath->query('/span/node()');
            foreach ($nodes as $node) {
                if ($node->nodeType == XML_ELEMENT_NODE) {
                    $child = self::$_dom->createElement('fo:inline', $node->nodeValue);
                    $child->setAttribute('color',
                            substr(
                                    $node->getAttributeNode(
                                            'style')->value,
                                    7,
                                    7));
                } else {
                    $child = self::$_dom->importNode($node, true);
                }
                $block_code->appendChild($child);
            }
            if (preg_match("/^\s+$/", $block_code->firstChild->textContent)) {
                $block_code->removeChild($block_code->firstChild);
            }
        } else {
            $block_code = self::$_dom->createElement('fo:inline', $code);
        }
        return $block_code;
    }
}

HighlightPDF::main($argv[1]);
