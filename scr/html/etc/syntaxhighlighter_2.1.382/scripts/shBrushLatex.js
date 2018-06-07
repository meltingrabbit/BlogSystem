/**
 * SyntaxHighlighter LaTeX Brush by DiGMi
 * http://digmi.org
 *
 * Used for SyntaxHighlighter which can be found at:
 * http://alexgorbatchev.com/SyntaxHighlighter
 *
 * @version
 * 1.0.0 (July 21 2012)
 * 
 * @copyright
 * Copyright (C) 2012 Or Dagmi.
 */
 
;(function()
{
	typeof(require) != 'undefined' ? SyntaxHighlighter = require('shCore').SyntaxHighlighter : null;

	function Brush()
	{
		var keywords =	'if fi then elif else for do done until while break continue case function return in eq ne gt lt ge le';
		var specials =  'include usepackage begin end ref label includegraphics';

		this.regexList = [

			{ regex: /%.*$/gm,
			    css: 'comments' },

			{ regex: /\$[\s\S]*?\$/gm,
			    css: 'string' },

			{ regex: /\\\w+/gm, // Command
			    css: 'keyword' },
            
            { regex: /\{.*}/gm, // Parameter
			    css: 'color2' },
            { regex: /\[.*]/gm, // Optional Parameter
			    css: 'color3' },

			{ regex: new RegExp(this.getKeywords(specials), 'gm'), css: 'color3' },
			{ regex: new RegExp(this.getKeywords(keywords), 'gm'), css: 'keyword' }
		];
	};

	Brush.prototype = new SyntaxHighlighter.Highlighter();
	Brush.aliases = ['latex'];

	SyntaxHighlighter.brushes.LaTeX = Brush;

	typeof(exports) != 'undefined' ? exports.Brush = Brush : null;
})();
