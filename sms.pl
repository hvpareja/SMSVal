#!/usr/bin/perl -w
no warnings;
# Chapter 0: ----------------------------------------------------------
# Headers, dependences and options ------------------------------------
# You can choose between the following actions:
# 1. Send a new message
# 2. Check status for a given message (order_id needed - see below -)
# 3. Cancel a programed sending
# 4. View message history
# 5. Check the remaining credit
# 6. Configure SMSTrend account
# For future versions we will be able to (7.) receive SMS, but not yet

# 0.1 Headers
# Library to handle HTTP packets
use HTTP::Request::Common qw(POST);
# User Agent definition to send HTTP request
use LWP::UserAgent;
# ---------------------------------------------------------------------











# Chapter 1: ----------------------------------------------------------
# Input variables -----------------------------------------------------
# Constant parameters                                                 #
 my $base_url="https://www.smstrend.net/Trend/";# Provider base url   #  
 my %opts_url=(          # url for the choosen option:                #
                "SEND"    => "SENDSMS",          # Opt 1. New message #
                "STATUS"  => "SMSSTATUS",        # Opt 2. View status #
                "CANCEL"  => "REMOVE_DELAYED",   # Opt 3. Cancel      #
                "HISTORY" => "SMSHISTORY",       # Opt 4. History     #
                "CREDIT"  => "CREDITS",          # Opt 5. Credit      #
                "CONFIG"  => "NO_URL"            # Opt 6. Config      #  
               );                                                     #
 my $login;              # Login: User name for SMSTrend              #
                                                                      #
 my $password;           # Password: Password for SMSTrend account    #
                                                                      #
 my $message_type;       # Message Type: GS (without customized       #
                         # sender) or GP (with customized sender)     #
                                                                      #  
 my $message;            # Message to send. Maximum 160 char per      #
                         # message or maximum 1000 char for           #
                         # concatenated messages. The following chars #
                         # count as two chars: ^ { } \[ ~ ] | Û;      #
                                                                      #  
 my $recipient;          # Target phone number with country prefix:   #
                         # +34610123456 or 0034610123456              #
                                                                      #  
 my $sender;             # If message_type = GP, then, you can        #  
                         # customize the remitent by this way:        #  
                         # 1. Phone number with 16 number max.        #
                         # 2. Alphanumeric string wiht 11 char max.   #
                                                                      #
 my $sheduled_delivery_time;  # Date and time to delivery the message #
                              # Format: yyyyMMddHHmmss                #
                                                                      #  
 my $order_id;                # You can customize an unique order id  # 
                              # to track the message: maximum 32 char #
 my $from;              # From date to view history                   #
 my $to;                # To date to view history                     #
                        # Format: yyyyMMddHHmmss                      #
#                                                                     #
#                                                                     #
# ---------------------------------------------------------------------












# Chapter 2: ----------------------------------------------------------
# Variable assignation ------------------------------------------------
# Assign variable values from config file or arguments
# 2.1 Open config file (if exists) and load params
    open CONF, "config.txt";
    # Eval each param in config file
    for $line (<CONF>){ eval($line); }
    
# 2.2  Take params from config and or arguments
    my $choosen_option = uc($ARGV[0]);
    # To send a message:
    # sms send <recipient> <message> [<sheduled_delivery_time> <order_id>]
    if($choosen_option eq "SEND"){
        $recipient              = $ARGV[1];
        $message                = $ARGV[2];
        $sheduled_delivery_time = $ARGV[3];
        $order_id               = $ARGV[4];
    }
    # To view the status for a sheduled message:
    # sms status <order_id>
    # To cancel a sheduled message:
    # sms cancel <order_id>
    if($choosen_option eq "STATUS" || $choosen_option eq "CANCEL"){
        $order_id               = $ARGV[1];
    }
    # To config user account
    # sms config <user@mail> <password> <message_type> <sender>
    if($choosen_option eq "CONFIG"){
        $login                  = $ARGV[1];
        $password               = $ARGV[2];
        $message_type           = $ARGV[3];
        $sender                 = $ARGV[4];
    }
    # To view history
    # sms history <from> <to>
    if($choosen_option eq "HISTORY"){
        $from                   = $ARGV[1];
        $to                     = $ARGV[2];
    }
