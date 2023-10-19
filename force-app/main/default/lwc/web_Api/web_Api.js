import { LightningElement, api, track, wire } from 'lwc';
import getWeather from '@salesforce/apex/Weather_api_controller.getWeather';
import parse from '@salesforce/apex/Weather_object.parse';
import { getRecord, getFieldValue } from 'lightning/uiRecordApi';
import ACCOUNT_NAME_FIELD from '@salesforce/schema/Account.Name';
import BILLING_CITY_FIELD from '@salesforce/schema/Account.BillingCity';

export default class Web_Api extends LightningElement {

    @api
    recordId;

    city ='Waiting for info';
    temperature = 0;
    temperatureF= 0;
    temperatureC=0;
    description = 'description'
    icon= '';

    @wire(getRecord,{recordId:"$recordId",fields:[ACCOUNT_NAME_FIELD,BILLING_CITY_FIELD]})
    getAccount({data,error}){


        this.city =  getFieldValue(data,BILLING_CITY_FIELD);

        console.log(this.city);

    }

    @wire(getWeather)
     async getWeather({data,error}){

        var jsonText='';

        if (data !=undefined)
        {
            if(this.city != undefined || this.city != null)
            {

                var resp = await fetch('https://api.openweathermap.org/data/2.5/weather?q=' + this.city +' &appid=7a481080da7d0e663796fd4b343afb76');
                
                jsonText = await resp.json();
                this.temperature = jsonText.main.temp;
                this.temperatureF = (jsonText.main.temp -273.15)*9/5+32;
                this.temperatureC = (jsonText.main.temp -273.15);

                this.temperature = (Math.round(this.temperatureF * 100) / 100).toFixed(2) + " F / " + (Math.round(this.temperatureC * 100) / 100).toFixed(2) + " C";
                

                this.description = jsonText.weather[0].description;
                this.icon = 'https://openweathermap.org/img/wn/'+jsonText.weather[0].icon+ '@2x.png' ;
  
            }
         
        }

    }

    @wire(parse)
    getinfo({data, error}){

        console.log(data);
    }




    // getWeather(){

    //     const calloutURL  = 'https://api.openweathermap.org/data/2.5/weather?q=New York &appid=7a481080da7d0e663796fd4b343afb76';

    //     fetch(calloutURL).then((response)=> response.json).then(response =>{
            
    //         this.data = response;
    //         console.log(response);
    //     })
    

}