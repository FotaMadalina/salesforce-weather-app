/*********************************************************************************
* @author         Fota Maria-Madalina
* @date           05-03-2023
* @description    This class is a wrapper generated for the data received from weather service
**********************************************************************************/
public with sharing class AC_Weather_Data_Wrapper {
    public String cod;
	public String message;
	public String cnt;
	public List<AC_Data> data;
	public AC_City city;

    public class AC_Data{
        public String dt;
		public AC_Main main;
		public List<AC_Weather> weather;
		public AC_Clouds clouds;
		public AC_Wind wind;
		public String visibility;
		public String pop;
		public AC_Sys sys;
		public String dt_txt;
    }

    public class AC_Main{
        public String temp;
		public String feels_like;
		public String temp_min;
		public String temp_max;
		public String pressure;
		public String sea_level;
		public String grnd_level;
		public String humidity;
		public String temp_kf;
    }

    public class AC_Weather{
        public String id;
		public String main;
		public String description;
		public String icon;
    }

    public class AC_Clouds{
        public String all;
    }

    public class AC_Wind{
        public String speed;
		public String deg;
		public String gust;
    }

    public class AC_Sys{
        public String pod;
    }

    public class AC_City{
        public String id;
		public String name;
		public AC_Coord coord;
		public String country;
		public String population;
		public String timezone;
		public String sunrise;
		public String sunset;
    }

    public class AC_Coord{
        public String lat;
		public String lon;
    }
}