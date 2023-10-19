trigger UpdatePrimaryContactData on Contact (after insert, after update) 
{

    String PrimaryPhone ='';
       
    List<Contact> contacts = [SELECT Id, Primary_Contact__c, Primary_Contact_Phone__c, Account.Name FROM Contact
                             WHERE Account.Id = :Trigger.new[0].AccountId];
    
    
    for (Contact c : contacts)
    {
        
        if (c.Primary_Contact__c == true)
        {
            
        	PrimaryPhone = c.Primary_Contact_Phone__c;
           
        }
        
    }
    
    List<Contact>contactsToBeUpdated = new List<Contact>();
	for (Contact c : contacts)
    {

        //Check if the contact si not Primary Contact or the Primary Phone is null 
        //or if you Change the Primary Contact all the contacts should have the phone number of the new Primary Contact 
        //or if you change the Phone for Primary Contact all the contacts should have the new phone number of the new Primary Contact 
        if (c.Primary_Contact__c == false && (c.Primary_Contact_Phone__c == null || c.Primary_Contact_Phone__c != PrimaryPhone))
        {
            
        	c.Primary_Contact_Phone__c = PrimaryPhone;
            contactsToBeUpdated.add(c);
            
        }
        
    }
    
    update(contactsToBeUpdated); 

}