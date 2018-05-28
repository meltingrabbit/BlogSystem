#########################
# 未完工なタスク
#
# ?t=の値が不正だった場合の処理


use utf8;
package sub::blog;
sub GenerateList {
	my $class  = $_[0];		# class none/archive/category/tag
	my $target = $_[1];		# タグ，カテゴリ等
	my $page   = $_[2];		# 生成するページ

	my $DIR = "../";		# サイト全体におけるこのページの階層
	my $BLOG_DIR = "./";	# サイト全体におけるブログの階層
	$page = int($page);		# GET小数点対策

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

	# p.textの文字数を動的に変更するjavascriptへ渡すための配列
	my @Texts = ();


	########################################
	# 不正な引数を弾く
	########################################
	if ( !( ($class eq 'none') || ($class eq 'tag') || ($class eq 'category') || ($class eq 'archive') ) ) {
		print 'Location: ./', "\n\n";
		exit;
	}
	if ($class eq 'tag') {
		if (!(exists($SETTING{'tag'}{$target}))) {
			print 'Location: ./', "\n\n";
			exit;
		}
	}
	if ($class eq 'category') {
		if (!(exists($SETTING{'category'}{$target}))) {
			print 'Location: ./', "\n\n";
			exit;
		}
	}
	if ($class eq 'archive') {
		my $BEGIN_YEAR = $SETTING{'begin_year'};
		my $END_YEAR = $SETTING{'end_year'};
		my $flag = 0;
		for (my $i = $BEGIN_YEAR; $i <= $END_YEAR; $i++) {
			if ($target eq $i) {
				$flag = 1;
				last;
			}
		}
		if ($flag == 0) {
			print 'Location: ./', "\n\n";
			exit;
		}
	}


	########################################
	# ヘッダーの生成
	########################################

print "content-type: text/html;charset=utf-8\n\n";

print <<'EOM';

<!DOCTYPE html>
<html lang="ja">
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
EOM
	if ($class eq 'tag') {
		print '	<title>溶けかけてるうさぎ - BLOG - TAG '.$SETTING{'tag'}{$target}.'</title>', "\n";
	} elsif ($class eq 'category') {
		print '	<title>溶けかけてるうさぎ - BLOG - CATEGORY '.$SETTING{'category'}{$target}.'</title>', "\n";
	} elsif ($class eq 'archive') {
		print '	<title>溶けかけてるうさぎ - BLOG - ARCHIVE '.$target.'</title>', "\n";
	} else {
		print '	<title>溶けかけてるうさぎ - BLOG</title>', "\n";
	}
print <<'EOM';
	<meta name="format-detection" content="telephone=no">
EOM
	print '	<meta NAME="ROBOTS" CONTENT="NOINDEX,FOLLOW,NOARCHIVE">', "\n";
	# print '<meta NAME="ROBOTS" CONTENT="NOINDEX,NOFOLLOW,NOARCHIVE">', "\n";
print <<'EOM';
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
	print '	<link href="'.$DIR.'css/style_default.css?date=20180501" type="text/css" rel="stylesheet">', "\n";
	print '	<link href="./css/style_blog.css?date=20180427" type="text/css" rel="stylesheet">', "\n";
	print '	<link href="./css/style_blog_home.css?date=20180427" type="text/css" rel="stylesheet">', "\n";
	print '	<link rel="shortcut icon" href="'.$DIR.'img/favicon.ico" type="image/vnd.microsoft.icon">', "\n";
	print '	<script type="text/javascript" src="'.$DIR.'js/jquery-1.11.2.min.js"></script>', "\n";
	print '	<script type="text/javascript" src="./js/script_fitting.js"></script>', "\n";
	print '	<script type="text/javascript" src="./js/script_toggle.js"></script>', "\n";
	# print '	<script type="text/javascript" src="'.$DIR.'js/script_home.js"></script>', "\n";
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
EOM

	# print $ArticleLists[0],"\n";
	# print $ArticleLists[0]{'tag'},"\n";
	# print %{$ArticleLists[0]},"\n";
	# print @{$ArticleLists[0]{'tag'}},"\n";
	# print "hhhhh\n";
	########################################
	# リストにする記事の抽出
	########################################
	my @ArticleListsSelected;
	if ($class eq 'tag') {
		foreach (@ArticleLists) {
			# print $_,"\n";								# ハッシュのリファレンス
			# print %{$_},"\n";								# ハッシュのリファレンスをデリファレンス
			# print ${$_}{'year'},"\n";						# ハッシュのリファレンスをデリファレンスの要素
			# print ${$_}{'tag'},"\n";						# ハッシュのリファレンスをデリファレンスの要素配列のリファレンス
			# print @{${$_}{'tag'}},"\n";					# ハッシュのリファレンスをデリファレンスの要素配列のリファレンスのデリファレンス
			my $flag = 0;						# リスト化する記事か？
			# foreach (@{$_{'tag'}}) {			# これじゃだめ
			foreach (@{${$_}{'tag'}}) {			# これが正しい
				if ($_ eq $target) {
					$flag = 1;
				}
			}
			# print $flag, "\n";
			if ($flag == 1) {
				$ArticleListsSelected[$#ArticleListsSelected + 1] = $_;
			}
		}
	} elsif ($class eq 'category') {
		foreach (@ArticleLists) {
			my $flag = 0;							# リスト化する記事か？
			# foreach (@{$_{'category'}}) {			# これじゃだめ
			foreach (@{${$_}{'category'}}) {		# これが正しい
				if ($_ eq $target) {
					$flag = 1;
				}
			}
			if ($flag == 1) {
				$ArticleListsSelected[$#ArticleListsSelected + 1] = $_;
			}
		}
	} elsif ($class eq 'archive') {
		foreach (@ArticleLists) {
			if (${$_}{'year'} eq $target) {
				# print 1;
				$ArticleListsSelected[$#ArticleListsSelected + 1] = $_;
			}
		}
	} else {
		# 全記事表示のため，なにも削除しない
		# 参照渡しswapにしたいな...？
		@ArticleListsSelected = @ArticleLists;
	}

	my $articleNum = 0;
	if (@ArticleListsSelected) {
		# 空でない場合の処理
		$articleNum = $#ArticleListsSelected + 1;
	} else {
		# 空の場合の処理
	}
	my $pageNum = int(($articleNum-1) / $SETTING{'row'}) +1;
	if ($pageNum == 0) {
		# 記事がない場合
		$pageNum = 1;
	}
	if ($page < 1) {
		$page = 1;
	}
	if ($page > $pageNum) {
		$page = $pageNum;
	}


print <<'EOM';

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

	&sub::blog::sideMenu(\@ArticleLists, \%SETTING, $BLOG_DIR, 0);

print <<'EOM';

<div id="contents" class="right">
EOM
	if ($class eq 'tag') {
		print '<h2>「'.$SETTING{'tag'}{$target}.'」 TAG 一覧</h2>', "\n";
	} elsif ($class eq 'category') {
		print '<h2>「'.$SETTING{'category'}{$target}.'」 CATEGORY 一覧</h2>', "\n";
	} elsif ($class eq 'archive') {
		print '<h2>ARCHIVE '.$target.'</h2>', "\n";
	} else {
		print '<h2>RECENT ARTICLES</h2>', "\n";
	}

	# 記事リンクをforで生成
	for (my $i = $SETTING{'row'} * ($page-1); $i < $SETTING{'row'} * ($page); $i++) {
		if ($articleNum == 0) {
			&sub::GenerateList::GenerateNullPanel();
			last;
		}
		if ($i > $#ArticleListsSelected) {
			last;
		}

		# &sub::GenerateList::GeneratePanel(\@ArticleListsSelected, \%SETTING, \@Texts, $i, $ArticleListsSelected[$i]);
		&sub::GenerateList::GeneratePanel($ArticleListsSelected[$i], \%SETTING);
		push(@Texts, $ArticleListsSelected[$i]{'text'});
	}


print <<'EOM';
	<div id="goBackButton" class="clearfix">
EOM
	# ぼたん
	if ($page > 1) {
		print '<a href="./?c='.$class.'&t='.$target.'&p='.($page-1).'" id="backButton" class="left button"><<前のページ</a>' ,"\n";
	} else {
		print '<div class="disable left"></div>', "\n";
	}
	print '<div class="page left">'.$page.' / '.$pageNum.'</div>' ,"\n";
	if ($page < $pageNum) {
		print '<a href="./?c='.$class.'&t='.$target.'&p='.($page+1).'" id="goButton" class="right button">次のページ >></a>' ,"\n";
	} else {
		print '<div class="disable right"></div>', "\n";
	}
print <<'EOM';
	</div>
</div>

<footer>
<p>Copyright&copy;&nbsp;&nbsp; <a href="/">溶けかけてるうさぎ MeltingRabbit</a>&nbsp;&nbsp; All Rights Reserved.</p>
</footer>

</div>


<script>
$(function() {
	// p.textの文字数を動的に変更する
	var texts = [];
EOM
	foreach (@Texts) {
		# print "	texts.push('".$_."');" ,"\n";
		print "	texts.push('".&sub::EscapeHtml($_)."');" ,"\n";
	}
print <<'EOM';
	console.log(texts);

	SetTexts(texts);
	$(window).on('resize', function() {
		// console.log('resize!!');
		SetTexts(texts);
	})

});

function SetTexts(texts) {
	if (texts.length == 0) {
		return;
	}

	var pWidth = $('#contents .article div.right p.text').width();

	// 全角55文字 660px
	var letterPerPx = 55.0 / 660.0;
	var numOfLetter = Math.floor(pWidth * letterPerPx * 2) - 2;
	if (numOfLetter < 0) {
		numOfLetter = 0;
	}

	// console.log(pWidth);
	// console.log(numOfLetter);


	// for(var i = 0; i < texts.length; i++) {
		// console.log(texts[i].length);
		// console.log(texts[i].substr(0,20));
	// }
	$('#contents .article div.right p.text').each(function(i) {
		// console.log($(this).text());
		// console.log(texts[i]);
		$(this).text(texts[i].substr(0,numOfLetter) + "...");
	});

	// console.log("#############");
}

</script>

</body>
</html>

EOM


	return;
}



package sub::GenerateList;

sub GenerateNullPanel {
print <<'EOM';
	<div class="panel">
		<p>表示できる記事がありません．</p>
	</div>
EOM
	return;
}


sub GeneratePanel {

	my $articleData = $_[0];
	my %SETTING     = %{$_[1]};

	my $year  = $articleData->{'year'} ;
	my $month = $articleData->{'month'};
	my $day   = $articleData->{'day'}  ;
	my $no    = $articleData->{'no'}   ;

	print '<a href="./article/'.$year.$month.$day.$no.'/" class="clearfix article">', "\n";
print <<'EOM';
		<div class="left">
EOM
	print '<img src="./article/'.$year.$month.$day.$no.'/list.jpg">', "\n";
print <<'EOM';
		</div>
		<div class="right">
			<ul>
EOM
	# ulの要素に改行挟むとレイアウトが崩れる．
	foreach (@{$articleData->{'category'}}) {
		# print '<li>'.$SETTING{'category'}{$_}.'</li>', "\n";
		print '<li>'.$SETTING{'category'}{$_}.'</li>';
	}
	foreach (@{$articleData->{'tag'}}) {
		# print '<li class="tag">'.$SETTING{'tag'}{$_}.'</li>', "\n";
		print '<li class="tag">'.$SETTING{'tag'}{$_}.'</li>';
	}
print <<'EOM';
</ul>
EOM
	print '<p class="title">'.$articleData->{'title'}.'</p>', "\n";
	# print '<p class="text">'.$articleData->{'text'}.'...</p>', "\n";
	print '<p class="text">...</p>', "\n";
	# push(@Texts, $articleData->{'text'});
print <<'EOM';
			<div class="clearfix date">
EOM
	print 	'<p class="right">'.$year.'-'.$month.'-'.$day.'</p>', "\n";
print <<'EOM';
			</div>
		</div>
	</a>
EOM

	return;
}



1;

