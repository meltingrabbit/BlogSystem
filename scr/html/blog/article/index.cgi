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


my $DIR = "../../";
my $BLOG_DIR = "../";
my $PAGE = "blog/article/index.cgi";

my $PL_DIR = $DIR.'../etc/pl/';
require $PL_DIR.'RecordAccessLog.pl';
# require $PL_DIR.'blog/GetDatabase.pl';
# require $PL_DIR.'blog/GetSetting.pl';
# require $PL_DIR.'blog/GenerateList.pl';
# require $PL_DIR.'EscapeHtml.pl';

my $ACCESS_LOG = &sub::RecordAccessLog($PAGE);
# my @ArticleLists = &sub::blog::GetDatabase();
# my %SETTING = &sub::blog::GetSetting();


print 'Location: ../', "\n\n";


exit;

