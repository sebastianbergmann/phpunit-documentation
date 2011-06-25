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
 * PHPUnit manual page test.
 *
 * @package    PHPUnit_ExampleSolver
 * @author     Jeff Welch <whatthejeff@gmail.com>
 * @copyright  2011 Sebastian Bergmann <sb@sebastian-bergmann.de>
 * @license    http://www.opensource.org/licenses/bsd-license.php  BSD License
 * @version    Release: @package_version@
 * @link       http://www.phpunit.de/
 */
class Manual_PageTest extends PHPUnit_Framework_TestCase
{
    /**
     * @covers PHPUnit_ExampleSolver_Manual_Page::__construct
     */
    public function testPageWithBadPath()
    {
        $this->setExpectedException('RuntimeException', 'Could not read');
        $page = new PHPUnit_ExampleSolver_Manual_Page(
          PHPES_FIXTURES_PATH . '/DoesNotExist.xml'
        );
    }

    /**
     * @covers PHPUnit_ExampleSolver_Manual_Page::__construct
     */
    public function testPageWithBadXML()
    {
        $this->setExpectedException('RuntimeException', 'Premature end');
        $page = new PHPUnit_ExampleSolver_Manual_Page(
          PHPES_FIXTURES_PATH . '/bad.xml'
        );
    }

    /**
     * @covers PHPUnit_ExampleSolver_Manual_Page::__construct
     * @covers PHPUnit_ExampleSolver_Manual_Page::hasExamples
     */
    public function testPageWithNoExamples()
    {
        $page = new PHPUnit_ExampleSolver_Manual_Page(
          PHPES_FIXTURES_PATH . '/noexamples.xml'
        );
        $this->assertFalse($page->hasExamples());
    }

    /**
     * @covers PHPUnit_ExampleSolver_Manual_Page::__construct
     * @covers PHPUnit_ExampleSolver_Manual_Page::hasExamples
     */
    public function testPageWithExamples()
    {
        $page = new PHPUnit_ExampleSolver_Manual_Page(
          PHPES_FIXTURES_PATH . '/helloworld.xml'
        );
        $this->assertTrue($page->hasExamples());
    }

    /**
     * @covers PHPUnit_ExampleSolver_Manual_Page::solveExamples
     * @covers PHPUnit_ExampleSolver_Manual_Page::save
     */
    public function testSaveFile()
    {
        $expected = PHPES_FIXTURES_PATH . '/helloworld.xml';
        $actual = PHPES_FIXTURES_PATH . '/helloworld.updated.xml';

        $page = new PHPUnit_ExampleSolver_Manual_Page($expected);
        $page->solveExamples();
        $page->save($actual);

        $this->assertFileEquals($expected, $actual);
        unlink($actual);
    }
}