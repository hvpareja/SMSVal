
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
# ---------------------------------------------------------------------

# Chapter 3: ----------------------------------------------------------
# Variable validation -------------------------------------------------
#   1. Is $login not empty?
#   2. Is $password not empty?
#   3. Is $message_type not empty and well formed (GP or GS)?
#   4. Is $message length greater than 1 and lower than 1000?
#   5. Is $recipient a valid phone number?
#   6. Is $sender well formed (phone or short varchar (11))?
#   7. If $sheduled_delivery_time is not empty, it is well formated?
#   8. Is $order_id length lower than 32 char?
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
