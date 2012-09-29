
# Chapter 0: ----------------------------------------------------------
# Headers and dependences ---------------------------------------------

# Chapter 1: ----------------------------------------------------------
# Input variables -----------------------------------------------------
#                                                                     #
#                                                                     #
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
# Variable validation -------------------------------------------------

# Chapter 3: ----------------------------------------------------------
# HTTP Request building -----------------------------------------------

# Chapter 4: ----------------------------------------------------------
# HTTP Request sending ------------------------------------------------

# Chapter 5: ----------------------------------------------------------
# Parsing HTTP response -----------------------------------------------

# Chapter 6: ----------------------------------------------------------
# Output communication info and end program ---------------------------