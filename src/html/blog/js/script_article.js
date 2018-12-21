(function() {

$(function() {


	SetSerialNumber2Bracket();
	SetSerialNumber2MyOl();
	SetUlOl();
	SetFontSize();
	SetIndent();

	// var h2Texts = SetH2Id();
	var h2h3Texts = SetH2H3Id();
	// console.log(h2Texts);
	// AddSidemenu(h2Texts);
	AddSidemenu(h2h3Texts);

	// これは文字などの挿入がすべて終わったら実行
	SetCrossReference();
	Fitting();


	FixSidemenu();


	// alert($(window).width());


	// ページ読み込み時とスクロール時に、現在地をチェックする
	$(window).on('load scroll', function() {
		// console.log("load scroll");
		ShowCurrent();
	});

	// サイドメニューのfixedメニューの横位置調整
	$(window).on("scroll resize load", function(){
		var sidemenuLeftOffset = $('#sideMenu').offset().left;
		// console.log(sidemenuLeftOffset);

		$("div#fixedContents.fixed").css("left", -$(window).scrollLeft() + sidemenuLeftOffset);
	});


});


// 記事内出典（.bracket）に連番を付加する
function SetSerialNumber2Bracket() {
	$('div#contents table.bracket').each(function(i) {
		$(this).find('tr').each(function(j) {
			$(this).children('td:first-child').text("[" + (j+1) + "]");
		});
	});
}


// .my-olに連番を付加する
function SetSerialNumber2MyOl() {
	$('div#contents table.my-ol').each(function(i) {
		// console.log($(this).text());
		// console.log($(this).find('tr').children('td:first-child').text());
		// console.log($(this).find('tr').children('td:last-child').text());
		var jj = 1;
		if ($(this).hasClass("first-line")) {
			// console.log("ARU");
			var fl = parseInt($(this).attr("fl"));
			jj = fl;
			// console.log(fl);
		} else {
			// console.log("NAI");
		}
		$(this).find('tr').each(function(j) {
			// console.log($(this).children('td:first-child').text());
			// console.log($(this).children('td:last-child').text());
			// $(this).children('td:first-child').text((j+1) + ".");
			$(this).children('td:first-child').text(jj + ".");
			jj++;
		});
	});
}

// .my-ulにドットを付加する
function SetUlOl() {
	$('div#contents table.my-ul').each(function(i) {
		$(this).find('tr').each(function(j) {
			$(this).children('td:first-child').text("・");
		});
	});
}

function SetFontSize() {
	$('div#contents .font-size').each(function(i) {
		// console.log(parseInt($(this).css('font-size')));
		var fs = parseFloat($(this).css('font-size'));
		var dfs = parseFloat($(this).attr("fs"));
		// console.log(dfs);
		fs = fs + dfs;
		// console.log(fs);
		$(this).css('font-size', fs+"px");
	});
}

function SetIndent() {
	$('div#contents .indent').each(function(i) {
		// console.log(parseInt($(this).css('font-size')));
		var indent = parseFloat($(this).css('padding-left'));
		var dindent = parseFloat($(this).attr("indent"));
		// console.log(dindent);
		indent = indent + dindent;
		// console.log(indent);
		$(this).css('padding-left', indent+"px");
	});
}






// 記事内H2に連番idを付加し，H2のtext配列を返す．
function SetH2Id() {
	var h2Texts = [];
	$('div#contents>h2').each(function(i) {
		// $(this).attr('class','number' + (i+1));
		$(this).attr('id','h2-' + (i+1));
		console.log($(this).text());
		h2Texts.push($(this).text());
	});
	return h2Texts;
}


// 記事内H2H3に連番idを付加し，H2のtext配列を返す．
function SetH2H3Id() {
	var h2h3Texts = [];
	var jH2 = 1;
	var jH3 = 1;
	$('div#contents>h2, div#contents>h3').each(function(i) {
		// $(this).attr('class','number' + (i+1));
		// $(this).attr('id','h2-' + (i+1));
		// console.log($(this));
		// ココらへんの[0]がいるかいらないかよくわかんね．
		// console.log($(this).nodeName);
		// console.log($(this)[0].nodeName);
		// console.log($(this).tagName);
		// console.log($(this)[0].tagName);
		// console.log($(this).text());
		if ($(this)[0].tagName == "H2") {
			$(this).attr('id','h2-' + jH2);
			h2h3Texts.push([$(this).text(), "H2"]);
			console.log("H2-"+String(jH2)+":"+$(this).text());
			jH2++;
		} else if ($(this)[0].tagName == "H3") {
			$(this).attr('id','h3-' + jH3);
			h2h3Texts.push([$(this).text(), "H3"]);
			console.log("H3-"+String(jH3)+":"+$(this).text());
			jH3++;
		} else {
		}
	});
	return h2h3Texts;
}





// サイドメニューにcontentを追加
// function AddSidemenu(h2Texts) {
// 	var appendHtml = "";
// 	appendHtml += "<h2>CONTENTS</h2>";
// 	if (h2Texts.length == 0) {
// 		appendHtml += '<a href="#">目次なし</a>';
// 		// appendHtml += '<a href="http://google.com">目次なし</a>';
// 	}
// 	for (var i=0; i<h2Texts.length ;i++) {
// 		var temp = '<a href="#h2-' + (i+1) + '">' + h2Texts[i] + '</a>';
// 		appendHtml += temp;
// 	}
// 	// console.log(appendHtml);
// 	$('#sideMenu').prepend(appendHtml);
// 	appendHtml = '<div id="fixedContents">' + appendHtml + '</div>';
// 	$('#sideMenu').append(appendHtml);
// }
function AddSidemenu(h2h3Texts) {
	console.log(h2h3Texts);
	var appendHtml = "";
	appendHtml += "<h2>CONTENTS</h2>";
	if (h2h3Texts.length == 0) {
		appendHtml += '<a href="#">目次なし</a>';
		// appendHtml += '<a href="http://google.com">目次なし</a>';
	}
	var jH2 = 1;
	var jH3 = 1;
	for (var i=0; i<h2h3Texts.length ;i++) {
		var temp;
		if (h2h3Texts[i][1] == "H2") {
			temp = '<a href="#h2-' + String(jH2) + '">' + h2h3Texts[i][0] + '</a>';
			jH2++;
		} else if (h2h3Texts[i][1] == "H3") {
			temp = '<a class="h3" href="#h3-' + String(jH3) + '">' + h2h3Texts[i][0] + '</a>';
			jH3++;
		} else {
		}
		appendHtml += temp;
	}
	// console.log(appendHtml);
	$('#sideMenu').prepend(appendHtml);
	appendHtml = '<div id="fixedContents">' + appendHtml + '</div>';
	$('#sideMenu').append(appendHtml);
}

// サイドメニューの固定
function FixSidemenu() {
	var tab = $('#fixedContents');
	var offset = $('#fixedContents').offset().top;
	var marginTop = parseFloat($('#fixedContents').css('margin-top'));
	// console.log(offset);
	// console.log(marginTop);
	offset -= marginTop;
	// console.log(offset);
	$(window).scroll(function () {
		// console.log("SC!");
		// console.log($(window).scrollTop());
		if($(window).scrollTop() > offset) {
			tab.addClass('fixed');
		} else {
			tab.removeClass('fixed');
		}
	});
}


// 現在の位置をナビゲーションに表示
function ShowCurrent() {
	// http://www.tam-tam.co.jp/tipsnote/javascript/post4996.html

	// 完全にその領域ではなく，少し上からその領域とする．
	var offset = 30;

	// ナビゲーションのリンクを指定
	var navLink = $('#fixedContents a');
	// console.log("####");
	// console.log(navLink);
	// console.log("####");

	// 目次なしの場合
	// console.log($(navLink.eq(0).attr('href')).selector);
	// console.log($(navLink.eq(0)).text());
	// console.log($('#').selector);
	// console.log($(navLink.eq(0).attr('href')).selector == $('#').selector);
	// if ( $(navLink.eq(0).attr('href')) == "#" ) {
	if ( $(navLink.eq(0).attr('href')).selector == $('#').selector ) {
		return false;
	}

	// 各コンテンツのページ上部からの開始位置と終了位置を配列に格納しておく
	var contentsPositions = [];
	for (var i = 0; i < navLink.length; i++) {
		var targetContentsTop    = $(navLink.eq(i).attr('href')).offset().top - offset;
		var targetContentsBottom;
		if (i == (navLink.length - 1) ) {
			targetContentsBottom = $('body').outerHeight(true);
		} else {
			targetContentsBottom = $(navLink.eq(i+1).attr('href')).offset().top - 1 - offset;
		}
		contentsPositions[i] = [targetContentsTop, targetContentsBottom];
	};


	// 現在地をチェックする
	// 現在のスクロール位置を取得
	var windowScrolltop = $(window).scrollTop();
	// console.log(contentsPositions);
	// console.log(windowScrolltop);
	for (var i = 0; i < contentsPositions.length; i++) {
		// 現在のスクロール位置が、配列に格納した開始位置と終了位置の間にあるものを調べる
		if(contentsPositions[i][0] <= windowScrolltop && contentsPositions[i][1] >= windowScrolltop) {
			// 開始位置と終了位置の間にある場合、ナビゲーションにclass="current"をつける
			navLink.removeClass('current');
			navLink.eq(i).addClass('current');
			// i == contentsPositions.length;
			// console.log(i+1);
			break;
		}
	};



}


// 相互参照の構築
function SetCrossReference() {
	$('div#contents a.cross-ref').each(function(i) {
		id = $(this).attr('href');
		$(this).text($(id).text());
	});

}



})();
