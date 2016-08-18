# WeaterData
This is a test project which reads recorded weather data from Bradford (UK) and displays it in various graphs and in a table. 

## How to build 
1. Download the source (via git or as a zip) 
2. Open the Xcode project (only possible on a Mac)
3. Make sure the Xcode developer profile settings are right 
  3. This can be found under the project on the left and than the General tab

###Usages 
I used some third party libraries. Those are listed below: 
* Alamofire (https://github.com/Alamofire/Alamofire)
* Charts  (https://github.com/danielgindi/Charts)


### Short Documentation 

#### NetworkCommunicator 
* Downloading the weather data 

#### WeatherData 
* Saving weather data to specific date (year and month) 
  * Sun hours
  * Max Temperature in C
  * Min Temperature in C
  * Days of Air frost
  * Rain in mm 

#### WeatherCollection
* Contains all weather data objects 
* Contains some information about the location 
* Has a singleton, because the app supports only one weather collection at this time 

#### ChooseViewController
* Select the data that should be displayed 

#### MapVC 
* Shows the current weather data location on a map

#### ViewController 
* Presenting the data in a table view and a chart 
