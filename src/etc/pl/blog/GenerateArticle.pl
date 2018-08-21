
use utf8;
package sub::blog;
sub GenerateArticle {
	my $id           = $_[0];
	my $article      = ${$_[1]};
	my @Comment      = @{$_[2]};
	my @RelatedPosts = @{$_[3]};

	my $DIR = '../../../';		# サイト全体におけるこのページのの階層
	my $BLOG_DIR = '../../';	# サイト全体におけるブログの階層

	my $PL_DIR = $DIR.'../etc/pl/';
	require $PL_DIR.'blog/GetDatabase.pl';
	require $PL_DIR.'blog/GetSetting.pl';
	require $PL_DIR.'blog/menubar.pl';
	require $PL_DIR.'blog/sideMenu.pl';
	require $PL_DIR.'EscapeHtml.pl';



	my ($articleLists, $id2idx) = &sub::blog::GetDatabase();
	my @ArticleLists = @{$articleLists};
	my %ID2IDX = %{$id2idx};
	my %SETTING = &sub::blog::GetSetting();

	# 存在しない記事
	if (!exists($ID2IDX{$id})) {
		# exit(1);

		&sub::GenerateArticle::GenerateInvalidArticleHeader($DIR, $BLOG_DIR);
		&sub::blog::sideMenu(\@ArticleLists, \%SETTING, $BLOG_DIR);
		&sub::GenerateArticle::GenerateInvalidArticleBody();
		exit;
	}

	my $title = $ArticleLists[$ID2IDX{$id}]{'title'}               ;
	my $year  = $ArticleLists[$ID2IDX{$id}]{'year'}                ;
	my $month = $ArticleLists[$ID2IDX{$id}]{'month'}               ;
	my $day   = $ArticleLists[$ID2IDX{$id}]{'day'}                 ;
	my $isMR  = $ArticleLists[$ID2IDX{$id}]{'metaRobots'}          ;
	my $url   = $SETTING{'HOST_URL'}.'blog/article/'.$id.'/';
	my $desc  = $ArticleLists[$ID2IDX{$id}]{'text'}                ;

	$desc = &sub::EscapeHtml($desc);


print "content-type: text/html;charset=utf-8\n\n";

print <<'EOM';

<!DOCTYPE html>
<html lang="ja">
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
EOM
	print '	<title>'.$title.' - 溶けかけてるうさぎ - BLOG</title>', "\n";
print <<'EOM';
	<meta name="format-detection" content="telephone=no">
EOM
if ($isMR == 1) {
	print '	<meta NAME="ROBOTS" CONTENT="INDEX,FOLLOW,NOARCHIVE">', "\n";
	# print '<meta NAME="ROBOTS" CONTENT="INDEX,NOFOLLOW,NOARCHIVE">', "\n";
} else {
	print '	<meta NAME="ROBOTS" CONTENT="NOINDEX,FOLLOW,NOARCHIVE">', "\n";
	# print '<meta NAME="ROBOTS" CONTENT="NOINDEX,NOFOLLOW,NOARCHIVE">', "\n";
}
print <<'EOM';
	<!--
	レスポンシブデザインなどに必要なviewport設定
	http://qiita.com/ryounagaoka/items/045b2808a5ed43f96607
	http://ichimaruni-design.com/2015/01/viewport/
	-->
	<!--<meta name="viewport" content="width=device-width,initial-scale=1.0,minimum-scale=1.0">-->
	<meta name="viewport" content="width=device-width,user-scalable=yes">
EOM
	print '	<meta name="twitter:card" content="summary">', "\n";
	# print '	<meta name="twitter:card" content="summary_large_image">', "\n";
	print '	<meta name="twitter:site" content="@_meltingrabbit">', "\n";
	print '	<meta name="twitter:creator" content="@_meltingrabbit">', "\n";
	print '	<meta name="twitter:title" content="'.$title.'">', "\n";
	# print '	<meta name="twitter:description" content="'.$desc.'...">', "\n";
	print '	<meta name="twitter:description" content="'.$desc.'">', "\n";
	print '	<meta name="twitter:image" content="'.$url.'top.jpg">', "\n";
	print '	<meta property="og:title" content="'.$title.'">', "\n";
	print '	<meta property="og:url" content="'.$url.'">', "\n";
	print '	<meta property="og:image" content="'.$url.'top.jpg">', "\n";
	print '	<meta property="og:site_name" content="溶けかけてるうさぎ - BLOG">', "\n";
	# print '	<meta property="og:description" content="'.$desc.'...">', "\n";
	print '	<meta property="og:description" content="'.$desc.'">', "\n";
	# <meta name="twitter:card" content="summary_large_image">
	# <meta name="twitter:site" content="@nytimes">
	# <meta name="twitter:creator" content="@SarahMaslinNir">
	# <meta name="twitter:title" content="Parade of Fans for Houston’s Funeral">
	# <meta name="twitter:description" content="NEWARK - The guest list and parade of limousines with celebrities emerging from them seemed more suited to a red carpet event in Hollywood or New York than than a gritty stretch of Sussex Avenue near the former site of the James M. Baxter Terrace public housing project here.">
	# <meta name="twitter:image" content="http://graphics8.nytimes.com/images/2012/02/19/us/19whitney-span/19whitney-span-articleLarge.jpg">
	# <meta property="og:title" content="ページタイトル">
	# <meta property="og:url" content="このページのURL(パラメータ除外)">
	# <meta property="og:image" content="サムネイル画像のURL">
	# <meta property="og:site_name" content="サイト名">
	# <meta property="og:description" content="ページの説明">
print <<'EOM';
	<!--<link href="./css/style_article.css" type="text/css" rel="stylesheet">-->
	<!--<link href="./css/navi.css" type="text/css" rel="stylesheet">-->
EOM
	print '	<link href="'.$DIR.'css/style_default.css?date=20180821" type="text/css" rel="stylesheet">', "\n";
	print '	<link href="../../css/style_blog.css?date=20180602" type="text/css" rel="stylesheet">', "\n";
	print '	<link href="../../css/style_blog_article.css?date=20180821" type="text/css" rel="stylesheet">', "\n";
	print '	<link href="./style.css" type="text/css" rel="stylesheet">', "\n";
	print '	<link rel="shortcut icon" href="'.$DIR.'img/favicon.ico" type="image/vnd.microsoft.icon">', "\n";
	print '	<script type="text/javascript" src="'.$DIR.'js/jquery-1.11.2.min.js"></script>', "\n";
	# print '	<script type="text/javascript" src="'.$DIR.'js/jquery-3.2.0.min.js"></script>', "\n";
	print '	<script type="text/javascript" src="../../js/script_fitting.js?date=20180602"></script>', "\n";
	print '	<script type="text/javascript" src="../../js/script_article.js?date=20180702"></script>', "\n";
	print '	<script type="text/javascript" src="../../js/script_toggle.js"></script>', "\n";
print <<'EOM';


	<!-- ページ内移動をスムーズに -->
	<script type="text/javascript">
	$(function(){
		$('a[href^=#]').click(function(){
			var speed = 300;
			var href= $(this).attr("href");
			var target = $(href == "#" || href == "" ? 'html' : href);
			var position = target.offset().top - 20;
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

	&sub::blog::sideMenu(\@ArticleLists, \%SETTING, $BLOG_DIR, 1);

print <<'EOM';


<div id="contents" class="right">

	<div id="headline">
		<img src="./top.jpg">
		<ul>
EOM
	# ulの要素に改行挟むとレイアウトが崩れる．
	foreach (@{$ArticleLists[$ID2IDX{$id}]{'category'}}) {
		# print '			<a href="'.$BLOG_DIR.'?c=category&t='.$_.'"><li>'.$SETTING{'category'}{$_}.'</li></a>', "\n";		# liは改行挟むとレイアウト死ぬ
		print '<a href="'.$BLOG_DIR.'?li&c=category&t='.$_.'"><li>'.$SETTING{'category'}{$_}.'</li></a>';			# 2018/02/06 liを付加することにより，ログで何処から飛んだかわかる
	}
	foreach (@{$ArticleLists[$ID2IDX{$id}]{'tag'}}) {
		# print '			<a href="'.$BLOG_DIR.'?c=tag&t='.$_.'"><li class="tag">'.$SETTING{'tag'}{$_}.'</li></a>', "\n";		# liは改行挟むとレイアウト死ぬ
		print '<a href="'.$BLOG_DIR.'?li&c=tag&t='.$_.'"><li class="tag">'.$SETTING{'tag'}{$_}.'</li></a>';			# 2018/02/06 liを付加することにより，ログで何処から飛んだかわかる
	}
# print <<'EOM';
# 		</ul>
# EOM
print <<'EOM';
</ul>
EOM
	# print '		<p class="title">'.$title.'</p>', "\n";
	print '		<h1 class="title">'.$title.'</h1>', "\n";
print <<'EOM';
		<div class="clearfix date">
EOM
	print '		<p class="right">'.$year.'-'.$month.'-'.$day.'</p>', "\n";
print <<'EOM';
		</div>
	</div>

EOM
	print $article;
	# print encode('utf-8', $article);
	# print utf8::is_utf8($article) ? 'flagged' : 'no flag';
	# Wide character in print at エラーが出るねぇ．（実効には問題がないのだが，Apacheのerrorログが出まくる．）

	# print $#Comment;
	# コメント
	if ($#Comment >= 0) {
	# if (0) {
		print '	<div id="commentDisp">', "\n";
		print '		<h3>コメント</h3>', "\n";
		for (my $i=0; $i<=$#Comment; $i++) {
			print '		<p class="comment-disp-h4"><span class="comment-disp-name">'.$Comment[$i]->{'name'}.'</span> &nbsp;&nbsp;['.$Comment[$i]->{'date'}.']</p>', "\n";
			foreach(@{$Comment[$i]->{'text'}}) {
				print '		<p class="comment-disp-text">'.$_.'</p>', "\n";
			}
			foreach(@{$Comment[$i]->{'img'}}) {
				print '		<img src="./comment/'.$_->{'filename'}.'" style="width:'.$_->{'width'}.'px;">', "\n";
			}
			last if ($i == $#Comment);
			print '		<p class="comment-disp-bar">&nbsp;</p>', "\n";
		}
		print '	</div>', "\n";
	}

print <<'EOM';

	<div id="comment">
		<h3>コメントを投稿</h3>
		<p>名前</p>
		<input name="name" class="comment-name">
		<p>Email <span class="note">(※公開されることはありません)<span></p>
		<input name="email" class="comment-email">
		<p>コメント</p>
		<textarea name="comment"></textarea>
		<!-- <div id="form" class="button">コメントを送信</div> -->
		<button type="button" id="form" class="button">コメントを送信</button>
	</div>

</div>

<footer>
<p>Copyright&copy;&nbsp;&nbsp; <a href="/">溶けかけてるうさぎ MeltingRabbit</a>&nbsp;&nbsp; All Rights Reserved.</p>
</footer>

</div>



<script>
$(function() {


	// 関連記事リンク生成
EOM
print <<'EOM';
	var relatedPostsId    = [];
	var relatedPostsUrl   = [];
	var relatedPostsTitle = [];
EOM
	foreach (@RelatedPosts) {
		print "	relatedPostsId.push(".$_.");" ,"\n";
		print "	relatedPostsUrl.push('/blog/article/".$_."/');" ,"\n";
		if (exists($ID2IDX{$_})) {
			print "	relatedPostsTitle.push('".$ArticleLists[$ID2IDX{$_}]{'title'}." [".$ArticleLists[$ID2IDX{$_}]{'year'}.'-'.$ArticleLists[$ID2IDX{$_}]{'month'}.'-'.$ArticleLists[$ID2IDX{$_}]{'day'}."]');" ,"\n";
		} else {
			print "	relatedPostsTitle.push('現在無効な記事');" ,"\n";
		}
	}
print <<'EOM';
	// console.log(relatedPostsId);
	// console.log(relatedPostsUrl);
	// console.log(relatedPostsTitle);
	if (relatedPostsId.length != 0) {
		$('table#relatedPosts').each(function(i) {
			$(this).find('tr').each(function(j) {
				$(this).children('td:last-child').html('<a href="' + relatedPostsUrl[j] + '" target="_blank">' + relatedPostsTitle[j] + '</a>');
			});
		});
	}

	// 記事内別記事リンク生成
	// class : link-other-article
	var articleTitles = {
EOM
	foreach (@RelatedPosts) {
		if (exists($ID2IDX{$_})) {
			print "		'".$_."' : '".$ArticleLists[$ID2IDX{$_}]{'title'}."',", "\n";
		} else {
			print "		'".$_."' : '現在無効な記事',", "\n";
		}
	}
print <<'EOM';
	}
	$('.link-other-article').each(function(i) {
		var id = $(this).attr("data-id");
		// console.log(articleTitles[id]);
		$(this).text(articleTitles[id]);
		$(this).attr("href", "/blog/article/" + id + "/");
	});



	// 以下，コメント処理

	$(document).ajaxError(function(e, xhr, opts, error) {
		alert('サーバー内部のエラーでコメントが送信できませんでした．');
		// alert('AjaxError：' + error+', '+e+', '+xhr+', '+opts);
	});

	$('#form').on('click', function() {

		if ($('input.comment-email').val() == '') {
			alert('Emailが未入力です．');
			return false;
		}
		if ( !($('input.comment-email').val().match(/.+@.+\..+/)) ) {
			alert('Emailが不正です．');
			return false;
		}
		if ($('input.comment-name').val() == '') {
			alert('名前が未入力です．');
			return false;
		}
		if ($('textarea').val() == '') {
			alert('コメントが未入力です．');
			return false;
		}

		$.post('../../cgi/output_comment.cgi',
			{
EOM
	print "				no : '".$id."'," ,"\n";
print <<'EOM';
				name : $('input.comment-name').val(),
				mail : $('input.comment-email').val(),
				cmnt : $('textarea').val()
				/*name : "hoge",
				cmnt : "fuga"*/
			},
			function(data) {
				// alert(data);
				if (data == 1) {
					alert('コメントの送信が完了しました．\n管理者の承認後に反映されます．');
				} else {
					alert('サーバー内部のエラーでコメントが送信できませんでした．');
				}
				return false;
			}
		);
	});

});
</script>


</body>
</html>

EOM



exit;

}



package sub::GenerateArticle;

sub GenerateInvalidArticleHeader {
	my $DIR = $_[0];
	my $BLOG_DIR = $_[1];

print "content-type: text/html;charset=utf-8\n\n";

print <<'EOM';

<!DOCTYPE html>
<html lang="ja">
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
	<title>溶けかけてるうさぎ - BLOG</title>
	<meta name="format-detection" content="telephone=no">
	<meta NAME="ROBOTS" CONTENT="NOINDEX,NOFOLLOW,NOARCHIVE">
	<!--
	レスポンシブデザインなどに必要なviewport設定
	http://qiita.com/ryounagaoka/items/045b2808a5ed43f96607
	http://ichimaruni-design.com/2015/01/viewport/
	-->
	<!--<meta name="viewport" content="width=device-width,initial-scale=1.0,minimum-scale=1.0">-->
	<meta name="viewport" content="width=device-width,user-scalable=yes">
	<!--<link href="./css/style_article.css" type="text/css" rel="stylesheet">-->
	<!--<link href="./css/navi.css" type="text/css" rel="stylesheet">-->
EOM
	print '<link href="'.$DIR.'css/style_default.css" type="text/css" rel="stylesheet">', "\n";
	print '<link href="../../css/style_blog.css" type="text/css" rel="stylesheet">', "\n";
	print '<link href="../../css/style_blog_home.css" type="text/css" rel="stylesheet">', "\n";
	print '<link rel="shortcut icon" href="'.$DIR.'img/favicon.ico" type="image/vnd.microsoft.icon">', "\n";
	print '<script type="text/javascript" src="'.$DIR.'js/jquery-1.11.2.min.js"></script>', "\n";
	print '<script type="text/javascript" src="../../js/script_fitting.js"></script>', "\n";
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
}


sub GenerateInvalidArticleBody {
print <<'EOM';

<div id="contents" class="right">
	<!-- <h2>ABOUT THIS BLOG</h2> -->
	<div class="panel">
		<p>現在無効化されている記事です．</p>
	</div>
</div>

<footer>
<p>Copyright&copy;&nbsp;&nbsp; <a href="/">溶けかけてるうさぎ MeltingRabbit</a>&nbsp;&nbsp; All Rights Reserved.</p>
</footer>


</div>
</body>
</html>

EOM
}




1;

