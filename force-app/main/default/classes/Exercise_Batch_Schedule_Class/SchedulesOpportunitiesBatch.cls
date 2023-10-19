public with sharing class SchedulesOpportunitiesBatch implements Schedulable 
{
    
     public void execute(SchedulableContext ctx) 
     {
     
         BatchOpportunity bo = new BatchOpportunity();
         
		Id batchId = database.executeBatch(bo);
         
     }
}