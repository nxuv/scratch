#!/bin/perl

use 5.040;
use strict;
use warnings;
use diagnostics;

# http client
# use HTTP::Tiny;
use HTTP::Proxy;
use HTTP::Proxy::BodyFilter::simple;
# use IO::Socket::SSL;

say "";
print `date +"%H:%M:%S: "` =~ s/\n//ri;
say "-----------------------------------------------------";

# my $port = 3128;
# # initialisation
# my $proxy = HTTP::Proxy->new( port => 8080 );
#
# package FilterPerl {
#     use base qw( HTTP::Proxy::BodyFilter );
#     sub filter {
#         my ( $self, $dataref, $message, $protocol, $buffer ) = @_;
#         $dataref =~ s/./E/g;
#     }
# }
# $proxy->push_filter( response => FilterPerl->new() );
#
# # this is a MainLoop-like method
# $proxy->start;

my $proxy = HTTP::Proxy->new(
    engine => 'Threaded',
    port => 8080,
    max_keep_alive_requests => 0,
    host =>'127.0.0.1',
    timeout => 120
);

$proxy->push_filter(
    # mime => 'text/html',
    response => HTTP::Proxy::BodyFilter::simple->new(sub {
        # my ($self, $headers, $response) = @_;
        # return unless $response->content_type eq 'text/html';
        # my $content = $response->content;
        # $content =~ s/o/E/sg;
        # $response->content($content)
        my ($self, $dataref, $message, $protocol, $buffer) = @_;

        foreach my $header ($message->headers) {
            say STDERR "$header: ";
        }

        # say STDERR "$$dataref";
        $$dataref =~ s/<p\s?.*?>.*?<\/p>/<h2>THIS IS ANIME POLICE<\/h2>/gmis;
    })
);

$proxy->start;
