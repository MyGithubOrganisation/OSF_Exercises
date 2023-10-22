trigger SetPrimaryContact on Contact (before insert, before update) 
{

     //Check if there is already a Primary Contact set
     List<Contact> contacts = [SELECT Id, Primary_Contact__c, Account.Name FROM Contact
     WHERE Account.Id = :Trigger.new[0].AccountId];

    for (Contact c : contacts)
    {

        if(c.Id != Trigger.new[0].Id && c.Primary_Contact__c == true && Trigger.new[0].Primary_Contact__c == true)
        {

            Contact newContact = Trigger.new[0];

            newContact.addError('You can not add the contact as Primary Contact. You have already set a Primary Contact!');

        }


    }

   
}