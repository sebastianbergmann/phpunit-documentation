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

    $toc = str_replace(
      'class="toc"',
      'class="toc nav hidden-print"',
      $toc
    );

    $editions  = array(
      'en'    => array('4.3', '4.2', '3.7'),
      //'fr'    => array('4.2', '4.1', '3.7'),
      'ja'    => array('4.3', '4.2', '3.7'),
      //'pt_br' => array('4.2', '4.1', '3.7'),
      'zh_cn' => array('4.3', '4.2', '3.7')
    );

    $old          = '3.7';
    $stable       = '4.2';
    $beta         = '4.3';
    $alpha        = null;
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

            case 'zh_cn': {
                $_languageName = 'Simplified Chinese';
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

    $versions = $editions[array_key_exists($language, $editions) ? $language : 'en'];

    foreach ($versions as $_version) {
        if ($_version == $stable) {
            $type = '<strong>stable</strong>';
        }

        if ($_version == $old) {
            $type = 'old, but stable';
        }

        if ($_version == $beta) {
            $type = 'beta';
        }

        if ($_version == $alpha) {
            $type = 'alpha';
        }

        $versionList .= sprintf(
          '<li%s><a href="../../%s/%s/index.html">%s (%s)</a></li>',
          $version == $_version ? ' class="active"' : '',
          $_version,
          $language,
          $_version,
          $type
        );
    }

    foreach (new HTMLFilterIterator(new DirectoryIterator($directory)) as $file) {
        webify_file($file->getPathName(), $toc, $languageList, $versionList, $language);
    }
}

function webify_file($file, $toc, $languageList, $versionList, $language)
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


	//i18n for title
	$title_text = array(
        'en' => 'PHPUnit Manual',
        'zh_cn' => 'PHPUnit 手册',
		'ja' => 'PHPUnit マニュアル',
    );

    $title       = get_text_in_language($title_text, $language);
    $content     = '';
    $prev        = '';
    $next        = '';
    $suggestions = '';

    // i18n for text on page.
    $prev_text = array(
        'en' => 'Prev',
        'zh_cn' => '上一章',
        'ja' => '戻る',
    );
    $next_text = array(
        'en' => 'Next',
        'zh_cn' => '下一章',
        'ja' => '次へ',
    );
    $suggestions_text = array(
        'en' => 'Please <a href="https://github.com/sebastianbergmann/phpunit-documentation/issues">open a ticket</a> on GitHub to suggest improvements to this page. Thanks!',
        'zh_cn' => '如果对本页有改进建议，请 <a href="https://github.com/sebastianbergmann/phpunit-documentation/issues">在 GitHub 上开启任务单</a>。万分感谢！',
        'ja' => 'このページの改善案を<a href="https://github.com/sebastianbergmann/phpunit-documentation/issues">GitHubで提案</a>してください!',
    );

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

        $buffer      = file_get_contents($file);
        $_title      = get_substring($buffer, '<title>', '</title>', FALSE, FALSE);
        $content     = get_substring($buffer, '<div class="' . $type . '"', '<div class="navfooter">', TRUE, FALSE);
        $prev        = get_substring($buffer, '<link rel="prev" href="', '" title', FALSE, FALSE);
        $next        = get_substring($buffer, '<link rel="next" href="', '" title', FALSE, FALSE);
        $suggestions = '<div class="row"><div class="col-md-2"></div><div class="col-md-8"><div class="alert alert-info" style="text-align: center;">' . get_text_in_language($suggestions_text, $language) . '</div></div><div class="col-md-2"></div></div>';

        if (!empty($prev)) {
            $prev = '<a accesskey="p" href="' . $prev . '">' . get_text_in_language($prev_text, $language) . '</a>';
        }

        if (!empty($next)) {
            $next = '<a accesskey="n" href="' . $next . '">' . get_text_in_language($next_text, $language) . '</a>';
        }

        if (!empty($_title)) {
            $title .= ' &#8211; ' . $_title;
        }
    }

    $buffer = str_replace(
      array('{filename}', '{title}', '{content}', '{toc}', '{languages}', '{language}', '{versions}', '{prev}', '{next}', '<div class="caution" style="margin-left: 0.5in; margin-right: 0.5in;">', '<div class="warning" style="margin-left: 0.5in; margin-right: 0.5in;">', '<div class="note" style="margin-left: 0.5in; margin-right: 0.5in;">', '{suggestions}'),
      array($filename, $title, $content, $toc, $languageList, $language, $versionList, $prev, $next, '<div class="alert alert-warning">', '<div class="alert alert-danger">', '<div class="alert alert-info">', $suggestions),
      $template
    );

    file_put_contents($file, $buffer);
}

function get_text_in_language($text_list, $lang)
{
    if(array_key_exists($lang, $text_list)){
        return $text_list[$lang];
    }
    else{
        return $text_list['en'];
    }
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
