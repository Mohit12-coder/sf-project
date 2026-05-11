public without sharing class AuthController {

    @AuraEnabled
    public static void sendOTP(String email, String otp) {

        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        mail.setToAddresses(new String[]{email});
        mail.setSubject('Your OTP Code');
        mail.setPlainTextBody('Your OTP is: ' + otp);
        mail.setOrgWideEmailAddressId('0D2gL0000002yMfSAI');
        Messaging.sendEmail(new Messaging.SingleEmailMessage[]{mail});
    }

    @AuraEnabled
    public static String registerAfterOTP(String name, String email, String password) {

        if (password.length() < 8) {
            throw new AuraHandledException('Password must be at least 8 characters');
        }

        if (!Pattern.matches('.*[A-Z].*', password)) {
            throw new AuraHandledException('Password must contain uppercase letter');
        }

        if (!Pattern.matches('.*[0-9].*', password)) {
            throw new AuraHandledException('Password must contain number');
        }

        if (!Pattern.matches('.*[^a-zA-Z0-9].*', password)) {
            throw new AuraHandledException('Password must contain special character');
        }

        try {
            List<User> existing = [SELECT Id FROM User WHERE Username = :email + '.portal'];
            if (!existing.isEmpty()) {
                throw new AuraHandledException('User already exists');
            }

        
            Account acc = new Account(Name = name, Status__c = 'Active');
            insert acc;


            Contact con = new Contact(
                LastName = name,
                Email = email,
                AccountId = acc.Id
            );
            insert con;

        
            Profile p = [ SELECT Id FROM Profile WHERE Name = 'Customer Community Login User' LIMIT 1 ];

            User u = new User(
                Username = email + '.portal',
                Email = email,
                LastName = name,
                Alias = name.length() > 4 ? name.substring(0,4) : name,
                CommunityNickname = name.replaceAll('\\s+', '') + Math.round(Math.random()*1000),
                TimeZoneSidKey = 'Asia/Kolkata',
                LocaleSidKey = 'en_US',
                EmailEncodingKey = 'UTF-8',
                LanguageLocaleKey = 'en_US',
                ProfileId = p.Id,
                ContactId = con.Id
            );

            String userId = Site.createExternalUser(u, acc.Id, password);

            return userId;


        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
        
    }
}