use strict;
use warnings;
use utf8;
use File::Spec;
use File::Basename;
use lib File::Spec->catdir(dirname(__FILE__), 'lib');
use Encode;
use Encode::UTF8Mac;
use Getopt::Long;
use LWP::UserAgent;

my ($url, $apikey, $content);
GetOptions (
    'url=s'     => \$url,
    'apikey=s'  => \$apikey,
    'content=s' => \$content,
);

$url =~ s{/+$}{};
$content = decode('utf-8-mac', $content);

my $ua = LWP::UserAgent->new(
    agent   => 'GTDme Alfred Inbox Extension/0.01',
    timeout => 30,
);

my $res = $ua->post(
    "${url}/api/inbox/post",
    {
        apikey  => $apikey,
        content => $content,
    },
);

my $msg;

### 200
if ( $res->code eq '200' ) {
    $msg = '[OK] ' . encode_utf8($content);
}
### non-200
else {
    $msg = '[ERROR] ' . $res->status_line;
}

print $msg;
__END__
