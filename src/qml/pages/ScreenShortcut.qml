// import QtQuick 1.0 // to target S60 5th Edition or Maemo 5
import QtQuick 1.1

// import QtQuick 1.0 // to target S60 5th Edition or Maemo 5
import QtQuick 1.1

Rectangle {

        id: screenselectorcontainer
        color: "transparent"
        width: home.isPortrait ? shortcutSize : parent.width
        height: home.isPortrait ? parent.height :  shortcutSize

        property string icon
        property int screen

        MouseArea {
            id: screenselectormousearea
            anchors.fill: parent
            Image {
                id: iconimage
                source: icon
                sourceSize.width: parent.width
                sourceSize.height: parent.height
                anchors.fill: parent
                anchors.horizontalCenter: parent.horizontalCenter
            }
            onClicked: {
                 pager.currentIndex = screen;
            }

        }

}
