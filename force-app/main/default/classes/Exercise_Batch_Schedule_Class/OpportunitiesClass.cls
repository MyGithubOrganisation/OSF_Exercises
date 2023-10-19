public with sharing class OpportunitiesClass {
   
    private String statusType;
    private Decimal statusAmount;
        
	public OpportunitiesClass(String statusType, Decimal statusAmount )
	{
            
        this.statusType = statusType;
        this.statusAmount = statusAmount;
            
	}
    
    public String getStatusType()
    {
        
        return statusType;
    }
    
     public Decimal getStatusAmount()
     {
        
        return statusAmount;
    }

}