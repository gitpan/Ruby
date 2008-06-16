#!perl -MRuby::Run

Perl.eval('use LWP');

ua = Perl["LWP::UserAgent"].new

req = Perl["HTTP::Request"].new "HEAD",  "http://www.example.com".to_perl;

puts "HEAD #{req.uri}";

res = ua.request(req)

puts res.headers.as_string
^