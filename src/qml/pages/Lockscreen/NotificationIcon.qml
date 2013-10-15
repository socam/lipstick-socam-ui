// import QtQuick 1.0 // to target S60 5th Edition or Maemo 5
import QtQuick 1.1
import com.nokia.meego 1.0
import "../../components"

Rectangle {

        id: notificationcontainer
        width: shortcutSize
        height: shortcutSize
        color: "transparent"

        property string icon
        property string cmd
        property bool isLaunching: false
        property string notificationText

        signal clicked()

        function startAnimation() {
            launchAnimation.start();
        }

        function stopAnimation() {
            launchAnimation.stop();
        }

        //background
        Rectangle {

            id: notificationbackground
            z:1
            anchors.fill: parent
            color: "black"
            opacity: 0.4
            clip: true

            Rectangle {

                id: reflectionBox
                width: parent.height * 2
                height: 100
                x: -100
                anchors.top: parent.top
                rotation: 45


                gradient: Gradient {
                    GradientStop { position: 0.0; color: '#00000000' }
                    GradientStop { position: 0.5; color: '#ffffffff' }
                    GradientStop { position: 1.0; color: '#00000000' }
                }

            }


            SequentialAnimation {

                running: true
                loops: Animation.Infinite

                NumberAnimation {
                    target: reflectionBox
                    property: "x"
                    from: -100
                    to: notificationcontainer.width
                    duration: 500
                }

                PauseAnimation {

                    duration: 1500

                }


            }





        }




        MouseArea {

            z: 2
            id: notificationmousearea
            anchors.fill: parent

            Image {
                id: iconimage
                source: icon
                anchors.top: parent.top
                anchors.bottom: parent.bottom
                anchors.left: parent.left
                width: 100

                SequentialAnimation {

                    id: launchAnimation
                    running: false
                    loops: 1
                    alwaysRunToEnd: true

                    NumberAnimation {
                        target: iconimage
                        property: "scale"
                        to: 0.6
                        duration: 700
                    }

                    NumberAnimation {
                        target: iconimage
                        property: "scale"
                        to: 1
                        duration: 700
                    }

                }

            }

            Label {
                id: smsText
                color: "white"
                anchors {
                    top: parent.top
                    bottom: parent.bottom
                    left: iconimage.right
                    right: parent.right
                }
                horizontalAlignment: TextInput.AlignHCenter
                verticalAlignment: Text.AlignVCenter

                font.pixelSize: 60
                text: notificationText
            }

            onClicked: {
                notificationbackground.color = "black"
                notificationcontainer.clicked();
            }

            onEntered: {
                notificationbackground.color = "#999999"
            }

            onExited: {
                notificationbackground.color = "black"
            }

        }

}
