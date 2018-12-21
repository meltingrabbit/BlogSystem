
use utf8;
package sub::blog;
sub sideMenu {
	my @ArticleLists = @{$_[0]};
	my %SETTING      = %{$_[1]};
	my $DIR          = $_[2];
	my $flag         = $_[3];		# at list or article

	my $BEGIN_YEAR = $SETTING{'begin_year'};
	my $END_YEAR = $SETTING{'end_year'};
	my $LIST_NUM = 0;								# サイドメニューに表示する記事数
	if ($flag == 0) {
		$LIST_NUM = $SETTING{'recent_num_at_list'};
	} else {
		$LIST_NUM = $SETTING{'recent_num_at_article'};
	}

	my %COUNT;
	# CATEGORYの記事数をカウント
	# 初期化
	for (my $i = 0; $i <= $#{$SETTING{'categoryList'}}; $i++) {
		$COUNT{$SETTING{'categoryList'}[$i]{'code'}} = 0;
	}
	# カウント
	for (my $i = 0; $i <= $#ArticleLists; $i++) {
		foreach (@{$ArticleLists[$i]{'category'}}) {
			$COUNT{$_}++;
		}
	}

	# TAGの記事数をカウント
	# 初期化
	for (my $i = 0; $i <= $#{$SETTING{'tagList'}}; $i++) {
		$COUNT{$SETTING{'tagList'}[$i]{'code'}} = 0;
	}
	# カウント
	for (my $i = 0; $i <= $#ArticleLists; $i++) {
		foreach (@{$ArticleLists[$i]{'tag'}}) {
			$COUNT{$_}++;
		}
	}

	# 年，年月の記事数をカウント
	#初期化
	for (my $i = $BEGIN_YEAR; $i <= $END_YEAR; $i++) {
		$COUNT{$i} = 0;
		for (my $j = 1; $j <= 9; $j++) {
			$COUNT{$i.'-0'.$j} = 0;
		}
		for (my $j = 10; $j <= 12; $j++) {
			$COUNT{$i.'-'.$j} = 0;
		}
	}
	# カウント
	for (my $i = 0; $i <= $#ArticleLists; $i++) {
		$COUNT{$ArticleLists[$i]{'year'}}++;
		$COUNT{$ArticleLists[$i]{'year'}.'-'.$ArticleLists[$i]{'month'}}++;
	}


print <<'EOM';
<div id="sideMenu" class="left">
	<h2>MENU</h2>
EOM
	print '<a href="'.$DIR.'../">溶けかけてるうさぎ HP</a>', "\n";
	print '<a href="'.$DIR.'">BLOG TOP</a>', "\n";
	print '<a href="'.$DIR.'">RECENT ARTICLES</a>', "\n";
	print '<a href="'.$DIR.'?t=popular">POPULAR ARTICLES</a>', "\n";
	print '<a href="'.$DIR.'about.cgi">ABOUT THIS BLOG</a>', "\n";
print <<'EOM';
	<h2>CATEGORY</h2>
EOM
	for (my $i = 0; $i <= $#{$SETTING{'categoryList'}}; $i++) {
		print '<a href="'.$DIR.'?c=category&t='.$SETTING{'categoryList'}[$i]{'code'}.'">';
		print $SETTING{'category'}{$SETTING{'categoryList'}[$i]{'code'}};
		print ' (';
		print $COUNT{$SETTING{'categoryList'}[$i]{'code'}};
		print ')</a>';
		print "\n";
	}
	# foreach (keys(%COUNT)) {
	# 	my $value = $COUNT{$_};
	# 	print $_." --> ".$value."\n";
	# 	print "<p></p>\n";
	# }
print <<'EOM';
	<h2>TAG</h2>
	<div id="tagList" class="clearfix">
EOM
	for (my $i = 0; $i <= $#{$SETTING{'tagList'}}; $i++) {
		print '<a class="left" href="'.$DIR.'?c=tag&t='.$SETTING{'tagList'}[$i]{'code'}.'">';
		print $SETTING{'tag'}{$SETTING{'tagList'}[$i]{'code'}};
		print ' (';
		print $COUNT{$SETTING{'tagList'}[$i]{'code'}};
		print ')</a>';
		print "\n";
	}
print <<'EOM';
	</div>
EOM
print <<'EOM';
	<h2>ARCHIVE</h2>
EOM
	for (my $year = $END_YEAR; $year >= $BEGIN_YEAR; $year--) {
		print '<div class="archive-div">', "\n";
		print '	<div class="month-toggle-trigger">▷</div><a class="archive-year" href="'.$DIR.'?c=archive&t='.$year.'">';
		# print '<span class="toggle-trigger toggle-icon">▶</span>&nbsp;&nbsp;';
		print $year;
		print ' (';
		print $COUNT{$year};
		print ')</a>';
		print "\n";

		print '	<div class="archive-toggle-area">', "\n";
		# print "<div class="toggle-area">\n";
		for (my $j = 12; $j > 0; $j--) {
			my $month = ($j < 10) ? '0'.$j : $j;
			print '		<a class="archive-year-month" href="'.$DIR.'?c=archive&t='.$year.$month.'">'.$year."/".$month." (";
			print $COUNT{$year.'-'.$month};
			print ")</a>\n";
			}
		print "	</div>\n";
		print "</div>\n";
	}
print <<'EOM';
	<h2>RECENT</h2>
EOM
	for (my $i = 0; $i < $LIST_NUM; $i++) {
		if ($i > $#ArticleLists) {
			last;
		}
		my $year  = $ArticleLists[$i]{'year'} ;
		my $month = $ArticleLists[$i]{'month'};
		my $day   = $ArticleLists[$i]{'day'}  ;
		my $no    = $ArticleLists[$i]{'no'}   ;
		my $title = $ArticleLists[$i]{'title'}   ;
		print '<a class="sm-recent" href="'.$DIR.'article/'.$year.$month.$day.$no.'/">'.$title.'</a>', "\n";
	}
print <<'EOM';
</div>
EOM


	return;
}



1;

