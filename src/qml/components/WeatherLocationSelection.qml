// import QtQuick 1.0 // to target S60 5th Edition or Maemo 5
import QtQuick 1.1
import com.nokia.meego 1.0
import "../weather.js" as Weather

Page {

    id:weatherLocationSelection
    property string api_key: "m9pkxwfpkchmn4834wm4azbp"
    property bool isLoading: false
    property color listPrimaryColor: "#aaaaaa"
    property color listSecondaryColor: "#cccccc"
    property color listHighlightColor: home.socamColor1


    Rectangle {

        anchors.fill: parent
        color: "black"


        Rectangle {

            id: currentDataPanel
            anchors {
                top: parent.top
                left: parent.left
                right: parent.right
            }
            height: 200
            color: "transparent"

            Rectangle {

                id: currentDataHeader
                anchors {
                    top: parent.top
                    left: parent.left
                    right: parent.right
                }
                height: 60
                color: "transparent"

                Label {
                    text: qsTr("Current location")
                    anchors {
                        horizontalCenter: parent.horizontalCenter
                        verticalCenter: parent.verticalCenter
                    }
                    font.pixelSize: 50
                }

            }

            Rectangle {
                id: currentDataHeaderSeparator
                height: 4
                width: parent.width
                anchors {
                    top: currentDataHeader.bottom
                    left: parent.left
                }
                color: "white"
            }

            Rectangle {

                anchors {
                    top: currentDataHeaderSeparator.bottom
                    left: parent.left
                    right: parent.horizontalCenter
                    bottom: parent.bottom
                }
                color: "transparent"

                Label {
                    text: weatherWidget.area_name + ", " +  weatherWidget.region + ", " +  weatherWidget.country
                    font.pixelSize: 35
                    wrapMode: TextEdit.WordWrap
                    anchors {
                        fill: parent
                        leftMargin: 10
                        topMargin: 10
                    }
                    height:40
                }

            }

            Rectangle {

                anchors {
                    top: currentDataHeaderSeparator.bottom
                    left: parent.horizontalCenter
                    right: parent.right
                    bottom: parent.bottom
                }
                color: "transparent"

                Image {
                    id: weatherIcon
                    z: 100
                    anchors {
                        horizontalCenter: parent.horizontalCenter
                        verticalCenter: parent.verticalCenter
                    }
                    width: Math.min(parent.width,parent.height)
                    height: Math.min(parent.width,parent.height)

                    Component.onCompleted: {
                        source = Weather.getIcon(weatherWidget.code, weatherWidget.isDay);
                    }
                }

                Text {
                    id: currentTempText
                    text: (typeof weatherWidget.tempC == "Undefined") ? "" : (weatherWidget.tempC + "º")
                    font.pixelSize: 50
                    color: "white"
                    z: 102
                    anchors {
                        bottom: weatherIcon.bottom
                        right: weatherIcon.right
                    }
                }

                Text {
                    id: currentTempTextShadow
                    text: currentTempText.text
                    font.pixelSize: 50
                    x: currentTempText.x + 2
                    y: currentTempText.y + 2
                    z: 101
                    color: "black"
                }

            }

        }


        Rectangle {

            id: searchPanel
            anchors {
                top: currentDataPanel.bottom
                left: parent.left
                right: parent.right
            }
            height: 125

            Rectangle {

                id: searchField
                anchors {
                    top: parent.top
                    left: parent.left
                    right: parent.right
                    leftMargin: 10
                    rightMargin: 10
                    topMargin: 5
                }
                height: 60

                border {
                    color: "black"
                    width: 1
                }

                TextInput {
                    id: searchFieldInput
                    anchors.fill: parent
                    focus: true
                    font.pixelSize: 40
                    anchors {
                        leftMargin: 5
                        verticalCenter: parent.verticalCenter
                    }
                    onAccepted: {
                        search();
                    }
                }
            }



            Rectangle {

                id: buttonsPanel

                anchors {
                    top: searchField.bottom
                    left: searchField.left
                    right: searchField.right
                    topMargin: 1
                }
                height: 58

                Button {
                    id: searchButton
                    text: qsTr("Search")
                    anchors {
                        top: parent.top
                        bottom: parent.bottom
                        left: parent.left
                        right: parent.horizontalCenter
                        leftMargin: 5
                        rightMargin: 5
                        topMargin: 5
                    }

                    onClicked: {
                        console.log("clicked: "+searchFieldInput.text);
                        search();
                    }

                }


                Button {
                    id: cancelButton
                    text: qsTr("Back")
                    anchors {
                        top: parent.top
                        bottom: parent.bottom
                        left: parent.horizontalCenter
                        right: parent.right
                        leftMargin: 5
                        rightMargin: 5
                        topMargin: 5
                    }

                    onClicked: {
                        pageStack.pop();
                    }

                }

            }


        }


        Rectangle {

            anchors {
                top: searchPanel.bottom
                bottom: parent.bottom
                left: parent.left
                right: parent.right
                topMargin: 5
            }
            clip:true

            BusyIndicator {
                id: indicator
                running: weatherLocationSelection.isLoading
                visible: weatherLocationSelection.isLoading
                platformStyle: BusyIndicatorStyle { size: "large" }
                anchors {
                    horizontalCenter: parent.horizontalCenter
                    verticalCenter: parent.verticalCenter
                }
            }



            ListView {

                id: searchResult
                anchors.fill: parent

                delegate: Rectangle {

                    id: delegateItem
                    height: 80
                    width: parent.width
                    color: model.index==searchResult.currentIndex ? listHighlightColor : ( (model.index%2 == 0) ? listPrimaryColor : listSecondaryColor )

                    Label {
                        id: itemText
                        font.pixelSize: 40
                        anchors.left: parent.left
                        anchors.leftMargin: 20
                        anchors.verticalCenter: parent.verticalCenter
                        text: area_name + ", " + region + ", " + country
                    }

                    MouseArea {
                        anchors.fill: parent

                        onClicked: {

                            delegateItem.ListView.view.currentIndex = index

                            Weather.saveLocation(area_name,region,country);
                            weatherWidget.area_name = area_name;
                            weatherWidget.region = region;
                            weatherWidget.country = country;
                            weatherWidget.reload();
                            pageStack.pop();
                        }
                    }

                }
                model: listModel


            }

        }



        XmlListModel {
            id: listModel
            query: "/search_api/result"
            XmlRole {name:"area_name"; query:"areaName/string()"}
            XmlRole {name:"region"; query:"region/string()"}
            XmlRole {name:"country"; query:"country/string()"}
            XmlRole {name:"latitude"; query:"latitude/string()"}

            onStatusChanged: {
                if(status==XmlListModel.Ready) {
                    isLoading = false;
                    searchResult.currentIndex=-1;
                }
            }

        }




    }

    function search() {
        if(!weatherLocationSelection.isLoading) {
            weatherLocationSelection.isLoading = true;
            listModel.source = "http://api.worldweatheronline.com/free/v1/search.ashx?q="+searchFieldInput.text+"&format=xml&key=" + api_key;
            listModel.reload();
        }
    }



}
