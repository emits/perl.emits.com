#!/usr/bin/perl

use HTTP::Lite;
use HTML::TreeBuilder;
use LWP::UserAgent;


my $line;
my $flg = 0;


my $url = "";

#  ファイルリストの情報取得
open (FILE, "<./list.txt");
my @list = <FILE>;
close(FILE);

open(OUT, ">./out/meta.txt") or die;

# URLごとに処理を実行
foreach(@list){
	my $url = $_;
	$url =~s/¥n//g;
	print "$url.¥n";

	print OUT "$url¥t";

	# HTML取得
	my $ua = LWP::UserAgent->new;
	my $req = HTTP::Request->new(GET => $url);
	$req->authorization_basic("cmsadmin", "ncom");

	my $body = $ua->request($req)->as_string;
	my $tree = HTML::TreeBuilder->new;
	$body =~ s/&nbsp;/ /g;
	$tree->parse($body);


	# description
	if (my $description = $tree->look_down("name", 'description')){
	#	print $attr->as_HTML(q{"&}, "¥t", {});
		print $description->attr('content'),"¥n";
		print OUT $description->attr('content'),"¥t";
	}
	else {
		print OUT "¥t";
	}

	# keyword
	if ($keyword = $tree->look_down("name", 'keywords')){
	#	print $attr->as_HTML(q{"&}, "¥t", {});
		print $keyword->attr('content'),"¥n";
		print OUT $keyword->attr('content'),"¥t";
	}
	else {
		print OUT "¥t";
	}

	# title
	if ($title = $tree->find("title")){
		print $title->as_text(), "¥n";
		print OUT $title->as_text(), "¥t";
	}
	else {
		print OUT "¥t";
	}

	# H1
	if ($h1 = $tree->look_down("_tag", 'h1')){
		print $h1->as_text(), "¥n";
		print OUT $h1->as_text();
	}

	print OUT "¥n";

	$tree = $tree->delete;

}

close(OUT);

exit;


