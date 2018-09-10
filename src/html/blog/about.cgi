#!/usr/bin/perl

use strict;
use warnings;
use utf8;
binmode STDOUT, ':utf8';
#use Time::Local;

#use utf8;
#use Encode qw(decode_utf8 encode_utf8);
# perlの文字化け問題、まじで謎...
# こういう論理的な知識を体系的に身に付けるには、ラクダ本読まないとダメなのかな...？
# http://tech.voyagegroup.com/archives/465806.html


my $DIR = "../";
my $BLOG_DIR = "./";
my $PAGE = "blog/about.cgi";

my $PL_DIR = $DIR.'../etc/pl/';
require $PL_DIR.'RecordAccessLog.pl';
require $PL_DIR.'blog/GetDatabase.pl';
require $PL_DIR.'blog/GetSetting.pl';
require $PL_DIR.'blog/menubar.pl';
require $PL_DIR.'blog/sideMenu.pl';

my $ACCESS_LOG = &sub::RecordAccessLog($PAGE);
# my @ArticleLists = &sub::blog::GetDatabase();
# my %SETTING = &sub::blog::GetSetting();

my ($articleLists, $id2idx) = &sub::blog::GetDatabase();
my @ArticleLists = @{$articleLists};
my %ID2IDX = %{$id2idx};
my %SETTING = &sub::blog::GetSetting();


print "content-type: text/html;charset=utf-8\n\n";

print <<'EOM';

<!DOCTYPE html>
<html lang="ja">
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
	<title>溶けかけてるうさぎ - BLOG - ABOUT</title>
	<meta name="format-detection" content="telephone=no">
	<meta NAME="ROBOTS" CONTENT="NOINDEX,NOFOLLOW,NOARCHIVE">
	<!--
	レスポンシブデザインなどに必要なviewport設定
	http://qiita.com/ryounagaoka/items/045b2808a5ed43f96607
	http://ichimaruni-design.com/2015/01/viewport/
	-->
	<!--<meta name="viewport" content="width=device-width,initial-scale=1.0,minimum-scale=1.0">-->
	<meta name="viewport" content="width=device-width,user-scalable=yes">

	<meta name="twitter:card" content="summary">
	<meta name="twitter:site" content="@_meltingrabbit">
	<meta name="twitter:creator" content="@_meltingrabbit">
	<meta name="twitter:title" content="溶けかけてるうさぎ - BLOG - ABOUT">
	<meta name="twitter:description" content="備忘録．内容は趣味だったり，旅行だったり．たまにアカデミックなことも．備忘録なので，日付はその話題が起きた日になっています．つまり，最新記事がトップに来るとは限りません．">
	<meta name="twitter:image" content="https://meltingrabbit.com/img/icon_WB.png">
	<meta property="og:title" content="溶けかけてるうさぎ - BLOG - ABOUT">
	<meta property="og:url" content="https://meltingrabbit.com/blog/about.cgi">
	<meta property="og:image" content="https://meltingrabbit.com/img/icon_WB.png">
	<meta property="og:site_name" content="溶けかけてるうさぎ - BLOG">
	<meta property="og:description" content="備忘録．内容は趣味だったり，旅行だったり．たまにアカデミックなことも．備忘録なので，日付はその話題が起きた日になっています．つまり，最新記事がトップに来るとは限りません．">

	<!--<link href="./css/style_article.css" type="text/css" rel="stylesheet">-->
	<!--<link href="./css/navi.css" type="text/css" rel="stylesheet">-->
EOM
	print '<link href="'.$DIR.'css/style_default.css?date=20180501" type="text/css" rel="stylesheet">', "\n";
	print '<link href="./css/style_blog.css?date=20180427" type="text/css" rel="stylesheet">', "\n";
	print '<link href="./css/style_blog_home.css?date=20180427" type="text/css" rel="stylesheet">', "\n";
	print '<link href="./css/style_blog_about.css?date=20180427" type="text/css" rel="stylesheet">', "\n";
	print '<link rel="shortcut icon" href="'.$DIR.'img/favicon.ico" type="image/vnd.microsoft.icon">', "\n";
	print '<script type="text/javascript" src="'.$DIR.'js/jquery-1.11.2.min.js"></script>', "\n";
	print '<script type="text/javascript" src="./js/script_fitting.js"></script>', "\n";
	# print '<script type="text/javascript" src="'.$DIR.'js/script_home.js"></script>', "\n";
print <<'EOM';


	<!-- ページ内移動をスムーズに -->
	<script type="text/javascript">
	$(function(){
		$('a[href^=#]').click(function(){
			var speed = 300;
			var href= $(this).attr("href");
			var target = $(href == "#" || href == "" ? 'html' : href);
			var position = target.offset().top;
			$("html, body").animate({scrollTop:position}, speed, "swing");
			return false;
		});
	});
	</script>

<script>
  (function(i,s,o,g,r,a,m){i['GoogleAnalyticsObject']=r;i[r]=i[r]||function(){
  (i[r].q=i[r].q||[]).push(arguments)},i[r].l=1*new Date();a=s.createElement(o),
  m=s.getElementsByTagName(o)[0];a.async=1;a.src=g;m.parentNode.insertBefore(a,m)
  })(window,document,'script','https://www.google-analytics.com/analytics.js','ga');

  ga('create', 'UA-96430472-1', 'auto');
  ga('send', 'pageview');

</script>

</head>

<body>

<noscript>
<div>
<p>お使いのブラウザのJavaScriptが無効となっています．<br>
有効にしてからページを再読み込みしてください．</p>
</div>
</noscript>

EOM

	&sub::blog::menubar($BLOG_DIR);

print <<'EOM';
<div id="container" class="clearfix w960 PC">

EOM

	&sub::blog::sideMenu(\@ArticleLists, \%SETTING, $BLOG_DIR);

print <<'EOM';


<div id="contents" class="right">
	<h2>ABOUT THIS BLOG</h2>
	<div class="panel">
		<p>備忘録．内容は趣味だったり，旅行だったり．</p>
		<p>たまにアカデミックなことも．</p>
		<p>&nbsp;</p>
		<p>どんな記事があるかは，<a href="./?t=popular">POPULAR ARTICLES</a> を見ていただければなんとなくわかると思います．</p>
		<p>&nbsp;</p>
		<p>なお，備忘録なので，日付はその話題が起きた日になっています．つまり，最新記事がトップに来るとは限りません．</p>
		<p>&nbsp;</p>
		<p>&nbsp;</p>
		<p>管理人については，<a href="/#about">こちら</a>を．</p>
	</div>
</div>

<footer>
<p>Copyright&copy;&nbsp;&nbsp; <a href="/">溶けかけてるうさぎ MeltingRabbit</a>&nbsp;&nbsp; All Rights Reserved.</p>
</footer>


</div>
</body>
</html>

EOM



exit;

