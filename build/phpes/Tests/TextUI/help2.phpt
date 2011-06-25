--TEST--
phpes --help
--FILE--
<?php
$_SERVER['argv'][1] = '--help';

require_once dirname(dirname(dirname(__FILE__))) . '/PHPUnit_ExampleSolver/Autoload.php';
PHPUnit_ExampleSolver_TextUI_Command::main();
?>
--EXPECTF--
Usage: phpes filename ...

  -h|--help                 Prints this usage information.
