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
 * PHPUnit manual page.
 *
 * @package    PHPUnit_ExampleSolver
 * @author     Jeff Welch <whatthejeff@gmail.com>
 * @copyright  2011 Sebastian Bergmann <sb@sebastian-bergmann.de>
 * @license    http://www.opensource.org/licenses/bsd-license.php  BSD License
 * @version    Release: @package_version@
 * @link       http://www.phpunit.de/
 */
class PHPUnit_ExampleSolver_Manual_Page
{
    /**
     * Path to the manual page.
     *
     * @var string
     */
    protected $file;

    /**
     * Dom for the manual page.
     *
     * @var DOMDocument
     */
    protected $page;

    /**
     * Examples in the manual page.
     *
     * @var array
     */
    protected $examples = array();

    /**
     * Loads a manual page from a file.
     *
     * @param  string $file Path to the manual page.
     * @throws RuntimeException
     */
    public function __construct($file)
    {
        $this->file = $file;
        $this->page = PHPUnit_Util_XML::loadFile($file);

        $xpath = new DOMXPath($this->page);
        $listings = $xpath->query('//example/programlisting');

        foreach ($listings as $listing) {

            $input = $xpath->query(
              'following-sibling::screen[1]/userinput[1]', $listing
            )->item(0);

            if ($input) {
                $this->examples[] = new PHPUnit_ExampleSolver_Manual_Example(
                  $this->page, $listing, $input->parentNode, $input
                );
            }
        }
    }

    /**
     * Checks if the manual page has examples.
     *
     * @return boolean
     */
    public function hasExamples()
    {
        return (bool) $this->examples;
    }

    /**
     * Solves all examples from the manual page.
     */
    public function solveExamples()
    {
        foreach ($this->examples as $example) {
            $example->solve();
        }
    }

    /**
     * Save the manual page.
     *
     * @param  string $file Optional path where file will be saved.
     * @throws InvalidArgumentException
     */
    public function save($file = null)
    {
        if (!$file) {
            $file = $this->file;
        }

        $xml = str_replace(
          array(
            '"/>',
            ".\n]]>",
            ".\n</screen>",
            ")\n</screen>",
            '<?xml version="1.0" encoding="utf-8"?>'
          ),
          array(
            '" />',
            '.]]>',
            '.</screen>',
            ')</screen>',
            '<?xml version="1.0" encoding="utf-8" ?>' . "\n"
          ),
          $this->page->saveXML()
        );

        if (@file_put_contents($file, $xml) === false) {
            throw new RuntimeException(
              sprintf('Could not write to "%s".', $file)
            );
        }
    }
}