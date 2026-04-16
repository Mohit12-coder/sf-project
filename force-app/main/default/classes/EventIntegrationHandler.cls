public class EventIntegrationHandler {
    public static void handleAfterInsert(List<Event> newEvents) {
        List<Id> eventIds = new List<Id>();

        for (Event ev : newEvents) {
            // yahan aap apni condition laga sakte ho
            // example: only if Google_Calendar_Status__c is blank
            eventIds.add(ev.Id);
        }

        if (!eventIds.isEmpty()) {
            System.enqueueJob(new GoogleCalendarQueueable(eventIds));
        }
    }
}