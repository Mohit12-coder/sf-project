public class TriggerAsignEightyNine {

    public static void validateAmount(List<Opportunity> oppList){

        for(Opportunity opp : oppList){

            if(opp.Amount != null && opp.Amount < 10000){
                opp.addError('Opportunity Amount must be at least 10,000');
            }
        }
    }
    
}