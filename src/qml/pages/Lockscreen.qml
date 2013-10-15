import QtQuick 1.1
import com.nokia.meego 1.0
import es.zed.socam 0.1

import "./Lockscreen"
import "../components"

Image {
    id: lockScreen
    source: "file://" + wallpaperSource.value
    property bool animating: y != parent.y && y != parent.y-height
    property bool heightIsChanging: false

    /**
     * openingState should be a value between 0 and 1, where 0 means
     * the lockscreen is "down" (obscures the view) and 1 means the
     * lockscreen is "up" (not visible).
     **/
    property real openingState: (parent.y - y) / height


    Executor {
        id:executor
    }




    onHeightChanged: {
        /* Fixes: https://bugs.nemomobile.org/show_bug.cgi?id=521 */

        if (animating) {
            return;
        }

        heightIsChanging = true;
        if (LipstickSettings.lockscreenVisible) {
            show();
        } else {
            hide();
        }
        heightIsChanging = false;
    }

    function hide() {
        y = parent.y-height
    }

    function show() {
        y = parent.y
    }

    // can't use a binding, as we also assign y based on mousearea below
    Connections {
        target: LipstickSettings
        onLockscreenVisibleChanged: {
            if (LipstickSettings.lockscreenVisible)
                lockScreen.show()
            else
                lockScreen.hide()
        }
    }

    Behavior on y {
        id: yBehavior
        enabled: !mouseArea.fingerDown && !heightIsChanging
        PropertyAnimation {
            properties: "y"
            easing.type: Easing.OutBounce
            duration: 400
        }
    }

    MouseArea {
        id: mouseArea
        property int pressY: 0
        property bool fingerDown
        property bool ignoreEvents
        anchors.fill: unlockRectangle
        height: 200


        onPressed: {
            // ignore a press when we're already animating
            // this can cause jitter in the lockscreen, which
            // isn't really nice
            if (lockScreen.animating) {
                ignoreEvents = true
                return
            }

            fingerDown = true
            pressY = mouseY
        }

        onPositionChanged: {
            if (ignoreEvents)
                return

            var delta = pressY - mouseY
            pressY = mouseY + delta
            if (parent.y - delta > 0)
                return
            parent.y = parent.y - delta
        }

        onReleased: {
            if (ignoreEvents) {
                ignoreEvents = false
                return
            }

            fingerDown = false
            if (!LipstickSettings.lockscreenVisible || Math.abs(parent.y) > parent.height / 3) {
                LipstickSettings.lockscreenVisible = false

                // we must explicitly also set height, and
                // not rely on the connection for the corner-case
                // where the user drags the lockscreen while it's
                // animating up.
                lockScreen.hide()
            } else if (LipstickSettings.lockscreenVisible) {
                lockScreen.show()
            }
        }
    }

    LockscreenClock {
        id: lockscreenClock
        anchors {
            top: parent.top
            left: parent.left
            right: parent.right
        }
    }



    Rectangle {

        id: notificationsContainer
        anchors {
            top: lockscreenClock.bottom
            bottom: unlockRectangle.top
            horizontalCenter: parent.horizontalCenter
        }
        width: desktop.isPortrait ? parent.width*0.6 : parent.width*0.8

        color: "transparent"

        Flow {

            anchors.fill: parent
            spacing: 20

            NotificationIcon {

                id: callNotificationIcon
                width: desktop.isPortrait ? parent.width : 300
                height: 100
                visible: callNotifier.count > 0

                anchors {
                    horizontalCenter: parent.horizontalCenter
                    leftMargin: 100
                    rightMargin: 100
                }

                icon: "qrc:images/icons/shortcut-telephony.svg"
                notificationText: ""

                CallNotifier {

                    id: callNotifier

                    Component.onCompleted: {
                        callNotificationIcon.notificationText = count;
                    }

                    onModified: {
                        callNotificationIcon.notificationText = count;
                    }
                }

                Timer {
                    id:callsTimer
                     interval: 500
                     running: false
                     repeat: false
                     onTriggered: {
                         callNotifier.showUI();
                     }

                 }

                onClicked: {
                    lockScreen.hide();
                    callNotifier.showUI();
                    callsTimer.start();
                }

            }

            NotificationIcon {

                id: smsNotificationIcon
                width: desktop.isPortrait ? parent.width : 300
                height: 100
                visible: smsNotifier.count > 0

                anchors {
                    horizontalCenter: parent.horizontalCenter
                    leftMargin: 100
                    rightMargin: 100
                }

                icon: "qrc:images/icons/shortcut-msg.svg"
                notificationText: ""

                SMSNotifier {

                    id: smsNotifier

                    Component.onCompleted: {
                        smsNotificationIcon.notificationText = count;
                    }

                    onModified: {
                        smsNotificationIcon.notificationText = count;
                    }
                }

                Timer {
                    id:smsTimer
                     interval: 500
                     running: false
                     repeat: false
                     onTriggered: {
                         smsNotifier.showUI();
                     }

                 }

                onClicked: {
                    lockScreen.hide();
                    smsNotifier.showUI();
                    smsTimer.start();
                }

            }

        }

    }

    Rectangle {
        id: unlockRectangle
        anchors.bottom: parent.bottom
        color: "#000000"
        width: parent.width
        height: 70
        opacity: 0.4
    }

    Rectangle {
        id: innerRectangle
        color: "transparent"
        anchors.centerIn: unlockRectangle
        height: unlockText.paintedHeight
        width: unlockText.paintedWidth + unlockImage.paintedWidth
        Label {
            id: unlockText
            text: qsTr("Unlock")
            color: "white"
            font.pixelSize: 40
            opacity: 1
        }
        Image {
            id: unlockImage
            source: "qrc:/images/icons/caret.png"
            anchors.left: unlockText.right
            anchors.bottom: unlockText.bottom
            opacity: 1
        }

    }

}

