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
 * @package    PHPUnit_ExampleSolver
 * @author     Jeff Welch <whatthejeff@gmail.com>
 * @copyright  2011 Sebastian Bergmann <sb@sebastian-bergmann.de>
 * @license    http://www.opensource.org/licenses/bsd-license.php  BSD License
 * @version    Release: @package_version@
 * @link       http://www.phpunit.de/
 */
class PHPUnit_ExampleSolver_TextUI_Command
{
    const SUCCESS_EXIT   = 0;
    const FAILURE_EXIT   = 1;

    /**
     * Command line options.
     *
     * @var array
     */
    protected $options = array();

    /**
     * List of allowed long options.
     *
     * @var array
     */
    protected $longOptions = array(
      'help' => NULL
    );

    /**
     * PHPUnit Example Solver entry point.
     *
     * @param boolean $exit If this should exit after running.
     */
    public static function main($exit = TRUE)
    {
        $command = new self;
        $command->run($_SERVER['argv'], $exit);
    }

    /**
     * Exits with an error message.
     *
     * @param string $message The error message.
     */
    public static function showError($message)
    {
        print $message . "\n";
        exit(self::FAILURE_EXIT);
    }

    /**
     * Process the command line arguments.
     *
     * @param array   $argv Command line arguments.
     * @param boolean $exit If this should exit after running.
     */
    public function run(array $argv, $exit = TRUE)
    {
        try {
            $this->options = PHPUnit_Util_Getopt::getopt(
              $argv, 'h', array_keys($this->longOptions)
            );
        }

        catch (RuntimeException $e) {
            self::showError($e->getMessage());
        }

        foreach ($this->options[0] as $option) {
            switch ($option[0]) {
                case 'h':
                case '--help': {
                    $this->showHelp();
                    exit(self::SUCCESS_EXIT);
                }
                break;
            }
        }

        if (!$this->options[1]) {
            $this->showHelp();
            exit(self::FAILURE_EXIT);
        }

        foreach ($this->options[1] as $page) {
            try {
                $this->page = new PHPUnit_ExampleSolver_Manual_Page($page);
                if ($this->page->hasExamples()) {
                    $this->page->solveExamples();
                    $this->page->save();
                }
            } catch (Exception $e) {
                print $e->getMessage() . "\n";
                exit(self::FAILURE_EXIT);
            }
        }

        if ($exit) {
            exit(self::SUCCESS_EXIT);
        }
    }

    /**
     * Show the help message.
     */
    protected function showHelp()
    {
        print <<<EOT
Usage: phpes filename ...

  -h|--help                 Prints this usage information.

EOT;
    }

}