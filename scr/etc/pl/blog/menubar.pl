
use utf8;
package sub::blog;
sub menubar {
	my $DIR = $_[0];

print <<'EOM';
<nav class="PC" id="menubar">
	<div class="clearfix w960">
		<div class="left">
EOM
	print 	'<a href="'.$DIR.'"><img class="logo" src="'.$DIR.'img/Logo_blog.png"></a>', "\n";
print <<'EOM';
		</div>
		<div class="left">
			<ul>
			<li><a href="/">BLOGGER HP</a></li>
			<li><a href="/blog/">BLOG TOP</a></li>
			<li><a href="/blog/about.cgi">ABOUT BLOG</a></li>
			</ul>
		</div>
	</div>
</nav>
EOM

	return;
}



1;

