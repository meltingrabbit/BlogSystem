(function() {

$(function() {

// 旧版
// Fitting();
// $(window).on('load', function() {
// 	// console.log('load!!');
// 	Fitting();
// 	$(window).on('resize', function() {
// 		// console.log('resize!!');
// 		Fitting();
// 	});
// });

Fitting();
$(window).on('resize', function() {
	// console.log('resize!!');
	Fitting();
});


});


// 画面幅に合わせて，#contents幅などを可変に
/*
変えるべきもの

nav>div									960 px
#container								960 px
#contents								680 px
#contents .article div.right			410 px
#goBackButton>div.page					160 px
*/
function Fitting() {
	var bodyWidth = $(window).width();
	// console.log(bodyWidth);

	var defaultNavWidth          = 960;
	var defaultContainerWidth    = 960;
	var defaultContentsWidth     = 680;
	var defaultArticleLinkWidth  = 410;
	var defaultButtonWidth       = 160;
	var minDeltaWidth            = - 0;
	// var maxDeltaWidth            = + 250;
	var maxDeltaWidth            = + 400;
	var marginWidth              = 50 * 2;

	var deltaWidth = bodyWidth - defaultContainerWidth - marginWidth;

	if (deltaWidth < minDeltaWidth) {
		// デフォルト値
		deltaWidth = 0;
	} else if (deltaWidth > maxDeltaWidth) {
		// 最大伸ばし幅
		deltaWidth = maxDeltaWidth;
	}

	// console.log("deltaWidth : " + deltaWidth);

	$('nav>div'                     ).css('width', (defaultNavWidth         + deltaWidth)+"px");
	$('#container'                  ).css('width', (defaultContainerWidth   + deltaWidth)+"px");
	$('#contents'                   ).css('width', (defaultContentsWidth    + deltaWidth)+"px");
	$('#contents .article div.right').css('width', (defaultArticleLinkWidth + deltaWidth)+"px");
	$('#goBackButton>div.page'      ).css('width', (defaultButtonWidth      + deltaWidth)+"px");
}

})();