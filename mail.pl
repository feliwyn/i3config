#!/usr/bin/perl

# beginning of configuration

# pop3 host
$pop_host = "pop_server";

# pop3 username 
$pop_user = "usr_name";

# pop3 password
$pop_pass = "password";

# ssl port number
$ssl_port = "995";

# ssl protocol
$ssl_prot = "tcp";

# number of emails to show
$dis_numb = "5";

# end of configuration

use Mail::POP3Client;
use IO::Socket::SSL;

  my $socket = IO::Socket::SSL->new( PeerAddr => $pop_host,
                                     PeerPort => $ssl_port,
                                     Proto    => $ssl_prot);
  my $pop = Mail::POP3Client->new();
  $pop->User($pop_user);
  $pop->Pass($pop_pass);
  $pop->Socket($socket);
  $pop->Connect();

$msg_count = $pop->Count();

for ($i = $msg_count, $j = 0; $i >= $msg_count-($dis_numb-1); $i--, $j++) {
  foreach ( $pop->Head( $i ) ) {
    #/^(From|Subject):\s+/i and print $_, "\n";
    if ($_ =~ m/^From:/) {
      ($from) = ($_ =~ m#^From: .*<(.*)>#);
      $from = substr($from, 0, 30);
      $out .= "$j = $from\n";
    }
  }
  #chop $out;
  `echo -e "$out"> ~/.gmail/.gmail_top`;
}

$pop->Close();
