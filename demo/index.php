<html lang="ru">
<head>
    <title>Testing manticore search</title>
    <meta charset="utf-8" />
</head>
<body>

Результат:
<?php

/**
 * @see https://github.com/manticoresoftware/manticoresearch-php
 */

require_once __DIR__ . '/vendor/autoload.php';

$config = ['host'=>'manticore', 'port'=>9308];
$client = new \Manticoresearch\Client($config);
$table = $client->table('vacancy');

//$status = $table->status();
//var_dump($status);

$describe = $table->describe();
var_dump(array_keys($describe));

$results = $table->search("разработчик")->get();

foreach ($results as $key => $doc) {
    echo "#{$key} \n\r <br />";
    var_dump($doc);
}

?>

</body>
</html>

