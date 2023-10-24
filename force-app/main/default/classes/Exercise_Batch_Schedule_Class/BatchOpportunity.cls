public with sharing class BatchOpportunity implements Database.Batchable<sObject>, Database.Stateful 
{
    
    Map<String,List<OpportunitiesClass>> opportunitiesStatus = new Map<String,List<OpportunitiesClass>>();
    Map<String,String> emailsList = new Map<String,String>();
    
    public Database.QueryLocator start(Database.BatchableContext ctx)
    {
    
           
        return Database.getQueryLocator('SELECT Id, Name FROM Account');
        
    }
    
    
    public void execute(Database.BatchableContext ctx, List<Account> accounts)
    {
        
        for (Account account : accounts)
        {
        
            Decimal closeWonAmount=0;
        	Decimal closeLostAmount=0;
        	Decimal openAmount=0;
           
            List<AggregateResult> opportunities = [SELECT SUM(Amount) Amount, StageName FROM Opportunity
                                               WHERE AccountId = :account.Id GROUP BY StageName];
           	
            List<OpportunitiesClass> opportunitiesList = new List<OpportunitiesClass>();
            
            for(AggregateResult result:opportunities)
            {
                
                if (result.get('StageName') =='Closed Won')
                {

                    closeWonAmount = (Decimal)result.get('Amount');
                
                }
                    
                if (result.get('StageName') =='Closed Lost')
                {

                    closeLostAmount = (Decimal)result.get('Amount');

                }
                                   
                if (result.get('StageName') !='Closed Lost' && result.get('StageName') !='Closed Won')
                {

                    openAmount +=(Decimal)result.get('Amount');     

                }
                        
            }
            
            opportunitiesList.add(new OpportunitiesClass('Close Lost',closeLostAmount));
            opportunitiesList.add(new OpportunitiesClass('Close Won',closeWonAmount));
            opportunitiesList.add(new OpportunitiesClass('Open',openAmount));
            
            opportunitiesStatus.put(account.Id,opportunitiesList);

        }
        
    }
    
    public void finish(Database.BatchableContext ctx)
    {  
        Messaging.Email[] emails = new Messaging.Email[0];
        
        for(String key:opportunitiesStatus.keySet())
        {
            
            //Get email address for the Primary Contact of current account
            List<Contact> email = [SELECT Email from Contact WHERE Primary_Contact__c = true and AccountId = :key];
          
			Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
            String[] toAddresses = new String[] {email[0].Email}; 
            mail.setToAddresses(toAddresses);
                
            String table = '<table>';
            table+= '<tr><th>Status</th><th>Amount</th></tr>';
                
            for(OpportunitiesClass oc: opportunitiesStatus.get(key))
            {
                    
            	table+='<tr><td>'+ oc.getStatusType() +'</td><td style="align:right">'+ oc.getStatusAmount()+'</td></tr>';
                    
			}
                
            table+='</table>';	
                
            mail.setSubject('Opportunities amount per status : ');
            mail.setHtmlBody(table);
            
            emails.add(mail);
		}
        
        Messaging.sendEmail(emails);
        
	}

}