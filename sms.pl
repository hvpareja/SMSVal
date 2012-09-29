
# Chapter 0: ----------------------------------------------------------
# Headers, dependences and options ------------------------------------
# You can choose between the following actions:
# 1. Send a new message
# 2. Check status for a given message (order_id needed - see below -)
# 3. Cancel a programed sending
# 4. View message history
# 5. Check the remaining credit
# For future versions we will be able to (6.) receive SMS, but not yet
# ---------------------------------------------------------------------

# Chapter 1: ----------------------------------------------------------
# Input variables -----------------------------------------------------
# Constant parameters                                                 #
 my $base_url="http://www.smstrend.net/Trend/";# Provider base url    #  
 my %opts_url=(          # url for the choosen option:                #
                "send"    => "SENDSMS",          # Opt 1. New message #
                "status"  => "SMSSTATUS",        # Opt 2. View status #
                "cancel"  => "REMOVE_DELAYED",   # Opt 3. Cancel      #
                "history" => "SMSHISTORY",       # Opt 4. History     #
                "credit"  => "CREDITS"           # Opt 5. Credit      #  
               );                                                     #
# Mandatory variables:                                                #
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
# Optional variables                                                  #  
 my $sheduled_delivery_time;  # Date and time to delivery the message #
                              # Format: yyyyMMddHHmmss                #
                                                                      #  
 my $order_id;                # You can customize an unique order id  # 
                              # to track the message: maximum 32 char #  
#                                                                     #
#                                                                     #
# ---------------------------------------------------------------------

# Chapter 2: ----------------------------------------------------------
# Variable assignation ------------------------------------------------
# Assign variable values from config file or arguments
# 2.1  Take params from config and or arguments
    my $choosen_option = "";
# 2.2. Build the complete url depending on the option choosen
    my $url = $base_url.$opts_url{$choosen_option};
# ---------------------------------------------------------------------

# Chapter 3: ----------------------------------------------------------
# Variable validation -------------------------------------------------
# $error = 0 if no error and 1 if error
    my $error = 0;
    my $error_message = "";
#   1. Is $choosen_option between the allowed options?
    if($opts_url{$choosen_option} eq ""){
        $error_message.="Invalid option \"$choosen_option\"\n";
        $error = 1;
    }
#   2. Is $login not empty?
    if($login eq ""){
        $error_message.="Not username defined\n";
        $error = 1;
    }
#   3. Is $password not empty?
    if($password eq ""){
        $error_message.="No password defined\n";
        $error = 1;
    }
#   4. Is $message_type not empty and well formed (GP or GS)?
    $message_type = uc($message_type); # Turn in upper case
    if($message_type ne "GP" || $message_type ne "GS"){
        $error_message.="Invalid message type:\"$message_type\"\n";
        $error = 1;
    }
#   5. Is $message length greater than 1 and lower than 1000?
    my $msg_length = length($message);
    if($msg_length > 1000){
        $error_message.="Too many characters in the message\n";
        $error = 1;
    }
    if($msg_length eq ""){
        $error_message.="Message not defined\n";
        $error = 1;
    }
#   6. Is $recipient a valid phone number?
    if(!grep(/^\(?([0-9]{3})\)?[-. ]?([0-9]{3})[-. ]?([0-9]{4})$/,$recipient)){
        $error_message.="Invalid recipient: \"$recipient\"\n";
        $error = 1;
    }
#   7. Is $sender well formed (phone or short varchar (11))?
#   8. If $sheduled_delivery_time is not empty, it is well formated?
    if($sheduled_delivery_time ne ""){
        if(grep(/^2[0-9][0-9][0-9][0-1][0-9][0-3][0-9][0-2][0-9][0-6][0-9][0-6][0-9]$/,$sheduled_delivery_time)){
            my $year = substr($sheduled_delivery_time,0,4);
            my $month = substr($sheduled_delivery_time,0,4);
            my $day = substr($sheduled_delivery_time,0,4);
            my $hour = substr($sheduled_delivery_time,0,4);
            my $minute = substr($sheduled_delivery_time,0,4);
            my $second = substr($sheduled_delivery_time,0,4);
        }else{
            $error_message.="Sheduled delivery time bad formed (must be: yyyyMMddHHmmss).\n";
            $error = 1;
        }
    }
#   9. Is $order_id length lower than 32 char?
    if(length($order_id) > 32){
        $error_message.="Order id too long, max. 32 chars.\n";
        $error = 1;
    }
# If there is an error, show the error message and exit:
    if($error){
        print "Folowwing error/s found:\n";
        print $error_message;
        exit;
    }
# ---------------------------------------------------------------------

# Chapter 4: ----------------------------------------------------------
# HTTP Request building -----------------------------------------------
# Build HTTP headers
# ---------------------------------------------------------------------

# Chapter 5: ----------------------------------------------------------
# HTTP Request sending ------------------------------------------------
# Send the petition and wait for response
# ---------------------------------------------------------------------

# Chapter 6: ----------------------------------------------------------
# Parsing HTTP response -----------------------------------------------
# Once we have the response, read it and interpret the results
# ---------------------------------------------------------------------

# Chapter 7: ----------------------------------------------------------
# Output communication info and end program ---------------------------
# Put in standar output the interpetation (failed and why or success)
# ---------------------------------------------------------------------
