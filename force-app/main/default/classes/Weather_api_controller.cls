public with sharing class Weather_api_controller 
{

    @AuraEnabled(cacheable=true)
    public static String getWeather() 
    {

        Http http = new Http();

        HttpRequest request = new HttpRequest();

        request.setEndpoint('https://api.openweathermap.org/data/2.5/weather?q=New York &appid=7a481080da7d0e663796fd4b343afb76');

        request.setMethod('GET');

        HttpResponse response = http.send(request);

        if(response.getStatusCode() ==200)
        {

            //Map<String, Object> results = (Map<String, Object>) JSON.deserializeUntyped(response.getBody());
            // Cast the values in the 'animals' key as a list
            //Object coord = (Object) results;

            return response.getBody();

        }
        else 
        {
        
            return null;

        }

        

    }
}