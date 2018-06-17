/**
 * SyntaxHighlighter
 * http://alexgorbatchev.com/SyntaxHighlighter
 *
 * SyntaxHighlighter is donationware. If you are using it, please donate.
 * http://alexgorbatchev.com/SyntaxHighlighter/donate.html
 *
 * @version
 * 3.0.83.1 (Jan 30 2013)
 *
 * @auther
 * Yohei (logroid)
 *
 * @copyright
 * Copyright (C) 2004-2010 Alex Gorbatchev.
 *
 * @license
 * Dual licensed under the MIT and GPL licenses.
 */
;(function()
{
	// CommonJS
	typeof(require) != 'undefined' ? SyntaxHighlighter = require('shCore').SyntaxHighlighter : null;

	function Brush()
	{
		var device =	'nul con prn lpt\\d com\\d'
						;
		var operator =	'EQU NEQ LSS LEQ GTR GEQ NOT DEFINED EXIST'
						;
		var keywords =	'attr comp x?copy dir del erase expand fc find findstr more move print recover rename ren replace sort tree type '+ // file
						'chdir cd chkdsk cipher compact convert defrag diskcopy diskcomp diskpart format label mkdir md mountvol pushd popd rmdir rd subst verify vol '+ // directory disk
						'arp ftp getmac ipconfig nbtstat net netstat nslookup ping route telnet tlntadmn tracert pathping '+ // network
						'assoc at bootcfg cacls chcp chkntfs cls color cscript date time doskey echo exit ftype help hostname mem mode path prompt reg runas sc schtasks set shutdown start systeminfo taskkill tasklist title var '+ // setting system
						'pause if else goto call for in do each shift setlocal endlocal' // batch
						;

		var r = SyntaxHighlighter.regexLib;
		
		this.regexList = [
			{ regex: SyntaxHighlighter.regexLib.doubleQuotedString,	css: 'string' },    // strings
			{ regex: SyntaxHighlighter.regexLib.singleQuotedString,	css: 'string' },    // strings
			{ regex: /^\s*rem\s(?:.+)?/gmi,							css: 'comments' },			// one line comments
			{ regex: new RegExp(this.getKeywords(device), 'gi'),	css: 'variable' },			// device
			{ regex: /%(?:~?(?:f|d|p|dp|n|x|nx|s|fs|a|t|z)?\d|[\d*]|%[a-z])/gi,	css: 'variable' },			// argument
			{ regex: /%[^%\s]+%/gi,	css: 'variable' },			// variable
			{ regex: /![^!\s]+!/gi,	css: 'variable' },			// delayed variable
			{ regex: /^:[^\s]{1,8}/gm,	css: 'color1' },			// label
			{ regex: new RegExp(this.getKeywords(operator), 'gi'),	css: 'color2' },			// operator
			{ regex: new RegExp(this.getKeywords(keywords), 'gi'),	css: 'keyword' }			// keywords
			];
	
		this.forHtmlScript(r.scriptScriptTags);
	};

	Brush.prototype	= new SyntaxHighlighter.Highlighter();
	Brush.aliases	= ['bat', 'cmd', 'com'];

	SyntaxHighlighter.brushes.Cmd = Brush;

	// CommonJS
	typeof(exports) != 'undefined' ? exports.Brush = Brush : null;
})();
