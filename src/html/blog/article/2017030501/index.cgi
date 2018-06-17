#!/usr/bin/perl

use strict;
use warnings;
use utf8;
binmode STDOUT, ':utf8';
#use Time::Local;


#use Encode qw(decode_utf8 encode_utf8);
# perlの文字化け問題、まじで謎...
# こういう論理的な知識を体系的に身に付けるには、ラクダ本読まないとダメなのかな...？
# http://tech.voyagegroup.com/archives/465806.html

my $ID = 2017030501;
# my $title = $Temp[5];
# my $date = $Temp[0]."-".$Temp[1]."-".$Temp[2];
# my @Tag = split(/-/, $Temp[7]);

my $DIR = '../../../';
my $BLOG_DIR = '../../';
my $PAGE = 'blog/article/'.$ID.'/index.cgi';

my $PL_DIR = $DIR.'../etc/pl/';
require $PL_DIR.'RecordAccessLog.pl';
require $PL_DIR.'blog/GenerateArticle.pl';

my $ACCESS_LOG = &sub::RecordAccessLog($PAGE);

my $article = "";
my @Comment = ();
my @RelatedPosts = ();

$article = <<'EOM';
	<div id="abstract">
		<p>ブログ始めました．ただそれだけです．</p>
	</div>
	<h2>１．ブログ</h2>
	<p>録画用のサーバーがあったので，備忘録としてブログをはじめました．</p>
	<p>ブログシステムもすべてフルスクラッチで組んでみたのはいいものの，書くことないなw</p>
	<p>&nbsp;</p>
	<p>ちなみにまだサイドバーは未完成なので，リンクは切れてます．</p>
	<p>HPの方はレスポンシブデザインでスマホに対応してますが，こちらはめんどくさいので未対応です．暇な時にでも実装します．備忘録としてソースコードなども貼ろうかなと思ってるので，スマホに対応させようとすると，少しめんどくさそう．</p>
EOM


&sub::blog::GenerateArticle($ID, \$article, \@Comment, \@RelatedPosts);



exit;

