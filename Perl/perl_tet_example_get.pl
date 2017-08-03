=pod

GENERIC GET (sensors)

Author: Edwin Gonzalez Urzua (eddysheikan@GitHub)

This program performs an HTTP GET Request to obtain information
about sensors. The HTTP request is done manually

=cut

use warnings;
use LWP::UserAgent;
use Digest::SHA qw(hmac_sha256_base64); 
use POSIX qw(strftime);
 
# Time should be given as UTC in the format YYYY-MM-DDTHH:mm:ss+0000

sub getLoggingTime {

    my ($sec,$min,$hour,$mday,$mon,$year,$wday,$yday,$isdst)=gmtime(time);
    my $nice_timestamp = sprintf ( "%04d-%02d-%02dT%02d:%02d:%02d+0000",
                                   $year+1900,$mon+1,$mday,$hour,$min,$sec);
    return $nice_timestamp;
}

my $ua = LWP::UserAgent->new;
my $server_endpoint = "https://tetrationcluster.cisco.com";
my $resource = "/openapi/v1/sensors";
 
# Custom HTTP request header fields
$key = "000000000000000000000000000";
$secret="0000000000000000000000000000000";
$request="GET";
$tet_checksum = "";
$content_type = "application/json";
$timestamp = getLoggingTime();


$ua->ssl_opts( verify_hostname => 0 ,SSL_verify_mode => 0x00);

# Creating the HTTP Request as a GET.

my $req = HTTP::Request->new(GET => $server_endpoint.$resource);


# This is the API KEY

$req->header('Id' => $key);

# Optional - User-Agent (what kind of client is this)

$req->header('User-Agent' => 'Cisco Tetration REST API via Perl');

# Content-Type is JSON, as we expect to handle both req and resp this way

$req->header('Content-type' => $content_type);

# This header is used for POST/PUT. Mainly and to get the SHA256 digest
# In this case, it is not required for GET.

$req->header('X-Tetration-Cksum' => $tet_checksum);

# Timestamp

$req->header('Timestamp' => $timestamp);


# Authorization header comes from SHA256 HMAC Digest from the headers info.
# Note the format: (request)\n(resource)\n....

$all="$request\n$resource\n$tet_checksum\n$content_type\n$timestamp\n";
$digest=hmac_sha256_base64($all, $secret);

# Base64 Padding on Perl...

while (length($digest) % 4) {
    $digest .= '=';
}

$req->header('Authorization' => $digest);

print $req->status_line, "\n";
print $req->headers_as_string, "\n";

# Doing the request 

my $resp = $ua->request($req);
if ($resp->is_success) {
    my $message = $resp->decoded_content;
    print "Received reply: $message\n";
}
else {
    print "HTTP GET error code: ", $resp->code, "\n";
    print "HTTP GET error message: ", $resp->message, "\n";
}