.pragma library


function getDatabase() {
     return openDatabaseSync("WeatherWidget", "1.0", "WeatherWidget", 1);
}


// At the start of the application, we can initialize the tables we need if they haven't been created yet
function initialize() {
    console.log("Weather.initialize()");
    var db = getDatabase();
    db.transaction(
        function(tx) {
                    tx.executeSql('CREATE TABLE IF NOT EXISTS location(area_name TEXT, region TEXT, country TEXT);');
      });
    console.log("Weather.initialize() END");
}


function getLocation() {

       console.log("Weather.getLocation");
       var db = getDatabase();
       var res={};
       db.transaction(function(tx) {
         var rs = tx.executeSql('SELECT area_name, region, country from location limit 1');
         if (rs.rows.length > 0) {
             res['area_name'] = rs.rows.item(0).area_name;
             res['region'] = rs.rows.item(0).region;
             res['country'] = rs.rows.item(0).country;
             console.log("Location retrieved: area_name=" + res['area_name'] + " region=" + res['region'] + " country=" + res['country'] );
         }
      })
      console.log("Weather.getLocation=" + res);
      return res;

}

function saveLocation(area_name, region, country) {

    console.log("Weather.setLocation area_name= " + area_name + " region=" + region + " country=" + country);

    var db = getDatabase();
    db.transaction(function(tx) {
           var rs = tx.executeSql('DELETE FROM location');
           rs = tx.executeSql('INSERT INTO location VALUES (?,?,?);', [area_name,region,country]);
    });
    console.log("Weather.setLocation END");

}


var icons = {
    "0" : "unknown",
    "113" : "clear_sky",
    "116" : "sunny_intervals",
    "119" : "white_cloud",
    "122" : "black_low_cloud",
    "143" : "mist",
    "176" : "light_rain_showers",
    "179" : "sleet_showers",
    "182" : "cloudy_with_sleet",
    "185" : "cloudy_with_sleet",
    "200" : "thundery_showers",
    "227" : "cloudy_with_light_snow",
    "230" : "cloudy_with_heavy_snow",
    "248" : "fog",
    "260" : "fog",
    "263" : "light_rain_showers",
    "266" : "cloudy_with_light_rain",
    "281" : "cloudy_with_sleet",
    "284" : "cloudy_with_sleet",
    "293" : "cloudy_with_light_rain",
    "296" : "cloudy_with_light_rain",
    "299" : "heavy_rain_showers",
    "302" : "cloudy_with_heavy_rain",
    "305" : "heavy_rain_showers",
    "308" : "cloudy_with_heavy_rain",
    "311" : "cloudy_with_sleet",
    "314" : "cloudy_with_sleet",
    "317" : "cloudy_with_sleet",
    "320" : "cloudy_with_light_snow",
    "323" : "light_snow_showers",
    "326" : "light_snow_showers",
    "329" : "cloudy_with_heavy_snow",
    "332" : "cloudy_with_heavy_snow",
    "335" : "heavy_snow_showers",
    "338" : "cloudy_with_heavy_snow",
    "350" : "cloudy_with_sleet",
    "353" : "light_rain_showers",
    "356" : "heavy_rain_showers",
    "359" : "cloudy_with_heavy_rain",
    "362" : "sleet_showers",
    "365" : "sleet_showers",
    "368" : "light_snow_showers",
    "371" : "heavy_snow_showers",
    "374" : "sleet_showers",
    "377" : "cloudy_with_sleet",
    "386" : "thundery_showers",
    "389" : "thunderstorms",
    "392" : "thundery_showers",
    "395" : "heavy_snow_showers"
}

function getIcon(code,isDay) {
    console.log("Weather.getIcon(" + code + ")");
    var icon =  icons[code];
    if(typeof icon != "Undefined") {
        icon =  "qrc:/images/icons/weather/" + icon + (isDay?"":"_night") + ".png";
    }  else {
        icon = "qrc:/images/icons/weather/unknown.png";
    }
    console.log("Icon:" + icon);
    return icon;

}
