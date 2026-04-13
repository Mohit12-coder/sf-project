public class TriggerAsignTwentyFive {
    
    public static void copyBillingToShipping(List<Account> newAccounts){

        for(Account acc : newAccounts){

            acc.ShippingStreet = acc.BillingStreet;
            acc.ShippingCity = acc.BillingCity;
            acc.ShippingState = acc.BillingState;
            acc.ShippingPostalCode = acc.BillingPostalCode;
            acc.ShippingCountry = acc.BillingCountry;

        }

    }
    
}