    ------------------------------- SMSVal ---------------------------
                                Hector Valverde
                            www.hectorvaverde.com
    ------------------------------------------------------------------
                
        SMSVal is an interface developped by Hector Valverde that
    connects your computer to the servers of One-etere SMSTrend. You
    can send SMS from your personal computer or server easily.

    INSTALLATION

    	The source code is just an script (interpreted code) so you don't 
    need to compile it. Only that you need is Perl.

    	To call the program from any path in your system you can move the
    script to the /usr/bin path:

    	$ sudo cp sms.pl /usr/bin/sms

   	Also, if you don't want to install this script in your system, you
    can execute it as following:

   	$ perl sms.pl

 	Be sure the file has execution permission. 
    
    CONFIGURATION:
    
       	Before use the program you must tossing up in SMSTrend 
    (http://public.smstrend.net/) and configure your login data as following:
    
    	$ sms config <username> <password> <message_type> <sender>
    
    USAGE
    
    	$ sms <option> [<arguments]
    
    OPTIONS
    
        cancel <order_id>
                    - Cancel a scheduled sms given an order id
        config <username> <password> <message_type> <sender>
                    - Set up your login data, and params for SMSTrend
        credit
                    - Show remaining credit
        help
                    - Show this text
        history <fromDate> <toDate>
                    - View sent messages between two dates
        send <recipient> <message> [<scheduledDate> <order_id>]
                    - Send a single sms
        status <order_id>
                    - View the status of a scheduled sms
    
    ARGUMENTS
    
        <fromDate>          - Date with format: yyyyMMddhhmmss
        <login>             - Your SMSTrend username
        <message>           - Message to send
        <message_type>      - GP or GS (depends on your account settings)
        <order_id>          - Id string for a given sms
        <password>          - Your SMSTrend password
        <recipient>         - A phone number to send the SMS, e.g.:
                              +34610123456 or 0034605447804
        <sender>            - A phone number or alphanumeric short string
                              only if message_type = GP
        <scheduledDate>     - Date with format: yyyyMMddhhmmss
        <toDate>            - Date with format: yyyyMMddhhmmss

    EXAMPLES
    
        1. Send a single message:
            $ sms send +34610123456 "This is the message"
        2. Scheduled a message for 25th June 2013 at 15:30:00 and
           identificate it with the name "hvSMS":
            $ sms send +34610123456 "Happy birthday, Hector" 20130625153000 hvSMS
        3. View the status of a scheduled SMS
            $ sms status hvSMS
        4. Cancel a scheduled SMS
            $ sms cancel hvSMS
        5. View your credit
            $ sms credit
        6. View your message history between two dates   
            $ sms history 20120625153000 20121125153000
            
    BUGS
    
        If you find any bug, please, send an email to hvalverde@uma.es