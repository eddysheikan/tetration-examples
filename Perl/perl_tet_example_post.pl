=pod

GENERIC POST (flowsearch)

Author: Edwin Gonzalez Urzua (eddysheikan@GitHub)

This program performs an HTTP POST Request to obtain information
about flowsearch. The HTTP request is done manually

=cut

use warnings;
use LWP::UserAgent;
use Digest::SHA qw(hmac_sha256_base64); 
use Digest::SHA qw(sha256_hex);
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
my $resource = "/openapi/v1/flowsearch";
 
# Set custom HTTP request header fields
$key = "00000000000000000000000000000000";
$secret="00000000000000000000000000000000000000";
$request="POST";
$tet_checksum = "";
$content_type = "application/json";
$timestamp = getLoggingTime();

# body should be given in normal JSON format as a String. Note the Content-Type is
# set to "application/json" 
$body = '{
    "filter": {
        "type": "or",
        "filters": [
            
            {
                "type": "contains",
                "field": "src_hostname",
                "value": "tet-db"
            }
        ]
    },
    "scopeName": "default",
    "limit": 2,
    "t0": "2017-07-24T00:00:00-0000",
    "t1": "2017-07-25T00:00:00-0000"
}';

$ua->ssl_opts( verify_hostname => 0 ,SSL_verify_mode => 0x00);

my $req = HTTP::Request->new(POST => $server_endpoint.$resource);


# This is the API KEY

$req->header('Id' => $key);

# Optional - User-Agent (what kind of client is this)

$req->header('User-Agent' => 'Cisco Tetration REST API via Perl');

# Content-Type is JSON, as we expect to handle both req and resp this way

$req->header('Content-type' => $content_type);

# This header is used for POST/PUT. Get the Body from the Request and get the
# SHA256 digest. Use it as the X-Tetration-Cksum Header value.

$tet_checksum = sha256_hex($body);
$req->header('X-Tetration-Cksum' => $tet_checksum);

# Timestamp

$req->header('Timestamp' => $timestamp);

# Body for the Flow Search Query

$req->content($body);

# Authorization header comes from SHA256 HMAC Digest from the headers info.
# Note the format: (request)\n(resource)\n....

$all="$request\n$resource\n$tet_checksum\n$content_type\n$timestamp\n";
$digest=hmac_sha256_base64($all, $secret);

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