use strict;
use warnings;
use utf8;
use Encode;
use Getopt::Long;
use LWP::UserAgent;

my ($url, $apikey, $content);
GetOptions (
    'url=s'     => \$url,
    'apikey=s'  => \$apikey,
    'content=s' => \$content,
);

my $encode = find_encoding('utf-8');

$url =~ s{/+$}{};
$content = $encode->decode($content);

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
    $msg = '[OK] ' . $encode->encode($content);
}
### non-200
else {
    $msg = '[ERROR] ' . $res->status_line;
}

print $msg;
__END__
