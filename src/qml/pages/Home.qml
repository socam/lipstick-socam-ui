
// This file is part of colorful-home, a nice user experience for touchscreens.
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
// SOFTWARE.
//
// Copyright (c) 2011, Tom Swindell <t.swindell@rubyx.co.uk>
// Copyright (c) 2012, Timur Kristóf <venemo@fedoraproject.org>

import QtQuick 1.1
import es.zed.socam 0.1
import es.zed.socam.rssreader 1.0
import org.freedesktop.contextkit 1.0
import com.nokia.meego 1.2
import "."
import "../components"
import "../feeds.js" as Feeds


// Home page:
// the place for user-customizable content such as
// widgets, notifications, favorite apps, etc.

Item {

    id: home
    property color primaryColor: 'white'
    property color secondaryColor: '#888888'
    property color socamColor1: "#a0cbdf"
    property color socamColor2: "#70a8a2"
    property color socamColor3: "#d6872f"

    property int shortcutsBarWidth: 100
    property int shortcutSize: 100
    property bool isPortrait: width < height
    property int locationNameSize: 12

    property string landscapeTemplate
    property string portraitTemplate

    Component.onCompleted: {
        Feeds.initialize();
        landscapeTemplate = Feeds.getTemplate(true); 
        portraitTemplate = Feeds.getTemplate(false);
    }

    Rectangle {

        id: homeContentContainer
        z:2
        height: isPortrait ? (parent.height - shortcutsBarWidth) : parent.height
        width: isPortrait ? parent.width : (parent.width - shortcutsBarWidth)

        anchors {
            top: parent.top
            left: parent.left
        }



        Rectangle {

            id: homeContentInnerContainerHeader
            height: 120
            width: parent.width
            color: "black"

            Image {
                id: photoImage
                source: 'qrc:/images/photo.png'
                anchors {
                    top: parent.top
                    left: parent.left
                    leftMargin: 10
                    topMargin: 10
                }
            }

            WeatherWidget {
                id: weatherWidget
                height: parent.height * 0.9
                width: parent.height * 0.9
                anchors {
                    horizontalCenter: parent.horizontalCenter
                    verticalCenter: parent.verticalCenter
                }
            }

            // Day of week
            Label {
                id: displayDayOfWeek
                text: Qt.formatDateTime(wallClock.time, "dddd")
                font {
                    bold: true
                     pixelSize:45
                     capitalization: Font.Capitalize
                 }
                //color: home.primaryColor
                color: socamColor3

                anchors {
                    top: parent.top
                    right: parent.right
                    topMargin: 10
                    rightMargin: 5
                }
            }

            // Current date
            Label {
                id: displayCurrentDate
                text: Qt.formatDate(wallClock.time, Qt.SystemLocaleShortDate)
                font {
                    bold: true
                    pixelSize: 25
                }
                color: home.secondaryColor
                anchors {
                    top: displayDayOfWeek.bottom
                    right: parent.right
                    topMargin: 15
                    rightMargin: 5
                }
            }

            Label {
                id: cityLabel
                text: weatherWidget.area_name.length<locationNameSize ? weatherWidget.area_name : (weatherWidget.area_name.substring(0,locationNameSize) + "...")
                font {
                    bold: true
                    pixelSize: 28
                }
                color: socamColor1
                anchors {
                    top: displayCurrentDate.bottom
                    right: parent.right
                    topMargin: 10
                    rightMargin: 5
                }
            }

        }


	    Rectangle {

            anchors.top: homeContentInnerContainerHeader.bottom
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.bottom: parent.bottom

            FeedTemplateNotifier {
                id: feedTemplateNotifier
                onModified: {
                    console.log("Home.qml: FeedTemplateNotifier.modified()");
                    home.landscapeTemplate = Feeds.getTemplate(true);
                    console.log("Landscape template=" + home.landscapeTemplate);
                    home.portraitTemplate = Feeds.getTemplate(false);
                    console.log("Portrait template=" + home.portraitTemplate);
                    landscapeRenderer.template = home.landscapeTemplate;
                    portraitRenderer.template = home.portraitTemplate;
                    console.log("RELOAD LANDSCAPE TEMPLATE");
                    landscapeRenderer.reload();
                    console.log("RELOAD PORTRAIT TEMPLATE");
                    portraitRenderer.reload();
                }
            }

            TemplateRenderer {
                id: landscapeRenderer
                visible: !isPortrait
                templateFile: landscapeTemplate
                landscape: true
                preview: false
                name: "lipstick-home"
            }

            TemplateRenderer {
                id: portraitRenderer
                visible: isPortrait
                templateFile: portraitTemplate
                landscape: false
                preview: false
                name: "lipstick-home"
            }

        }

    }



    // Shortcuts bar
    Rectangle {

        id: shortcutsBarBackground
        z:3
        height: isPortrait ? shortcutsBarWidth: parent.height
        width: isPortrait ? parent.width: shortcutsBarWidth
        color:  "black"
        opacity: 0.7
        anchors {
            bottom: parent.bottom
            right: parent.right
        }

    }

    // Shortcuts bar
    Flow {

        id: shortcutsBar
        z:4
        height: isPortrait ? shortcutsBarWidth: parent.height
        width: isPortrait ? parent.width: shortcutsBarWidth
        spacing: isPortrait ? ((width - shortcutSize*5) / 5) -1 : (height - shortcutSize*5) / 5 -1
        anchors {
            bottom: parent.bottom
            right: parent.right
        }

        AppShortcut {

            id: callShortcut
            icon: "qrc:images/icons/shortcut-telephony.svg"

            Rectangle {
                id: homeCallNotifierContainer
                visible: homeCallNotifier.count > 0
                height: 40
                width: 40
                color: "transparent"
                anchors.top: parent.top
                anchors.left: parent.left

                Rectangle {
                    id: homeCallNotifierBackground
                    anchors.fill: parent
                    color: "red"

                }


                CallNotifier {
                    id: homeCallNotifier

                    Component.onCompleted: {
                        console.log("HOME.CallNotifier.COMPLETED:" , count);
                        homeMissedCallsText.text = count;
                    }

                    onModified: {
                        console.log("HOME.CallNotifier.MODIFIED:" , count);
                        homeMissedCallsText.text = count;
                        if(count>0) {
                            homeCallNotifierContainer.visible = true;
                        } else {
                            homeCallNotifierContainer.visible = false;
                        }
                    }
                }

                Label {
                    id: homeMissedCallsText
                    color: "white"
                    anchors.fill: parent
                    font.pixelSize: 30
                    text: homeCallNotifier.coun
                    horizontalAlignment: TextInput.AlignHCenter
                }

            }

            SequentialAnimation {

                id: callNotificationAnimation
                running: homeCallNotifierContainer.visible
                loops: Animation.Infinite

                PropertyAnimation {
                    target: homeCallNotifierBackground
                    property: "opacity"
                    duration: 500
                    from: 1
                    to: 0.5
                }

                PropertyAnimation {
                    target: homeCallNotifierBackground
                    property: "opacity"
                    duration: 500;
                    from: 0.5
                    to: 1
                }

            }

            onClicked: {
                homeCallNotifier.showUI();
            }

        }

        AppShortcut {

            id: smsShortcut
            icon: "qrc:images/icons/shortcut-msg.svg"

            Rectangle {
                id: homeSMSNotifierContainer
                visible: homeSMSNotifier.count > 0
                height: 40
                width: 40
                color: "transparent"
                anchors.top: parent.top
                anchors.left: parent.left

                Rectangle {
                    id: homeSMSNotifierBackground
                    color: "red"
                    anchors.fill: parent
                }

                SMSNotifier {
                    id: homeSMSNotifier

                    Component.onCompleted: {
                        homeReceivedSMSsText.text = count;
                    }

                    onModified: {
                        homeReceivedSMSsText.text = count;
                        if(count>0) {
                            homeSMSNotifierContainer.visible = true;
                        } else {
                            homeSMSNotifierContainer.visible = false;
                        }
                    }
                }

                Label {
                    id: homeReceivedSMSsText
                    color: "white"
                    anchors.fill: parent
                    font.pixelSize: 30
                    text: homeSMSNotifier.count
                    horizontalAlignment: TextInput.AlignHCenter
                }

            }

            SequentialAnimation {

                id: smsNotificationAnimation
                running: homeSMSNotifierContainer.visible
                loops: Animation.Infinite

                PropertyAnimation {
                    target: homeSMSNotifierBackground
                    property: "opacity"
                    duration: 500
                    from: 1
                    to: 0.5
                }

                PropertyAnimation {
                    target: homeSMSNotifierBackground
                    property: "opacity";
                    duration: 500
                    from: 0.5
                    to: 1
                }

            }

            onClicked: {
                homeSMSNotifier.showUI();
            }

        }

        ScreenShortcut {
            icon: "qrc:images/icons/shortcut-apps.svg"
            screen: 1
        }

        AppShortcut {
            icon: "qrc:images/icons/shortcut-browser.svg"
            cmd: "invoker --splash /opt/heliumreborn/portrait.png -L /opt/heliumreborn/landscape.png -r 9 --type=d /usr/bin/heliumreborn"
        }

        AppShortcut {
            icon: "qrc:images/icons/shortcut-contacts.svg"
            cmd: "invoker --single-instance --type=s /usr/bin/qmlcontacts -fullscreen"
        }

    }

}
