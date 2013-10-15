
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

import org.nemomobile.lipstick 0.1
import org.nemomobile.configuration 1.0
import org.nemomobile.time 1.0
import es.zed.socam 0.1

import com.nokia.meego 1.0

import "./components"
import "./pages"


// The item representing the main screen; size is constant
PageStackWindow {

    id: mainWindow
	platformStyle: PageStackWindowStyle {
         cornersVisible : false;
	}


    onOrientationChangeStarted: {
        currentScreenIndicator.orientationChangeStarted();
    }

    onOrientationChangeFinished: {
        currentScreenIndicator.orientationChangeFinished();
    }

    property color screenIndicatorForegroundColor: '#9bc3d5'
    property color screenIndicatorBackgroundColor: 'white'
    property int screenIndicatorHeight: 10


    // This is used in the home page and in the lock screen
    WallClock {
        id: wallClock
        enabled: true /* XXX: Disable when display is off */
        updateFrequency: WallClock.Minute
    }

    // This is used in the lock screen
    ConfigurationValue {
        id: wallpaperSource
        key: desktop.isPortrait ? "/desktop/meego/background/portrait/picture_filename" : "/desktop/meego/background/landscape/picture_filename"
        defaultValue: "images/graphics-wallpaper-home.jpg"
    }

    initialPage: Page {

        Item {

            id: desktop
            property bool isPortrait: width < height

            anchors.fill: parent


            // Current screen indicator

            Rectangle {

                id: currentScreenIndicator
                z:101
                width: parent.width
                height: screenIndicatorHeight
                color: screenIndicatorBackgroundColor

                property int currentScreen: 0
                property int indicator1Index: 0
                property int indicator2Index: pager.count
                property int newX1: 0
                property int newX2: pager.width
                property int sections: pager.count


                Rectangle {
                    id: currentScreenIndicator1
                    z:102
                    height:parent.height
                    width: parent.width/pager.count
                    color: screenIndicatorForegroundColor
                    x: 0
                }

                Rectangle {
                    id: currentScreenIndicator2
                    z:102
                    height:parent.height
                    width: parent.width/pager.count
                    color: screenIndicatorForegroundColor
                    x: parent.width
                }


                function orientationChangeStarted() {
                    currentScreenIndicator1.visible = false;
                    currentScreenIndicator2.visible = false;
                }

                function orientationChangeFinished() {

                    var sectionWidth = Math.floor(currentScreenIndicator.width/sections);
                    console.log("orientationChanged sectionWidth=", sectionWidth);
                    newX1 = indicator1Index*sectionWidth;
                    currentScreenIndicator1.x = newX1;
                    currentScreenIndicator1.visible = true;
                    newX2 = indicator2Index*sectionWidth;
                    currentScreenIndicator2.x = newX2;
                    currentScreenIndicator2.visible = true;

                }



                function update() {

                    var forward = false;
                    if ( (currentScreen+1)%pager.count == pager.currentIndex) {
                        forward = true;
                    }

                    var sectionWidth = Math.floor(currentScreenIndicator.width/sections);
                    var increment = forward?1:-1;

                    indicator1Index += increment;
                    if (indicator1Index > sections*2-2 ) {
                        indicator1Index = -1;
                    } else if(indicator1Index < -1) {
                        indicator1Index = sections*2-2;
                    }

                    indicator2Index += increment;
                    if (indicator2Index > sections*2-2 ) {
                        indicator2Index = -1;
                    } else if(indicator2Index < -1) {
                        indicator2Index = sections*2-2;
                    }

                    newX1 = indicator1Index*sectionWidth;
                    newX2 = indicator2Index*sectionWidth;
                    if(indicator1Index>=0 && indicator1Index<=sections) {
                        changeCurrentScreenAnimationX1.start();
                    } else{
                        currentScreenIndicator1.x = newX1
                    }

                    if(indicator2Index>=0 && indicator2Index<=sections) {
                        changeCurrentScreenAnimationX2.start();
                    } else{
                        currentScreenIndicator2.x = newX2
                    }

                    currentScreen = pager.currentIndex;

                }

                NumberAnimation {
                    id: changeCurrentScreenAnimationX1
                    loops: 1
                    alwaysRunToEnd: true
                    target: currentScreenIndicator1
                    property: "x"
                    to: currentScreenIndicator.newX1
                    duration: 200
                }

                NumberAnimation {
                    id: changeCurrentScreenAnimationX2
                    loops: 1
                    alwaysRunToEnd: true
                    target: currentScreenIndicator2
                    property: "x"
                    to: currentScreenIndicator.newX2
                    duration: 200
                }

            }

            // Pager for swiping between different pages of the home screen

            Pager {

                id: pager

                QtDbusNotifier {
                    id: notifier
                }

                scale: 0.8 + 0.2 * lockScreen.openingState
                opacity: lockScreen.openingState

                anchors {
                    top: currentScreenIndicator.bottom
                    left: parent.left
                    right: parent.right
                    bottom: parent.bottom
                }

                model: VisualItemModel {
                    Home {
                        id: home
                        width: pager.width
                        height: pager.height
                    }
                    AppLauncher {
                        id: launcher
                        height: pager.height
                        objectName: "launcher"
                    }
                    AppSwitcher {
                        id: switcher
                        width: pager.width
                        height: pager.height
                        columnNumber: 2
                        visibleInHome: x > -width && x < desktop.width
                    }
                }

                // Initial view should be the AppLauncher
                currentIndex: 0

                onCurrentIndexChanged: {
                    notifier.notifyScreenChanged(currentIndex);
                    currentScreenIndicator.update();
                    console.log("onCurrentIndexChanged(2) ", currentIndex, "!!!!!!!!!!!!!!!!!!!!!!!!!!!!!");
                }
            }

            Lockscreen {
                id: lockScreen

                width: parent.width
                height: parent.height

                z: 200
            }


        }

    }

    Component.onCompleted: {
        theme.inverted = true;
    }
}