# 2.3. Build the complete url depending on the option choosen
    my $url = $base_url.$opts_url{$choosen_option};
# ---------------------------------------------------------------------












# Chapter 3: ----------------------------------------------------------
# Variable validation -------------------------------------------------
# $error = 0 if no error and 1 if error
    my $error = 0;
    my $error_message = "";
#   1. Is $choosen_option between the allowed options?
    if($opts_url{$choosen_option} eq ""){
        $error_message.=" Invalid option \"$choosen_option\"\n";
        $error = 1;
    }
# 3.1 MODE SEND -------------------------------------------------------
if($choosen_option eq "SEND"){
#   2. Is $login not empty?
    if($login eq ""){
        $error_message.=" No username defined\n";
        $error = 1;
    }
#   3. Is $password not empty?
    if($password eq ""){
        $error_message.=" No password defined\n";
        $error = 1;
    }
#   4. Is $message_type not empty and well formed (GP or GS)?
    $message_type = uc($message_type); # Turn in upper case
    if($message_type ne "GP" and $message_type ne "GS"){
        $error_message.=" Invalid message type:\"$message_type\"\n";
        $error = 1;
    }
#   5. Is $message length greater than 1 and lower than 1000?
    my $msg_length = length($message);
    if($msg_length > 1000){
        $error_message.=" Too many characters in the message\n";
        $error = 1;
    }
    if($message eq ""){
        $error_message.=" Message not defined\n";
        $error = 1;
    }
#   6. Is $recipient a valid phone number?
    if($recipient eq ""){
        $error_message.=" Invalid or empty recipient: $recipient\n";
        $error = 1;
    }
#   7. Is $sender well formed (phone or short varchar (11))?
    if($sender eq ""){
        $error_message.=" Invalid sender\n";
        $error = 1;
    }
#   8. If $sheduled_delivery_time is not empty, it is well formated?
    if($sheduled_delivery_time ne ""){
        if(grep(/^2[0-9][0-9][0-9][0-1][0-9][0-3][0-9][0-2][0-9][0-6][0-9][0-6][0-9]$/,$sheduled_delivery_time)){
            my $year = substr($sheduled_delivery_time,0,4);
            my $month = substr($sheduled_delivery_time,4,2);
            my $day = substr($sheduled_delivery_time,6,2);
            my $hour = substr($sheduled_delivery_time,8,2);
            my $minute = substr($sheduled_delivery_time,10,2);
            my $second = substr($sheduled_delivery_time,12,2);
            # Current date and time
            my @localtime = localtime(time);
            if($year < $localtime[5]){
                $error_message.=" Invalid year\n";
                $error = 1;
            }
            if($year > ($localtime[5]+100+1900)){
                $error_message.=" Invalid year\n";
                $error = 1;
            }
            if($month < 1 or $month > 12){
                $error_message.=" Invalid month\n";
                $error = 1;
            }
            if($day < 1 or $day > 31){
                $error_message.=" Invalid day\n";
                $error = 1;
            }
            if($hour > 23){
                $error_message.=" Invalid hour\n";
                $error = 1;
            }
            if($minute > 60){
                $error_message.=" Invalid minute\n";
                $error = 1;
            }
            if($second > 60){
                $error_message.=" Invalid second\n";
                $error = 1;
            }
            print "Message sheduled for $day/$month/$year $hour:$minute:$second\n";
        }else{
            $error_message.=" Sheduled delivery time bad formed (must be: yyyyMMddHHmmss).\n";
            $error = 1;
        }
    }
#   9. Is $order_id length lower than 32 char?
    if(length($order_id) > 32){
        $error_message.=" Order id too long, max. 32 chars.\n";
        $error = 1;
    }
}
# 3.2 MODE STATUS OR CANCEL -------------------------------------------
if($choosen_option eq "STATUS" || $choosen_option eq "CANCEL"){
    if($order_id eq ""){
        $error_message.=" Please, enter an order id\n";
        $error = 1;
    }
}
# 3.3 MODE CONFIG -----------------------------------------------------
if($choosen_option eq "CONFIG"){
    if($login eq ""){
        $error_message.=" Invalid or empty username\n";
        $error = 1;
    }
    if($password eq ""){
        $error_message.=" Invalid or empty password\n";
        $error = 1;
    }
    if(uc($message_type) ne "GP" and uc($message_type) ne "GS"){
        $error_message.=" Invalid or empty message type: $message_type\n";
        $error = 1;
    }
    if($sender eq ""){
        $error_message.=" Invalid or empty sender\n";
        $error = 1;
    }
}
# 3.4 MODE CREDIT -----------------------------------------------------
if($choosen_option eq "CREDIT"){
    if($login eq ""){
        $error_message.=" Invalid or empty username\n";
        $error = 1;
    }
    if($password eq ""){
        $error_message.=" Invalid or empty password\n";
        $error = 1;
    }
}
# 3.5 MODE HISTORY ----------------------------------------------------
if($choosen_option eq "HISTORY"){
    if($login eq ""){
        $error_message.=" Invalid or empty username\n";
        $error = 1;
    }
    if($password eq ""){
        $error_message.=" Invalid or empty password\n";
        $error = 1;
    }
    if($from eq ""){
        $error_message.=" Invalid 'from' date\n";
        $error = 1;
    }
    if($to eq ""){
        $error_message.=" Invalid 'to' date\n";
        $error = 1;
    }
}
# 3.6 ERROR REPORTING -------------------------------------------------
# If there is an error, show the error message and exit:
    if($error){
        print "-----------------------\n";
        print "Following error/s found:\n";
        print "=======================\n";
        print $error_message;
        print "-----------------------\n";
        exit;
    }
