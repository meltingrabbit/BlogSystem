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
my $PAGE = "blog/index.cgi";

my $PL_DIR = $DIR.'../etc/pl/';
require $PL_DIR.'RecordAccessLog.pl';
# require $PL_DIR.'blog/GetDatabase.pl';
# require $PL_DIR.'blog/GetSetting.pl';
require $PL_DIR.'blog/GenerateList.pl';
require $PL_DIR.'EscapeHtml.pl';

my $ACCESS_LOG = &sub::RecordAccessLog($PAGE);
# my @ArticleLists = &sub::blog::GetDatabase();
# my %SETTING = &sub::blog::GetSetting();



####################
# get,post 受け取り
####################
my $buffer = 0;
if ($ENV{'REQUEST_METHOD'} eq "POST") {
	read(STDIN, $buffer, $ENV{'CONTENT_LENGTH'});
} else {
	$buffer = $ENV{'QUERY_STRING'};
	#print 'Location: ./index.html', "\n\n";
}

my ($pair, @pairs, %FORM);
$FORM{'c'} = 'none';		# class  none/archive/tag
$FORM{'t'} = 'recent';		# target
$FORM{'p'} = '1';			# page
@pairs = split(/&/, $buffer);
foreach $pair (@pairs) {
	my ($key, $value) = split(/=/, $pair);
	$value =~ tr/+/ /;
	$value =~ s/%([0-9a-fA-F][0-9a-fA-F])/chr(hex($1))/eg;
	$FORM{$key} = $value;
}

$FORM{'c'} = &sub::EscapeHtml($FORM{'c'});
$FORM{'t'} = &sub::EscapeHtml($FORM{'t'});
$FORM{'p'} = &sub::EscapeHtml($FORM{'p'});

&sub::blog::GenerateList($FORM{'c'}, $FORM{'t'}, $FORM{'p'});



exit;

