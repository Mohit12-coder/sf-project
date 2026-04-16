public with sharing class EventIntegrationQueueable implements Queueable, Database.AllowsCallouts {

    private Set<Id> eventIds;
    
    public EventIntegrationQueueable(Set<Id> eventsIds){
        this.eventIds = eventIds;
    }
    
    public void execute(QueueableContext context){
        List<Event> events = [SELECT Subject, Description, IsAllDayEvent, StartDateTime, EndDateTime FROM Event WHERE Id IN :eventIds];
        
        EventIntegrationService.syncToCalendar(events);
    }
    
}