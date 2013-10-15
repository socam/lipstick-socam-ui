import QtQuick 1.1
import com.nokia.meego 1.2
import "../weather.js" as Weather

Rectangle {

    id: weatherWidget

    property string area_name
    property string region
    property string country
    property string code
    property string tempC
    property bool isDay
    property int refreshInterval: 3600000


    property string api_url: "http://api.worldweatheronline.com/free/v1/weather.ashx";
    property string api_key:  "m9pkxwfpkchmn4834wm4azbp"
    property bool isLoading: false

    width: 100
    height: 100
    color: "transparent"

    Image {
        id: weatherIcon
        anchors.fill: parent
    }

    Text {
        id: tempText
        font.pixelSize: 40
        color: "white"
        z: 101
        anchors {
            bottom: parent.bottom
            right: parent.right
        }
    }

    Text {
        id: tempTextShadow
        text: tempText.text
        font.pixelSize: 40
        x: tempText.x + 2
        y: tempText.y + 2
        z: 100
        color: "black"
    }

    MouseArea {
        anchors.fill:parent
        onClicked: {
            var component = Qt.createComponent("WeatherLocationSelection.qml");
            var locationSelection = component.createObject(weatherWidget, {});
            pageStack.push(locationSelection);
        }
        onPressAndHold: {
            reload();
        }
    }

    Timer {
        interval: refreshInterval
        running: true
        repeat: false
        onTriggered: reload();
    }


    BusyIndicator {
        id: indicator
        running: isLoading
        visible: isLoading
        platformStyle: BusyIndicatorStyle { size: "large" }
        anchors {
            horizontalCenter: parent.horizontalCenter
            verticalCenter: parent.verticalCenter
        }
    }


    Component.onCompleted: {

        Weather.initialize();

        console.log("Load location from DB");
        var dblocation = Weather.getLocation();
        if(typeof dblocation['area_name'] === "Undefined") {
            console.log("No location found in DB");
        } else {
            area_name = dblocation['area_name'];
            region = dblocation['region'];
            country = dblocation['country'];
            reload();
        }
    }


    function reload() {

        isLoading = true;

        var http = new XMLHttpRequest();
        var url = api_url;
        var params = "q=" + area_name + "," + region + "," + country + "&format=json&key=" + api_key;

        console.log("WeatherWidget reload() url=" + url + " params=" + params);
        http.open("GET", url+"?"+params, true);

        //Send the proper header information along with the request
        http.setRequestHeader("Connection", "close");

        http.onreadystatechange = function() {//Call a function when the state changes.
            if(http.readyState == 4) {

                if(http.status==200) {
                    console.log("WeatherWidget http response=" + http.responseText);

                    // translate response into object
                    var response = JSON.parse(http.responseText);

                    code = response.data.current_condition[0].weatherCode;
                    tempC = response.data.current_condition[0].temp_C;

                    var weatherIconUrl = response.data.current_condition[0].weatherIconUrl[0].value.toString();
                    var suffix = weatherIconUrl.substr( (weatherIconUrl.length>9 ? weatherIconUrl.length-9 : 0),weatherIconUrl.length);
                    isDay = (suffix != "night.png");

                    tempText.text = tempC + "º";

                } else {
                    //Show 'unknown' icon
                    code = "0";
                    isDay = true;
                }

                weatherIcon.source = Weather.getIcon(code,isDay);

                isLoading = false;

            } else {
                console.log("Ignore response: http.readyState=" + http.readyState + " http.status=" + http.status);
            }
        }
        http.send(params);

    }

}
