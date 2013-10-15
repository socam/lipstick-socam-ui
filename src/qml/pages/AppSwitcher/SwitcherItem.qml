
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
import com.nokia.meego 1.0
import "."
import "../../components"

Rectangle {

    id: switcherItemRoot
    property int separator: 0
    color: "#202020"

    Item {

		id: item
		anchors.fill: parent
        height: 110

        Rectangle {

			height: parent.height
			id: itemBackground
			anchors.fill: parent
            color: switcherItemRoot.color


            // Application icon
            Image {
                id: switcherItemIconImage
                source: model.object.icon == "" ? ":/images/icons/apps.png" : (model.object.icon.indexOf("/") == 0 ? "file://" : "image://theme/") + model.object.icon
                anchors {
                    leftMargin: 10
                    verticalCenter: parent.verticalCenter
                    left: parent.left
                }
                width: 80
                height: width
                asynchronous: true
                onStatusChanged: {
                    if (status === Image.Error) {
                        console.log("Error loading an app icon, falling back to default.");
                        iconImage.source = ":/images/icons/apps.png";
                    }
                }

            }

            Rectangle {

                id: containing_rect
                anchors {
                    left: switcherItemIconImage.right
                    leftMargin: 15
                }

                width: 200
                height: parent.height
                color: "transparent"

                Label {
                        id: text_field
                        anchors {
                            verticalCenter: parent.verticalCenter
                        }
                        text: model.object.title
                        wrapMode: Text.WordWrap
                        width: parent.width
                        color: "white"
                        font.pixelSize: 30
                }

            }

		}

	}


    ImageButton {

		id: closeButton
		scale: 1
		opacity: scale
        source: 'qrc:/images/icons/appswitcher-close.svg'
        height: 50
        width: 50

        anchors {
            right: goButton.left
            verticalCenter: parent.verticalCenter
            rightMargin: 40
		}

		onClicked: windowManager.closeWindow(model.object.window)

	}

    ImageButton {
		id: goButton
		scale: 1
		opacity: scale
        source: 'qrc:/images/icons/appswitcher-go.svg'
        height: 50
        width: 25
        anchors {
            right: parent.right
            verticalCenter: parent.verticalCenter
            rightMargin: 20
		}
		onClicked: {
			windowManager.windowToFront(model.object.window);
		}
	}


	Rectangle {
		id: separator
 		width: parent.width
		height: parent.separator
		color: "#3c3939"
		anchors {
		    top: parent.bottom
		    topMargin: -4
		}
	}



}
