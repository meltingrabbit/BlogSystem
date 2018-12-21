(function() {


// サイドバーの年月記事を開閉する
$(function() {
	$('div.month-toggle-trigger').click(function() {
		// console.log(this);
		var $clickElem = $(this);
		// console.log($('p.toggle-trigger'));
		// console.log($clickElem);
		// console.log($clickElem.text());

		$clickElem.parent().find('.archive-toggle-area').stop().animate(
			{
			height : "toggle"
			},
			'slow', function() {
				// アニメーション完了後に実行する処理
				// console.log("done");
				// console.log(this);
				// console.log($('.toggle-area').css('display'));
				if ($(this).parent().find('.archive-toggle-area').css('display') == 'block') {
					// console.log("block");
					$(this).parent().find('.month-toggle-trigger').text("▽");
				} else {
					$(this).parent().find('.month-toggle-trigger').text("▷");
					// console.log("none");
				}
			}
		);
	});
});




})();
