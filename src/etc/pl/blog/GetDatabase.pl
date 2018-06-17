
use utf8;
package sub::blog;
sub GetDatabase {

	my $DATABASE_PATH = '***********/etc/setting/blog/articleDatabase.dat';

	my @ArticleLists;		# 記事リスト
	my %ID2IDX;				# 記事リストをIDから逆引き出来るようにするハッシュ

	# ファイル読み込み
	if (open(IPF, "<:utf8", $DATABASE_PATH)) {
		my @Datalines = <IPF>;
		for (my $i = 0; $i <= $#Datalines; $i++) {
			$Datalines[$i] =~ s/\r\n$|\r$|\n$//;
			my @Temp = split(/,/, $Datalines[$i]);
			# 記事が有効か？
			if ($Temp[4] ne '1') {
				# ローカルからのアクセスの場合はnextしない．
				my @Ip = split(/\./, $ENV{'REMOTE_ADDR'});
				if (($Ip[0] ne '192') or ($Ip[1] ne '168')) {
					next;
				}
			}
			my %TEMP;
			$TEMP{'year'}       = $Temp[0];
			$TEMP{'month'}      = $Temp[1];
			$TEMP{'day'}        = $Temp[2];
			$TEMP{'no'}         = $Temp[3];
			my $id              = $Temp[0].$Temp[1].$Temp[2].$Temp[3];
			$ID2IDX{$id}        = $#ArticleLists + 1;	# 逆引き用

			$TEMP{'metaRobots'} = $Temp[5];
			$TEMP{'title'}      = $Temp[6];
			$TEMP{'text'}       = $Temp[7];

			my @CategoryTemp    = split(/-/, $Temp[8]);
			$TEMP{'category'}   = \@CategoryTemp;
			my @TagTemp         = split(/-/, $Temp[9]);
			$TEMP{'tag'}        = \@TagTemp;

			$ArticleLists[$#ArticleLists + 1] = \%TEMP;
		}
	} else {
		exit(1);
	}
	if (close(IPF)) {
		# なにもしない
	} else {
		exit(1);
	}

	return (\@ArticleLists, \%ID2IDX);

}


1;

