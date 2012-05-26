#!/usr/bin/env php
<?php
require_once 'PHPUnit/Autoload.php';

if ($argc == 3) {
    $methods = array();

    $class = new ReflectionClass('PHPUnit_Framework_Assert');

    foreach ($class->getMethods() as $method) {
        $name = $method->getName();

        if (strpos($name, 'assert') === 0) {
            $methods[$name] = str_replace(
              array('= false', '= true'),
              array('= FALSE', '= TRUE'),
              PHPUnit_Util_Class::getMethodParameters($method)
            );
        }
    }

    ksort($methods);

    $rows = '';

    foreach ($methods as $methodName => $methodArguments) {
        $rows .= sprintf('
        <row>
          <indexterm><primary>%s()</primary></indexterm>
          <entry><literal>%s(%s)</literal></entry>
        </row>',
          $methodName,
          $methodName,
          $methodArguments
        );
    }

    $template = new Text_Template($argv[1]);
    $template->setVar(array('rows' => $rows));
    $template->renderTo($argv[2]);
}
