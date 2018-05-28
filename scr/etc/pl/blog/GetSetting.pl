
use utf8;
package sub::blog;
sub GetSetting {

	my %SETTING;
	$SETTING{'row'} = 10;						# 1ページに表示する記事数
	$SETTING{'recent_num_at_list'} = 20;		# サイドメニュー最新記事表示数 at list
	$SETTING{'recent_num_at_article'} = 5;		# サイドメニュー最新記事表示数 at article
	$SETTING{'begin_year'} = 2016;
	$SETTING{'end_year'} = 2018;

	$SETTING{'popular_articles'} = [			# 人気記事一覧（Todo : 動的に作るように）
		2017121801,
		2017041301,
		2018010901,
		2018032302
	];


	# %CATEGORY, %TAG, yearのkeyは重複禁止
	# %TAGは接頭辞 t_ を付加．%CATEGORYは数字のみ禁止

	my %CATEGORY;
	$CATEGORY{'univ'  } = '大学';
	$CATEGORY{'aa'    } = '航空宇宙';
	$CATEGORY{'photo' } = '写真';
	$CATEGORY{'trip'  } = '旅行';
	$CATEGORY{'food'  } = '飯・酒';
	$CATEGORY{'pc'    } = 'コンピュータ';
	$CATEGORY{'others'} = 'その他';

	# カテゴリの順番を保持したり，記事数をカウントしたりするため
	# この順番はそのままサイドメニューの順番になる．
	my @CategoryLists =    ({'code' => 'univ'  ,'num' => 0},
							{'code' => 'aa'    ,'num' => 0},
							{'code' => 'photo' ,'num' => 0},
							{'code' => 'trip'  ,'num' => 0},
							{'code' => 'food'  ,'num' => 0},
							{'code' => 'pc'    ,'num' => 0},
							{'code' => 'others','num' => 0});

	$SETTING{'category'} = \%CATEGORY;
	$SETTING{'categoryList'} = \@CategoryLists;


	my %TAG;
	$TAG{'t_perl'      } = 'Perl';
	$TAG{'t_ccpp'      } = 'C/C++';
	$TAG{'t_python'    } = 'Python';
	$TAG{'t_js'        } = 'JavaScript';
	$TAG{'t_html'      } = 'HTML';
	$TAG{'t_css'       } = 'CSS';
	$TAG{'t_md'        } = 'Markdown';
	$TAG{'t_bat'       } = 'Batch File';
	$TAG{'t_server'    } = 'サーバー';
	$TAG{'t_windows'   } = 'Windows';
	$TAG{'t_ubuntu'    } = 'Ubuntu';
	$TAG{'t_cygwin'    } = 'Cygwin';
	$TAG{'t_android'   } = 'Android';
	$TAG{'t_arduino'   } = 'Arduino';
	$TAG{'t_mingw'     } = 'MinGW';
	$TAG{'t_vs'        } = 'Visual Studio';
	$TAG{'t_sublime'   } = 'Sublime Text';
	$TAG{'t_gnuplot'   } = 'Gnuplot';
	$TAG{'t_latex'     } = 'LaTeX';
	$TAG{'t_uplatex'   } = 'upLaTeX';
	$TAG{'t_luatex'    } = 'LuaTeX';
	$TAG{'t_bibtex'    } = 'BibTeX';
	$TAG{'t_google'    } = 'Google';
	$TAG{'t_chrome'    } = 'Chrome';
	$TAG{'t_apache'    } = 'Apache';
	$TAG{'t_subversion'} = 'Subversion';
	$TAG{'t_github'    } = 'GitHub';
	$TAG{'t_twitter'   } = 'Twitter';
	$TAG{'t_web'       } = 'Web';
	$TAG{'t_exif'      } = 'Exif';
	$TAG{'t_camera'    } = 'カメラ';
	$TAG{'t_photo'     } = '写真';
	$TAG{'t_optics'    } = '光学';
	$TAG{'t_font'      } = 'Font';
	$TAG{'t_jaxa'      } = 'JAXA';
	$TAG{'t_rocket'    } = 'ロケット';
	$TAG{'t_satellite' } = '人工衛星';
	$TAG{'t_cubesat'   } = 'CubeSat';
	$TAG{'t_aaTrip'    } = '学科旅行';
	$TAG{'t_labProject'} = '研究室プロジェクト';
	$TAG{'t_study'     } = '研究';
	$TAG{'t_thinking'  } = '思考';
	$TAG{'t_empty'     } = '内容が無い';
	$TAG{'t_null'      } = 'タグなし';

	# タグの順番を保持したり，記事数をカウントしたりするため
	# この順番はそのままサイドメニューの順番になる．
	my @TagLists = ({'code' => 't_perl'       ,'num' => 0},
					{'code' => 't_ccpp'       ,'num' => 0},
					{'code' => 't_python'     ,'num' => 0},
					{'code' => 't_js'         ,'num' => 0},
					{'code' => 't_html'       ,'num' => 0},
					{'code' => 't_css'        ,'num' => 0},
					{'code' => 't_md'         ,'num' => 0},
					{'code' => 't_bat'        ,'num' => 0},
					{'code' => 't_server'     ,'num' => 0},
					{'code' => 't_windows'    ,'num' => 0},
					{'code' => 't_ubuntu'     ,'num' => 0},
					{'code' => 't_cygwin'     ,'num' => 0},
					{'code' => 't_android'    ,'num' => 0},
					{'code' => 't_arduino'    ,'num' => 0},
					{'code' => 't_mingw'      ,'num' => 0},
					{'code' => 't_vs'         ,'num' => 0},
					{'code' => 't_sublime'    ,'num' => 0},
					{'code' => 't_gnuplot'    ,'num' => 0},
					{'code' => 't_latex'      ,'num' => 0},
					{'code' => 't_uplatex'    ,'num' => 0},
					{'code' => 't_luatex'     ,'num' => 0},
					{'code' => 't_bibtex'     ,'num' => 0},
					{'code' => 't_google'     ,'num' => 0},
					{'code' => 't_chrome'     ,'num' => 0},
					{'code' => 't_apache'     ,'num' => 0},
					{'code' => 't_subversion' ,'num' => 0},
					{'code' => 't_github'     ,'num' => 0},
					{'code' => 't_twitter'    ,'num' => 0},
					{'code' => 't_web'        ,'num' => 0},
					{'code' => 't_exif'       ,'num' => 0},
					{'code' => 't_camera'     ,'num' => 0},
					{'code' => 't_photo'      ,'num' => 0},
					{'code' => 't_optics'     ,'num' => 0},
					{'code' => 't_font'       ,'num' => 0},
					{'code' => 't_jaxa'       ,'num' => 0},
					{'code' => 't_rocket'     ,'num' => 0},
					{'code' => 't_satellite'  ,'num' => 0},
					{'code' => 't_cubesat'    ,'num' => 0},
					{'code' => 't_aaTrip'     ,'num' => 0},
					{'code' => 't_labProject' ,'num' => 0},
					{'code' => 't_study'      ,'num' => 0},
					{'code' => 't_thinking'   ,'num' => 0},
					{'code' => 't_empty'      ,'num' => 0},
					{'code' => 't_null'       ,'num' => 0});

	$SETTING{'tag'} = \%TAG;
	$SETTING{'tagList'} = \@TagLists;

	return %SETTING;
}


1;

