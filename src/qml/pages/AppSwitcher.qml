
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
import "./AppSwitcher"
import "../components"

// App Switcher page
// The place for browsing already running apps

Item {

    property int columnNumber: 1
    property bool visibleInHome: false
    property AppLauncher launcher

    id: switcherRoot
    clip: false


    Component {
       id: gridviewheeader
       Rectangle {
           id: header
           color: "#3c3939"
           border.width: 1
           width: parent.width; height: 70
           Label {
               text: qsTr("Running programs")
               color: "white"
               font.pixelSize: 30
               anchors.fill: parent
               anchors.leftMargin: 20
               verticalAlignment: Text.AlignVCenter
           }
       }
     }

    // The actual app switcher grid
    GridView {
        id: gridview
        boundsBehavior: Flickable.StopAtBounds
        width: parent.width
        header: gridviewheeader
        cellWidth: parent.width
        cellHeight: 114
        anchors {
            top: parent.top
            bottom: parent.bottom
            horizontalCenter: parent.horizontalCenter
            bottomMargin: 35
        }

        model: SwitcherModel {
            id:switcherModel
        }

        delegate: Item {
            width: gridview.cellWidth
            height: gridview.cellHeight
            SwitcherItem {
                separator: 4
                width: parent.width
                height: parent.height
                anchors.centerIn: parent
            }
        }
    }

    // Empty switcher indicator
    Label {
        anchors.centerIn: parent
        visible: switcherModel.itemCount === 0
        text: qsTr("No apps open")
        color: "white"
        font.pixelSize: 30
    }

}
