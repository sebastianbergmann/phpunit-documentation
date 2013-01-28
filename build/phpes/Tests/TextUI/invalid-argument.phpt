--TEST--
phpes --invalid
--FILE--
<?php
$_SERVER['argv'][1] = '--invalid';

require_once dirname(dirname(dirname(__FILE__))) . '/PHPUnit_ExampleSolver/Autoload.php';
PHPUnit_ExampleSolver_TextUI_Command::main();
?>
--EXPECTF--
unrecognized option --invalid
