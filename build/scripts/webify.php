#!/usr/bin/env php
<?php
require dirname(__FILE__) . DIRECTORY_SEPARATOR . 'HTMLFilterIterator.php';

function webify_directory($directory, $language, $version)
{
    $toc = get_substring(
        file_get_contents($directory . DIRECTORY_SEPARATOR . 'index.html'),
        '<dl class="toc">',
        '</dl>',
        true,
        true,
        true
    );

    $toc = str_replace(
        'class="toc"',
        'class="toc nav hidden-print"',
        $toc
    );

    $editions  = array(
      'en'    => array('6.5', '6.4', '5.7'),
      'fr'    => array('6.5', '6.4', '5.7'),
      'ja'    => array('6.5', '6.4', '5.7'),
      'pt_br' => array('6.5', '6.4', '5.7'),
      'zh_cn' => array('6.5', '6.4', '5.7')
    );

    $old          = '5.7';
    $stable       = '6.4';
    $beta         = '6.5';
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
        if ($_version == $old) {
            $type = 'old';
        }

        if ($_version == $stable) {
            $type = '<strong>stable</strong>';
        }

        if ($_version == $beta) {
            $type = 'beta';
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
        webify_file($file->getPathName(), $toc, $languageList, $versionList, $language, $version);
    }
}

function webify_file($file, $toc, $languageList, $versionList, $language, $version)
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
        __DIR__ . DIRECTORY_SEPARATOR . 'templates' . DIRECTORY_SEPARATOR . 'page.html'
    );


    //i18n for title
    $title_text = array(
        'en' => 'PHPUnit Manual',
        'fr' => 'Manuel PHPUnit',
        'zh_cn' => 'PHPUnit 手册',
        'ja' => 'PHPUnit マニュアル',
        'pt_br' => 'Manual PHPUnit',
    );

    $title       = get_text_in_language($title_text, $language);
    $content     = '';
    $prev        = '';
    $next        = '';
    $suggestions = '';

    // i18n for text on page.
    $prev_text = array(
        'en' => 'Prev',
        'fr' => 'Précédent',
        'zh_cn' => '上一章',
        'ja' => '戻る',
        'pt_br' => 'Anterior',
    );

    $next_text = array(
        'en' => 'Next',
        'fr' => 'Suivant',
        'zh_cn' => '下一章',
        'ja' => '次へ',
        'pt_br' => 'Próximo',
    );

    $suggestions_text = array(
        'en' => 'Please <a href="https://github.com/sebastianbergmann/phpunit-documentation/issues">open a ticket</a> on GitHub to suggest improvements to this page. Thanks!',
        'fr' => '<a href="https://github.com/sebastianbergmann/phpunit-documentation/issues">Ouvrez un ticket</a> sur GitHub pour proposer des améliorations à cette page. Merci!',
        'zh_cn' => '如果对本页有改进建议，请 <a href="https://github.com/sebastianbergmann/phpunit-documentation/issues">在 GitHub 上开启任务单</a>。万分感谢！',
        'ja' => 'このページの改善案を<a href="https://github.com/sebastianbergmann/phpunit-documentation/issues">GitHubで提案</a>してください!',
        'pt_br' => 'Por favor, <a href="https://github.com/sebastianbergmann/phpunit-documentation/issues">abra um chamado</a> no GitHub para sugerir melhorias para esta página. Obrigado!',
    );

    if ($filename !== 'index.html') {
        if (strpos($filename, 'appendixes') === 0) {
            $type = 'appendix';
        }         elseif (strpos($filename, 'preface') === 0) {
            $type = 'preface';
        } else {
            $type = 'chapter';
        }

        $buffer      = file_get_contents($file);
        $_title      = get_substring($buffer, '<title>', '</title>', false, false);
        $content     = get_substring($buffer, '<div class="' . $type . '"', '<div class="navfooter">', true, false);
        $prev        = get_substring($buffer, '<link rel="prev" href="', '" title', false, false);
        $next        = get_substring($buffer, '<link rel="next" href="', '" title', false, false);
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
    if (array_key_exists($lang, $text_list)) {
        return $text_list[$lang];
    } else {
        return $text_list['en'];
    }
}

function get_substring($buffer, $start, $end, $includeStart = true, $includeEnd = true, $strrpos = false)
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

    if ($start !== false) {
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
