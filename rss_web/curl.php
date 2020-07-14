<?php
	//$url = "http://c.m.163.com/nc/article/list/T1374539835965/0-20.html";

	/*$ch = curl_init();
	curl_setopt($ch, CURLOPT_URL, $url);
	curl_setopt($ch, CURLOPT_RETURNTRANSFER, 1);
	curl_setopt($ch, CURLOPT_HEADER, 0);
	$output = curl_exec($ch);
	curl_close($ch);*/

	/*
	 * 访问路径：http://127.0.0.1/test/curl.php?tid=T1374539835965&num=0&size=20
	 * */

	$tid = $_GET["tid"];
	$num = $_GET["num"];
	$size = $_GET["size"];
	//$url = "http://c.m.163.com/nc/article/list/T1374539835965/0-20.html";
	$url = "http://c.m.163.com/nc/article/list/".$tid."/$num-$size.html";

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

<style media="screen">
.flow li {
    border-bottom: 1px dotted #000;
    display: block;
    margin-bottom: 13px;
    padding-bottom: 13px;
}
.summary {
    color: #666;
    margin-bottom: 5px;
}
.pic{
	float: left;
	margin-right: 20px;
	width: 100px;
	height: 100px;
	background: no-repeat center center;
	background-size: cover;
}
</style>

<body bgcolor="white" text="black">

<<?php

$title = $_GET["title"];
$imgBaseURL="http://img2.cache.netease.com/m/newsapp/topic_icons/";
$imgurl = $imgBaseURL.$_GET["tid"].".png";

echo "<h1><center>

        <p><img src='{$imgurl}' width='120' height='120' border='1'> </p>
				<p>{$title}</p>
				<br>
      </center></h1>";
	 ?>

<div class="center">
<div class="box flow">
<ul>
<?php
foreach ($output as $key=>$val)
{
	//http://c.m.163.com/nc/article/AFPBLKP000964K8U/full.html
	//$txtURL = "http://c.m.163.com/nc/article/".$tid."/$num-$size.html";

	$imgBaseURL="http://img2.cache.netease.com/m/newsapp/topic_icons/";
	$imgurl = $imgBaseURL.$_GET["tid"].".png";

	$img_src=$val['imgsrc'];

	$retVal = (empty($img_src) ) ? $imgurl : $img_src;

//访问内部.
  $gotoUrl=dirname(__FILE__).'/full.php';
	echo "<li>
		<a class='pic' href='{$val['url']}' style='background-image: url({$retVal}); '></a>

		<h3><a href='$gotoUrl' target='_blank'>{$val['title']}</a></h3>
		<div class='summary clearfix'>{$val["digest"]}</div>
		<br>
		<div class='summary clearfix'>{$val["ptime"]}</div>
	</li>";
}
?>

</ul>
<div align="center"><a class="more" onclick="window.scrollTo(0,0);"
<?php
$tid = $_GET["tid"];
$num = $_GET["num"]+$_GET["size"];
$size = $_GET["size"];
$title = $_GET["title"];
$clURL = $_SERVER['PHP_SELF']."?tid=".$tid."&num=".$num."&size=".$size."&title=".$title;
echo "href='{$clURL}'";
 ?>
	>查看更多</a>
</div>
</div>
</div>
</body>
</html>
