<?php

//full.php?docid=443300&title="AlphaGo 九段"

	$docid = $_GET["docid"];

	//$url = "http://c.m.163.com/nc/article/CLFDO0DK05118DFD/full.html";
	$url = "http://c.m.163.com/nc/article/".$docid."/full.html";

	$ch = curl_init($url) ;
	curl_setopt($ch, CURLOPT_RETURNTRANSFER, true) ; // 获取数据返回
	curl_setopt($ch, CURLOPT_BINARYTRANSFER, true) ; // 在启用 CURLOPT_RETURNTRANSFER 时候将获取数据返回
	$output = curl_exec($ch);


	$output = json_decode($output, true);
	$output = $output["$tid"];
?>

<html>
<head>
<title>
	<?php
    $title = $_GET["title"];
		echo "{$title}";
	 ?>
</title>
<meta charset="utf-8">
    <link href="http://120.55.163.83/download/app/rss/favicon.ico" rel="GEEK ICON">
	<meta name="viewport" content="width=device-width, initial-scale=1.0, minimum-scale=1.0, maximum-scale=1.0, user-scalable=no">
	<meta name="format-detection" content="telephone=no">
</head>

<body bgcolor="white" text="black">

<?php

//body
//img
$bodyString=$output['body'];
$imgList=$output['img'];

echo $output
echo $bodyString
echo $imgList

foreach ($imgList as $key=>$val)
{

echo "key=$val    val=$$val";
/*
	$imgBaseURL="http://img2.cache.netease.com/m/newsapp/topic_icons/";
	$imgurl = $imgBaseURL.$_GET["tid"].".png";

	$img_src=$val['imgsrc'];

	$retVal = (empty($img_src) ) ? $imgurl : $img_src;

	echo "<li>
		<a class='pic' href='{$val['url']}' style='background-image: url({$retVal}); '></a>

		<h3><a href='{$val['url']}' target='_blank'>{$val['title']}</a></h3>
		<div class='summary clearfix'>{$val["digest"]}</div>
		<br>
		<div class='summary clearfix'>{$val["ptime"]}</div>
	</li>";
  */
}
?>

</body>
</html>
