#!/usr/bin/env php
<?php
require dirname(__FILE__) . DIRECTORY_SEPARATOR . 'HTMLFilterIterator.php';

function webify_directory($directory, $language, $version)
{
    $toc = get_substring(
      file_get_contents($directory . DIRECTORY_SEPARATOR . 'index.html'),
      '<dl class="toc">',
      '</dl>',
      TRUE,
      TRUE,
      TRUE
    );

    $editions  = array(
      'en'    => array('3.8', '3.7'),
      'fr'    => array('3.8', '3.7'),
      'ja'    => array('3.8', '3.7'),
      'pt_br' => array('3.8', '3.7')
    );

    $languageList = '';
    $versionList  = '';

    foreach ($editions as $_language => $versions) {
        switch ($_language) {
            case 'de': {
                $_languageName = 'German';
            }
            break;

            case 'en': {
                $_languageName = 'English';

                foreach ($versions as $_version) {
                    $versionList .= sprintf(
                      '<li%s><a href="../../%s/%s/index.html">PHPUnit %s</a></li>',
                      $version == $_version ? ' class="active"' : '',
                      $_version,
                      $language,
                      $_version
                    );
                }
            }
            break;

            case 'fr': {
                $_languageName = 'French';
            }
            break;

            case 'ja': {
                $_languageName = 'Japanese';
            }
            break;

            case 'pt_br': {
                $_languageName = 'Brazilian Portuguese';
            }
            break;
        }

        $languageList .= sprintf(
          '<li%s><a href="../%s/index.html">%s</a></li>',
          $language == $_language ? ' class="active"' : '',
          $_language,
          $_languageName
        );
    }

    foreach (new HTMLFilterIterator(new DirectoryIterator($directory)) as $file) {
        webify_file($file->getPathName(), $toc, $languageList, $versionList);
    }
}

function webify_file($file, $toc, $languageList, $versionList)
{
    $filename = basename($file);

    if ($filename == 'phpunit-book.html') {
        return;
    }

    $toc = str_replace(
      '<a href="' . $filename . '">',
      '<a href="' . $filename . '" class="active">',
      $toc
    );

    $template = file_get_contents(
      dirname(__FILE__) . DIRECTORY_SEPARATOR . 'templates' . DIRECTORY_SEPARATOR . 'page.html'
    );

    $title   = '';
    $content = '';
    $prev    = '';
    $next    = '';

    if ($filename !== 'index.html') {
        if (strpos($filename, 'appendixes') === 0) {
            $type = 'appendix';
        }

        else if (strpos($filename, 'preface') === 0) {
            $type = 'preface';
        }

        else {
            $type = 'chapter';
        }

        $buffer  = file_get_contents($file);
        $title   = get_substring($buffer, '<title>', '</title>', FALSE, FALSE);
        $content = get_substring($buffer, '<div class="' . $type . '"', '<div class="navfooter">', TRUE, FALSE);
        $prev    = get_substring($buffer, '<link rel="prev" href="', '" title', FALSE, FALSE);
        $next    = get_substring($buffer, '<link rel="next" href="', '" title', FALSE, FALSE);

        if (!empty($prev)) {
            $prev = '<a accesskey="p" href="' . $prev . '">Prev</a>';
        }

        if (!empty($next)) {
            $next = '<a accesskey="n" href="' . $next . '">Next</a>';
        }
    }

    $buffer = str_replace(
      array('{title}', '{content}', '{toc}', '{languages}', '{versions}', '{prev}', '{next}', '<div class="caution" style="margin-left: 0.5in; margin-right: 0.5in;">', '<div class="note" style="margin-left: 0.5in; margin-right: 0.5in;">'),
      array($title, $content, $toc, $languageList, $versionList, $prev, $next, '<div class="alert alert-error">', '<div class="alert alert-info">'),
      $template
    );

    if (function_exists('tidy_repair_string')) {
        $buffer = tidy_repair_string(
          $buffer,
          array(
            'indent'       => TRUE,
            'output-xhtml' => TRUE,
            'wrap'         => 0
          ),
          'utf8'
        );
    }

    file_put_contents($file, $buffer);
}

function get_substring($buffer, $start, $end, $includeStart = TRUE, $includeEnd = TRUE, $strrpos = FALSE)
{
    if ($includeStart) {
        $prefix = 0;
    } else {
        $prefix = strlen($start);
    }

    if ($includeEnd) {
        $suffix = strlen($end);
    } else {
        $suffix = 0;
    }

    $start = strpos($buffer, $start);

    if ($strrpos) {
        $_end = strrpos($buffer, $end);
    } else {
        $_end = strpos($buffer, $end, $start);
    }

    if ($start !== FALSE) {
        return substr(
          $buffer,
          $start + $prefix,
          $_end - ($start + $prefix) + $suffix
        );
    } else {
        return '';
    }
}

webify_directory($argv[1], $argv[2], $argv[3]);
