/*********************************************************************************
* @author         Fota Maria-Madalina
* @date           06-03-2023
* @description    Test class for AC_Weather_Component_Ctrl
**********************************************************************************/
@isTest
public class AC_Weather_Component_Ctrl_Test {

    /*********************************************************************************
    * @author         Fota Maria-Madalina
    * @date           06-03-2023
    * @description    This class sets the Mock HTTPResponse in case of success
    **********************************************************************************/
    public class Weather_API_Success_Mock implements HttpCalloutMock {

        /********************************************************************************************************
        * @author         Fota Maria-Madalina
        * @date           06-03-2023
        * @description    This method is an implementation of the HttpCalloutMock interface in case of success
        * @param          request (HTTPRequest):  The Http Request sent for recieving the mock response
        * @return         HTTPResponse
        *********************************************************************************************************/
        public  HTTPResponse respond(HTTPRequest request) {
            HttpResponse response = new HttpResponse();

            response.setHeader('Content-Type', 'application/json');
            response.setStatusCode(200);
            response.setBody('{"cod":"200","message":0,"cnt":40,"list":[{"dt":1661871600,"main":{"temp":296.76,"feels_like":296.98,"temp_min":296.76,"temp_max":297.87,"pressure":1015,"sea_level":1015,"grnd_level":933,"humidity":69,"temp_kf":-1.11},"weather":[{"id":500,"main":"Rain","description":"light rain","icon":"10d"}],"clouds":{"all":100},"wind":{"speed":0.62,"deg":349,"gust":1.18},"visibility":10000,"pop":0.32,"rain":{"3h":0.26},"sys":{"pod":"d"},"dt_txt":"'+System.today().addDays(1)+' 15:00:00"},{"dt":1661882400,"main":{"temp":295.45,"feels_like":295.59,"temp_min":292.84,"temp_max":295.45,"pressure":1015,"sea_level":1015,"grnd_level":931,"humidity":71,"temp_kf":2.61},"weather":[{"id":500,"main":"Rain","description":"light rain","icon":"10n"}],"clouds":{"all":96},"wind":{"speed":1.97,"deg":157,"gust":3.39},"visibility":10000,"pop":0.33,"rain":{"3h":0.57},"sys":{"pod":"n"},"dt_txt":"'+System.today().addDays(1)+' 18:00:00"},{"dt":1661893200,"main":{"temp":292.46,"feels_like":292.54,"temp_min":290.31,"temp_max":292.46,"pressure":1015,"sea_level":1015,"grnd_level":931,"humidity":80,"temp_kf":2.15},"weather":[{"id":500,"main":"Rain","description":"light rain","icon":"10n"}],"clouds":{"all":68},"wind":{"speed":2.66,"deg":210,"gust":3.58},"visibility":10000,"pop":0.7,"rain":{"3h":0.49},"sys":{"pod":"n"},"dt_txt":"'+System.today().addDays(1)+' 21:00:00"},{"dt":1662292800,"main":{"temp":294.93,"feels_like":294.83,"temp_min":294.93,"temp_max":294.93,"pressure":1018,"sea_level":1018,"grnd_level":935,"humidity":64,"temp_kf":0},"weather":[{"id":804,"main":"Clouds","description":"overcast clouds","icon":"04d"}],"clouds":{"all":88},"wind":{"speed":1.14,"deg":17,"gust":1.57},"visibility":10000,"pop":0,"sys":{"pod":"d"},"dt_txt":"'+System.today().addDays(1)+' 12:00:00"}],"city":{"id":3163858,"name":"Zocca","coord":{"lat":44.34,"lon":10.99},"country":"IT","population":4593,"timezone":7200,"sunrise":1661834187,"sunset":1661882248}}');
            return response;
        }
    }

    /*********************************************************************************
    * @author         Fota Maria-Madalina
    * @date           06-03-2023
    * @description    This class sets the Mock HTTPResponse in case of error (bad request)
    **********************************************************************************/
    public class Weather_API_Fail_Mock implements HttpCalloutMock {
        
        /********************************************************************************************************
        * @author         Fota Maria-Madalina
        * @date           06-03-2023
        * @description    This method is an implementation of the HttpCalloutMock interface in case of error
        * @param          request (HTTPRequest):  The Http Request sent for recieving the mock response
        * @return         HTTPResponse
        *********************************************************************************************************/
        public HttpResponse respond(HttpRequest request) {
            HttpResponse response = new HttpResponse();
            response.setHeader('Content-Type', 'test');
            response.setBody('{"cod":429,"message":"Your account is temporary blocked due to exceeding of requests limitation of your subscription type."}');
            response.setStatusCode(429);
            return response;
        }
    }

    /*********************************************************************************************************************************
    * @author         Fota Maria-Madalina
    * @date           06-03-2023
    * @description    This method tests the method getResponseFromAPI in case of success
    **********************************************************************************************************************************/
    @isTest
    static void getResponseFromAPI_Success_test() {

        Test.setMock(HttpCalloutMock.class, new Weather_API_Success_Mock());
        List<AC_Weather_Component_Ctrl.AC_Weather_Data_Response> result=new List<AC_Weather_Component_Ctrl.AC_Weather_Data_Response>();

        Test.startTest();
            result = AC_Weather_Component_Ctrl.getResponseFromAPI('Zocca','IT'); 
        Test.stopTest();
        
        System.assertEquals(System.today().addDays(1)+' 15:00:00', result[0].temperatureDateTime);
        System.assertEquals('296.76', result[0].temperature);
        System.assertEquals('light rain', result[0].description);
        System.assertEquals('10d', result[0].icon);
    }

    /***********************************************************************************************************************************************
    * @author         Fota Maria-Madalina
    * @date           06-03-2023
    * @description    This method tests the method getResponseFromAPI in case of total callout fail
    ***********************************************************************************************************************************************/
    @isTest
    public static void getResponseFromAPI_Fail_test() {
        Boolean isError=false;
        String errorMessage=null;
        Test.setMock(HttpCalloutMock.class, new Weather_API_Fail_Mock());
        List<AC_Weather_Component_Ctrl.AC_Weather_Data_Response> result=new List<AC_Weather_Component_Ctrl.AC_Weather_Data_Response>();
        
        Test.startTest();
        try{
            result = AC_Weather_Component_Ctrl.getResponseFromAPI('Zocca','IT');  
        }catch(Exception ex){
            isError=true;
            errorMessage=ex.getMessage();
        }

        Test.stopTest();

        System.assert(isError);
    }
}