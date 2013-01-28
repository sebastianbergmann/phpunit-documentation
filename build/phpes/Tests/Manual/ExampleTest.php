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
 * PHPUnit manual example test.
 *
 * @package    PHPUnit_ExampleSolver
 * @author     Jeff Welch <whatthejeff@gmail.com>
 * @copyright  2011 Sebastian Bergmann <sb@sebastian-bergmann.de>
 * @license    http://www.opensource.org/licenses/bsd-license.php  BSD License
 * @version    Release: @package_version@
 * @link       http://www.phpunit.de/
 */
class Manual_ExampleTest extends PHPUnit_Framework_TestCase
{
    protected function setUp()
    {
        $this->dom = new DomDocument();
        $this->dom->loadXML(
          file_get_contents(PHPES_FIXTURES_PATH . '/helloworld.xml')
        );
        $this->xpath = new DomXPATH($this->dom);
    }

    /**
     * @covers PHPUnit_ExampleSolver_Manual_Example
     */
    public function testSolveWithoutCDATA()
    {
        $example = $this->xpath->query('//example[1]')->item(0);

        $manualExample = $this->getManualExample($example);
        $manualExample->solve();

        $this->assertEquals(
          <<<EOF
<example id="helloworld.php">
    <title>Hello World</title>
    <programlisting><![CDATA[<?php
echo 'hello world';
?>]]></programlisting>

    <screen><userinput>php helloworld.php</userinput>
hello world</screen>
  </example>
EOF
          ,
          $this->dom->saveXML($example)
        );
    }

    /**
     * @covers PHPUnit_ExampleSolver_Manual_Example
     */
    public function testSolveWithCDATA()
    {
        $example = $this->xpath->query('//example[2]')->item(0);

        $manualExample = $this->getManualExample($example);
        $manualExample->solve();

        $this->assertEquals(
          <<<EOF
<example id="helloworld2.php">
    <title>Hello World 2</title>
    <programlisting><![CDATA[<?php
echo '<h1>hello world</h1>';
?>]]></programlisting>

    <screen><userinput>php helloworld2.php</userinput><![CDATA[
<h1>hello world</h1>]]></screen>
  </example>
EOF
          ,
          $this->dom->saveXML($example)
        );
    }

    /**
     * Gets an instance of PHPUnit_ExampleSolver_Manual_Example given an
     * `<example> DOMNode`.
     *
     * @param  DOMNode $example The `<example> DOMNode`.
     * @return PHPUnit_ExampleSolver_Manual_Example
     */
    protected function getManualExample($example)
    {
        $listing = $this->xpath->query('programlisting[1]', $example)->item(0);
        $input = $this->xpath->query(
          'screen[1]/userinput[1]', $example
        )->item(0);

        return new PHPUnit_ExampleSolver_Manual_Example(
          $this->dom, $listing, $input->parentNode, $input
        );
    }
}