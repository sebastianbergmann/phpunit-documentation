#!/usr/bin/env php
<?php
require dirname(__FILE__) . DIRECTORY_SEPARATOR . 'HTMLFilterIterator.php';

function webify_directory($directory, $edition)
{
    $toc = get_substring(
      file_get_contents($directory . DIRECTORY_SEPARATOR . 'index.html'),
      '<dl>',
      '</dl>',
      TRUE,
      TRUE,
      TRUE
    );

    $_editions = '';
    $editions  = array(
      'en' => array('3.8', '3.7'),
      'fr' => array('3.8', '3.7'),
      'ja' => array('3.8', '3.7'),
      'br' => array('3.8', '3.7')
    );

    foreach ($editions as $language => $versions) {
        foreach ($versions as $version) {
            if ($language . '-' . $version == $edition) {
                $active = ' class="active"';
            } else {
                $active = '';
            }

            switch ($language) {
                case 'de': {
                    $_language = 'German';
                }
                break;

                case 'en': {
                    $_language = 'English';
                }
                break;

                case 'fr': {
                    $_language = 'French';
                }
                break;

                case 'ja': {
                    $_language = 'Japanese';
                }
                break;

                case 'br': {
                    $_language = 'Brazilian Portuguese';
                }
                break;
            }

            $_editions .= sprintf(
              '<li><a href="http://www.phpunit.de/manual/%s/%s/index.html"%s>PHPUnit %s <span><small>%s</small></span></a></li>',
              $version,
              $language,
              $active,
              $version,
              $_language
            );
        }
    }

    foreach (new HTMLFilterIterator(new DirectoryIterator($directory)) as $file) {
        webify_file($file->getPathName(), $toc, $_editions);
    }
}

function webify_file($file, $toc, $editions)
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
      array('{title}', '{content}', '{toc}', '{editions}', '{prev}', '{next}'),
      array($title, $content, $toc, $editions, $prev, $next),
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

webify_directory($argv[1], $argv[2]);
