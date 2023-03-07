/*********************************************************************************
* @author         Fota Maria-Madalina
* @date           05-03-2023
* @description    Controller class for weatherComponent LWC
**********************************************************************************/
public with sharing class AC_Weather_Component_Ctrl {
    private static final String UNIT='metric';
    private static final String CALLOUT_ENDPOINT='https://api.openweathermap.org/data/2.5/forecast?';
    private static final String API_KEY='xxxxx';//It is set in salesforce org but I modified it for git

    /*********************************************************************************
    * @author         Fota Maria-Madalina
    * @date           05-03-2023
    * @description    This method makes a callout to an external service to retrieve weather data
    **********************************************************************************/
    @AuraEnabled
    public static List<AC_Weather_Data_Response> getResponseFromAPI(String city, String countryCode) {
        List<AC_Weather_Data_Response> resultData=new List<AC_Weather_Data_Response>();
        String result;
        try{
            Http http = new Http();
            HttpRequest request = new HttpRequest();
            String endpoint = CALLOUT_ENDPOINT;
            endpoint += 'q=' + city +','+countryCode+ '&appid=' + API_KEY + '&units=' + UNIT;
            request.setEndpoint(endpoint);
            request.setMethod('GET');
            HttpResponse res = http.send(request);
            result = res.getBody();
            
            if(res.getStatusCode() == 401){
                throw new AuraHandledException('Invalid API Key');
            }

            if(res.getStatusCode() == 404){
                throw new AuraHandledException('City not found');
            }

            if(res.getStatusCode() == 429){
                throw new AuraHandledException('Your account is temporary blocked due to exceeding of requests limitation of your subscription type. Please wait 10 minutes and refresh the page again.');
            }

            result=result.replaceAll('list', 'data');

            Type resultType = Type.forName('AC_Weather_Data_Wrapper');
            AC_Weather_Data_Wrapper deserializeResults =(AC_Weather_Data_Wrapper)JSON.deserialize(result, resultType);

            for(AC_Weather_Data_Wrapper.AC_Data data:deserializeResults.data){
                Datetime dt = DateTime.valueOf(data.dt_txt);
                if(dt.date()==System.today().addDays(1)){
                    AC_Weather_Data_Response weatherData=new AC_Weather_Data_Response(data.dt_txt,data.main.temp,data.weather[0].description,data.weather[0].icon);
                    resultData.add(weatherData);
                }
            }
        }catch (Exception e){
            throw new AuraHandledException('An error occured. Please contact your administrator.');
        }
        
        return resultData;
    }

    /*********************************************************************************
    * @author         Fota Maria-Madalina
    * @date           05-03-2023
    * @description    This class is used to set the result to be sent back in the LWC
    **********************************************************************************/
    public class AC_Weather_Data_Response{
        @AuraEnabled
        public String temperatureDateTime;
        @AuraEnabled
        public String temperature;
        @AuraEnabled
        public String description;
        @AuraEnabled
        public String icon;

        public AC_Weather_Data_Response(String temperatureDateTime, String temperature, String description, String icon){
            this.temperatureDateTime=temperatureDateTime;
            this.temperature=temperature;
            this.description=description;
            this.icon=icon;
        }
    }
}