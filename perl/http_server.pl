#!/bin/perl

use 5.040;
use strict;
use warnings;
use diagnostics;

# http client
# use HTTP::Tiny;
package Proxy {

    use HTTP::Server::Simple::CGI;
    use base qw(HTTP::Server::Simple::CGI);

    # A fundamental concept in HTTP servers is handlers. In Perl, we can define
    # our handlers as methods in our server class.

    my %dispatch = (
        '/hello' => \&resp_hello,
        # ...
    );

    sub handle_request {
        my ($self, $cgi) = @_;
        my $path = $cgi->path_info();
        my $handler = $dispatch{$path};

        if (ref($handler) eq "CODE") {
            print "HTTP/1.0 200 OK\r\n";
            $handler->($cgi);
        } elsif ($path eq '/headers') {
            print "HTTP/1.0 200 OK\r\n";
            print $cgi->header('text/plain');

            # This handler does something a little more sophisticated by reading
            # all the HTTP request headers and echoing them into the response body.
            foreach my $header ($cgi->http()) {
                print "$header: ", $cgi->http($header), "\n";
            }
        } else {
            print "HTTP/1.0 404 Not found\r\n";
            print $cgi->header('text/html'),
                  $cgi->start_html('Not found'),
                  $cgi->h1('Not found'),
                  $cgi->end_html;
        }
        say "";
        foreach my $header ($cgi->http()) {
            say STDERR "$header: ", $cgi->http($header);
        }

    }

    sub resp_hello {
        my $cgi  = shift;   # CGI.pm object
        return if !ref $cgi;

        my $who = $cgi->param('name');

        print $cgi->header,
              $cgi->start_html("Hello"),
              $cgi->h1("Hello $who!"),
              $cgi->end_html;
    }
}

# Create and run the server
my $port = 8080;
# my $server = HTTP::Server::Simple->new($port);
my $server = Proxy->new($port);
# print "Server running at http://localhost:$port/\n";
say "";
print `date +"%H:%M:%S: "` =~ s/\n//ri;
say "-----------------------------------------------------";
$server->run();

