import QtQuick 1.1
import org.nemomobile.lipstick 0.1
import org.freedesktop.contextkit 1.0
import com.nokia.meego 1.0

Item {
    property bool isPortrait: (orientationAngleContextProperty.value == 90 || orientationAngleContextProperty.value == 270)
    id: usbWindow
    width: initialSize.width
    height: initialSize.height

    ContextProperty {
        id: orientationAngleContextProperty
        key: "/Screen/CurrentWindow/OrientationAngle"
    }

    Item {
        property bool shouldBeVisible
        id: usbDialog
        width: usbWindow.isPortrait ? usbWindow.height : usbWindow.width
        height: usbWindow.isPortrait ? usbWindow.width : usbWindow.height
        transform: Rotation {
            origin.x: { switch(orientationAngleContextProperty.value) {
                      case 270:
                          return usbWindow.height / 2
                      case 180:
                      case 90:
                          return usbWindow.width / 2
                      default:
                          return 0
                      } }
            origin.y: { switch(orientationAngleContextProperty.value) {
                case 270:
                case 180:
                    return usbWindow.height / 2
                case 90:
                    return usbWindow.width / 2
                default:
                    return 0
                } }
            angle: (orientationAngleContextProperty.value === undefined || orientationAngleContextProperty.value == 0) ? 0 : -360 + orientationAngleContextProperty.value
        }
        opacity: shouldBeVisible ? 1 : 0

        Rectangle {
            anchors.fill: parent
            color: "black"
            opacity: 0.8
        }

        MouseArea {
            id: usbDialogBackground
            anchors.fill: parent

            onClicked: { usbModeSelector.setUSBMode(4); usbDialog.shouldBeVisible = false }

            Rectangle {
                id: chargingOnly
                anchors {
                    top: parent.top
                    left: parent.left
                    right: parent.right
                    topMargin: parent.height / 4
                }
                height: 102
                color: "black"
                radius: 5
                border {
                    color: "gray"
                    width: 2
                }

                Label {
                    anchors {
                        fill: parent
                    }
                    text: qsTr("Current mode: Charging only")
                    color: "white"
                    font.pixelSize: 30
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                }
            }

            Label {
                id: button1
                anchors {
                    top: chargingOnly.bottom
                    topMargin: 40
                    left: parent.left
                    right: parent.right
                }
                text: qsTr("MTP Mode")
                color: "white"
                font.pixelSize: 30
                wrapMode: Text.WordWrap
                horizontalAlignment: Text.AlignHCenter

                MouseArea {
                    anchors.fill: parent
                    onClicked: { usbModeSelector.setUSBMode(11); usbDialog.shouldBeVisible = false }
                }
            }

            Label {
                id: button2
                anchors {
                    top: button1.bottom
                    topMargin: 40
                    left: parent.left
                    right: parent.right
                }
                text: qsTr("Mass Storage Mode")
                color: "white"
                font.pixelSize: 30
                wrapMode: Text.WordWrap
                horizontalAlignment: Text.AlignHCenter

                MouseArea {
                    anchors.fill: parent
                    onClicked: { usbModeSelector.setUSBMode(3); usbDialog.shouldBeVisible = false }
                }
            }

            Label {
                id: button3
                anchors {
                    top: button2.bottom
                    topMargin: 40
                    left: parent.left
                    right: parent.right
                }
                text: qsTr("Developer Mode")
                color: "white"
                font.pixelSize: 30
                wrapMode: Text.WordWrap
                horizontalAlignment: Text.AlignHCenter

                MouseArea {
                    anchors.fill: parent
                    onClicked: { usbModeSelector.setUSBMode(10); usbDialog.shouldBeVisible = false }
                }
            }
        }

        Connections {
            target: usbModeSelector
            onWindowVisibleChanged: if (usbModeSelector.windowVisible) usbDialog.shouldBeVisible = true
        }

        Behavior on opacity {
            NumberAnimation {
                duration: 250
                onRunningChanged: if (!running && usbDialog.opacity == 0) usbModeSelector.windowVisible = false
            }
        }
    }
}
