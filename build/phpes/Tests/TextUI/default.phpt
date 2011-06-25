--TEST--
phpes ../../_files/helloworld.xml
--FILE--
<?php
$helloworld = dirname(dirname(__FILE__)) . '/_files/helloworld.xml';
$_SERVER['argv'][1] = $helloworld;

require_once dirname(dirname(dirname(__FILE__))) . '/PHPUnit_ExampleSolver/Autoload.php';
PHPUnit_ExampleSolver_TextUI_Command::main(FALSE);

echo file_get_contents($helloworld);
?>
--EXPECTF--
<?xml version="1.0" encoding="utf-8" ?>

<chapter id="helloworld">
  <title>Hello World</title>

  <example id="helloworld.php">
    <title>Hello World</title>
    <programlisting><![CDATA[<?php
echo 'hello world';
?>]]></programlisting>

    <screen><userinput>php helloworld.php</userinput>
hello world</screen>
  </example>

  <example id="helloworld2.php">
    <title>Hello World 2</title>
    <programlisting><![CDATA[<?php
echo '<h1>hello world</h1>';
?>]]></programlisting>

    <screen><userinput>php helloworld2.php</userinput><![CDATA[
<h1>hello world</h1>]]></screen>
  </example>
</chapter>
