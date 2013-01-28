<?php
/**
 * PHPUnit
 *
 * Copyright (c) 2002-2011, Sebastian Bergmann <sebastian@phpunit.de>.
 * All rights reserved.
 *
 * Redistribution and use in source and binary forms, with or without
 * modification, are permitted provided that the following conditions
 * are met:
 *
 *   * Redistributions of source code must retain the above copyright
 *     notice, this list of conditions and the following disclaimer.
 *
 *   * Redistributions in binary form must reproduce the above copyright
 *     notice, this list of conditions and the following disclaimer in
 *     the documentation and/or other materials provided with the
 *     distribution.
 *
 *   * Neither the name of Sebastian Bergmann nor the names of his
 *     contributors may be used to endorse or promote products derived
 *     from this software without specific prior written permission.
 *
 * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
 * "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
 * LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS
 * FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE
 * COPYRIGHT OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT,
 * INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING,
 * BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
 * LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER
 * CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT
 * LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN
 * ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
 * POSSIBILITY OF SUCH DAMAGE.
 */

/**
 * PHPUnit manual example.
 *
 * @package    PHPUnit_ExampleSolver
 * @author     Jeff Welch <whatthejeff@gmail.com>
 * @copyright  2011 Sebastian Bergmann <sb@sebastian-bergmann.de>
 * @license    http://www.opensource.org/licenses/bsd-license.php  BSD License
 * @version    Release: @package_version@
 * @link       http://www.phpunit.de/
 */
class PHPUnit_ExampleSolver_Manual_Example
{
    /**
     * Dom for the manual page.
     *
     * @var DOMDocument
     */
    protected $page;

    /**
     * The `<programlisting>` element for the example.
     *
     * @var DOMNode
     */
    protected $listing;

    /**
     * The `<screen>` element for the example.
     *
     * @var DOMNode
     */
    protected $screen;

    /**
     * The `<userinput>` element for the example.
     *
     * @var DOMNode
     */
    protected $input;

    /**
     * Path to the fixtures directory.
     *
     * @var string
     */
    protected static $fixtures;

    /**
     * Path to the temp directory.
     *
     * @var string
     */
    protected static $temp;

    /**
     * Loads a manual page example.
     *
     * @param DomDocument $page Dom for the manual page.
     * @param DOMNode     $listing `<programlisting>` element for the example.
     * @param DOMNode     $screen `<screen>` element for the example.
     * @param DOMNode     $input `<userinput>` element for the example.
     */
    public function __construct(DomDocument $page, DOMNode $listing,
        DOMNode $screen, DOMNode $input)
    {
        $this->page = $page;

        $this->listing = $listing;
        $this->screen = $screen;
        $this->input = $input;

        if (!self::$fixtures) {
            self::$fixtures = dirname(dirname(__FILE__)) . '/Fixtures';
            self::$temp = realpath(sys_get_temp_dir());
        }
    }

    /**
     * Solves the example, updating the DOM to reflect the new solution.
     */
    public function solve()
    {
        $input = trim($this->input->nodeValue);

        $lastSpace = strrpos($input, ' ');
        $command = substr($input, 0, $lastSpace);
        $filepath = sprintf(
          '%s/%s.php', self::$temp, substr($input, $lastSpace + 1)
        );

        $listingContent = str_replace(
          array(
            '/home/sb/expected.xml',
            '/home/sb/actual.xml',
            '/home/sb/expected',
            '/home/sb/actual',
            '/path/to/expected.txt',
            'CsvFileIterator.php',
            'data.csv',
            'BowlingGame.php'
          ),
          array(
            self::$fixtures . '/expected.xml',
            self::$fixtures . '/actual.xml',
            self::$fixtures . '/expected',
            self::$fixtures . '/actual',
            self::$fixtures . '/expected.txt',
            self::$fixtures . '/CsvFileIterator.php',
            self::$fixtures . '/data.csv',
            self::$fixtures . '/BowlingGame.php'
          ),
          $this->listing->nodeValue
        );

        if (@file_put_contents($filepath, $listingContent) === false) {
            throw new RuntimeException(
              sprintf('Could not write to "%s".', $filepath)
            );
        }

        $output = shell_exec(
          sprintf('%s %s', $command, escapeshellarg($filepath))
        );
        unlink($filepath);

        $output = str_replace(self::$temp, '/home/sb', $output);
        if (htmlspecialchars($output) != $output) {
            $newOutput = $this->page->createCDATASection("\n$output");
        } else {
            $newOutput = $this->page->createTextNode("\n$output");
        }

        $newScreen = $this->page->createElement('screen');
        $newScreen->appendChild($this->input);
        $newScreen->appendChild($newOutput);

        $this->screen->parentNode->replaceChild($newScreen, $this->screen);
    }
}