public class TriggerAsignSixtyFive {

    public static void preventFrequentUpdates(List<Account> newList){

        Datetime nowTime = System.now();

        for(Account acc : newList){

            if(acc.LastModifiedDate != null){

                Long diffMillis = nowTime.getTime() - acc.LastModifiedDate.getTime();

                // Convert milliseconds → hours
                Double diffHours = diffMillis / (1000 * 60 * 60);

                if(diffHours < 1){
                    acc.addError('You cannot update this Account within 1 hour of last modification.');
                }
            }
        }
    }
    
}