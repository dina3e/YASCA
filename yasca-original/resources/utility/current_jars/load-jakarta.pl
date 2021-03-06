#!/usr/bin/perl

use LWP::Simple;

$url = ('http://archive.apache.org/dist/');
%version_list = ();
%file_list = ();

$max_scanned = 0;

#print is_newer_than("1.2", "1.4");		# false
#print is_newer_than("1.4", "1.2");		# true
#print is_newer_than("1.4", "1.4");		# false
#print is_newer_than("1.2.15", "1.2.9");		# true
#print is_newer_than("1.2.15", "1.3.0");		# false
#print is_newer_than("1.2.15", "1.3");		# false

scan($url);

foreach $file (keys %file_list) {
    print STDERR $file_list{$file} . "\n";
}

sub scan {

    my $current_url = shift;
    return unless $current_url =~ /^$url/;
    return if --$max_scanned == 0;

    print "$current_url\n";

    my @html = split(/\n/, get($current_url));
    foreach my $line (@html) {
	$line =~ /href=\"([^\"]+)\"/i;
	my $link = $1;
	if ($link =~ /\/$/) {
	    scan($current_url . $link);
	} elsif ($link =~ /(zip|gz)$/ && 
		 $link !~ /-src/ &&
                 $link !~ /-current/ &&
                 $link !~ /beta/i &&
                 $link !~ /alpha/i &&
		 $link !~ /^\d+\./) {
	    add_to_list($link);
#	    print "$link\n";
	}
    }
}

sub add_to_list {
    my $file = shift;
    if ($file =~ /(.*)-([\d\.]+).*\.zip/) {
	$filename = $1;
	$version = $2;

	if (is_newer_than($version, $version_list{$filename})) {
	    $version_list{$filename} = $version;
	    $file_list{$filename} = $file;
#    	    print "Changed latest version of $file to $version\n";
	}
    }
}

sub is_newer_than {
    my $x = shift;		# format 2.2
    my $y = shift;		# format 2.10 (should be later)

    my @xa = split(/\./, $x);
    my @ya = split(/\./, $y);

    for ($i=0; $i<scalar @xa; $i++) {
	$ya[$i] = 0 unless defined $ya[$i];
    }

    for ($i=0; $i<scalar @ya; $i++) {
	$xa[$i] = 0 unless defined $xa[$i];
    }

    for ($i=0; $i<scalar @xa; $i++) {
	return 1 if int($xa[$i]) > int($ya[$i]);
	return 0 if int($xa[$i]) < int($ya[$i]);
    }
    return 0;
}