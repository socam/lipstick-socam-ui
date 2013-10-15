// import QtQuick 1.0 // to target S60 5th Edition or Maemo 5
import QtQuick 1.1
import es.zed.socam 0.1

Rectangle {

        id: shortcutcontainer
        color: "transparent"
        width: shortcutSize
        height: shortcutSize

        property string icon
        property string cmd: ""
        property bool isLaunching: false

        signal clicked

        Executor {
            id:executor
        }

        function startAnimation() {
            launchAnimation.start();
        }

        function stopAnimation() {
            launchAnimation.stop();
        }

        MouseArea {

            id: shortcutmousearea
            anchors.fill: parent

            Image {
                id: iconimage
                source: icon
                sourceSize.width: parent.width
                sourceSize.height: parent.height
                anchors.fill: parent
                anchors.horizontalCenter: parent.horizontalCenter

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

            onClicked: {
                console.log("AppShortcut:click cmd=" + cmd);
                shortcutcontainer.startAnimation();
                shortcutcontainer.clicked();
                if(cmd.length>0) {
                    console.log("Execute command:" + cmd);
                    executor.execute(cmd);
                } else {
                    console.log("No command set");
                }
                shortcutcontainer.stopAnimation();
            }

        }

}