# ---------------------------------------------------------------------
















# Chapter 4: ----------------------------------------------------------
# Config SMSTrend account ---------------------------------------------
if($choosen_option eq "CONFIG"){
    # Write a file with login, password, sender and message type
    # Params preparation
    $login =~ s/@/\\@/g; 
    my $field_login        = "\$login=\"".$login."\"";
    my $field_pass         = "\$password=\"".$password."\"";
    my $field_sender       = "\$sender=\"".$sender."\"";
    my $field_message_type = "\$message_type=\"".$message_type."\"";
    # File creation
    open CONF, ">config.txt" or die(" Unable to write config.txt");
    # File writting
    print CONF $field_login.";\n";
    print CONF $field_pass.";\n";
    print CONF $field_sender.";\n";
    print CONF $field_message_type.";\n";
    # File closing
    close CONF;
    # Ending program
    exit;
}
# ---------------------------------------------------------------------












# Chapter 5: ----------------------------------------------------------
# HTTP Request building -----------------------------------------------
# Build HTTP headers
my $ua  = LWP::UserAgent->new();
my $req = POST($url, [
                      "login"         => $login,
                      "password"      => $password,
                      "sender"        => $sender,
                      "message_type"  => $message_type,
                      "recipient"     => $recipient,
                      "message"       => $message,
                      "scheduled_delivery_time"   => $sheduled_delivery_time,
                      "order_id"                 => $order_id,
                      "from"                     => $from,
                      "to"                       => $to
                      ]);
# ---------------------------------------------------------------------






# Chapter 6: ----------------------------------------------------------
# HTTP Request sending ------------------------------------------------
# Send the petition and wait for response
my $response = $ua->request($req)->as_string();
# ---------------------------------------------------------------------





# Chapter 7: ----------------------------------------------------------
# Parsing HTTP response -----------------------------------------------
# Once we have the response, read it and interpret the results
$response =~ s/;/\n/g;
$response =~ s/\|/\t/g;
# ---------------------------------------------------------------------




# Chapter 8: ----------------------------------------------------------
# Output communication info and end program ---------------------------
# Put in standar output the interpetation (failed and why or success)
print $response;
exit;
# ---------------------------------------------------------------------
