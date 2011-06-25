--TEST--
phpes ../../_files/DoesNotExist.xml
--FILE--
<?php
$_SERVER['argv'][1] = dirname(dirname(__FILE__)) . '/_files/DoesNotExist.xml';

require_once dirname(dirname(dirname(__FILE__))) . '/PHPUnit_ExampleSolver/Autoload.php';
PHPUnit_ExampleSolver_TextUI_Command::main();
?>
--EXPECTF--
Could not read "%s/_files/DoesNotExist.xml".
