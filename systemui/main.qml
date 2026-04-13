/******************************************************************
Copyright © Deng Zhimao Co., Ltd. 2021-2030. All rights reserved.
* @brief         main.qml
* @author        Deng Zhimao
* @email         dengzhimao@alientek.com/1252699831@qq.com
* @date          2024-04-07
* @link          http://www.openedv.com/forum.php
*******************************************************************/
import QtQuick 2.12
import QtQuick.Window 2.12
import QtQuick.Controls 2.12
import QtQuick.Layouts 1.12
import com.alientek.qmlcomponents 1.0
Window {
    width: Screen.desktopAvailableWidth
    height: Screen.desktopAvailableHeight
    visible: true
    property real scaleFfactor: rotatedRoot.width / 720
    property bool rotateLeft90: true
    flags: Qt.FramelessWindowHint
    x: 0
    y: 0
    id: desktop

    SystemUICommonApiServer {
        id: systemUICommonApiServer
        onRequestVisibilityChange: function(action) {
            if (action === SystemUICommonApiServer.Hide) {
                rootItem.enabled = false
                //desktop.hide()
            }
            if (action === SystemUICommonApiServer.Show) {
                rootItem.enabled = true
                desktop.show()
                desktop.raise()
                indicatorShowTimer.start()
                systemUICommonApiServer.currtentLauchAppName = ""
            }
        }
        onCurrtentLauchAppNameChanged: {
            if (systemUICommonApiServer.currtentLauchAppName === "null")
                systemUICommonApiServer.requestVisibilityChange(SystemUICommonApiServer.Show)
        }
    }

    Item {
        id: rotatedRoot
        width: desktop.rotateLeft90 ? desktop.height : desktop.width
        height: desktop.rotateLeft90 ? desktop.width : desktop.height
        x: 0
        y: desktop.rotateLeft90 ? desktop.width : 0
        rotation: desktop.rotateLeft90 ? -90 : 0
        transformOrigin: Item.TopLeft

        Item {
            id: rootItem
            anchors.fill: parent
            Image {
                id: phonebg
                anchors.centerIn: parent
                height: parent.height
                width: parent.width
                fillMode: Image.PreserveAspectCrop
                smooth: true
                source: "file://" + appCurrtentDir + "/src/iphone/iphone/iphone.jpg"
                /*Rectangle {
                    anchors.fill: parent
                    color: "#22404040"
                }*/
            }

            SwipeView {
                id: main_swipeView
                visible: true
                anchors.fill: parent
                clip: true
                Page1 {}
                Page2 {}
            }
            BottomApp {}
            Timer {
                repeat: false
                id: indicatorShowTimer
                onTriggered: explainText.opacity = 1
                interval: 1000
            }
            Connections {
                target: main_swipeView
                function onCurrentIndexChanged() {
                    explainText.opacity = 0
                    indicatorShowTimer.restart()
                }
            }
            PageIndicator {
                id: indicator
                count: main_swipeView.count
                visible: true
                currentIndex: main_swipeView.currentIndex
                anchors.bottom: parent.bottom
                anchors.bottomMargin: scaleFfactor * 250
                anchors.horizontalCenter: parent.horizontalCenter
                delegate: indicator_delegate
                Button {
                    width: 100 * scaleFfactor
                    height: 50 * scaleFfactor
                    anchors.centerIn: parent
                    id: explainBt
                    opacity: explainBt.pressed ? 0.5 : 1.0
                    background: Rectangle {
                        color: "#44ffffff"
                        anchors.fill: parent
                        radius: height / 2
                        Text {
                            Behavior on opacity { PropertyAnimation { duration: 500; easing.type: Easing.Linear } }
                            id: explainText
                            opacity: 1
                            text: qsTr("搜索")
                            color: "white"
                            font.pixelSize: 25 * scaleFfactor
                            anchors.centerIn: parent

                        }
                    }
                    onClicked: {
                    }
                }
                Component {
                    id: indicator_delegate
                    Rectangle {
                        opacity: 1 - explainText.opacity
                        width: scaleFfactor * 10
                        height: width
                        color: main_swipeView.currentIndex !== index  ? "gray" : "#dddddd"
                        radius: scaleFfactor * 5
                        anchors.verticalCenter: parent.verticalCenter
                    }
                }
            }
        }

        RowLayout {
            visible: true
            height: rotatedRoot.width / 720 * 64
            anchors.left: parent.left
            anchors.leftMargin: rotatedRoot.width / 720 * 64
            anchors.right: parent.right
            anchors.rightMargin: rotatedRoot.width / 720 * 64
            Text {
                id: timeText
                text: systemTime.system_time
                font.bold: true
                color: "white"
                font.pixelSize: rotatedRoot.width / 720 * 30
                font.letterSpacing: 3
                Layout.alignment: Qt.AlignVCenter
            }

            Text {
                id: dateText
                text: systemTime.system_date2
                font.bold: false
                color: "white"
                visible: false
                font.pixelSize: rotatedRoot.width / 720 * 15
                font.letterSpacing: 3
                Layout.alignment: Qt.AlignVCenter
            }

            Text {
                id: weekText
                text: systemTime.system_week
                font.bold: false
                visible: false
                color: "white"
                font.pixelSize: rotatedRoot.width / 720 * 15
                font.letterSpacing: 3
                Layout.alignment: Qt.AlignVCenter
            }
            Item {
                Layout.fillWidth: true
            }

            Rectangle {
                width: 48
                height: 26
                radius: 8
                color: "#DDDDDD"
                Layout.alignment: Qt.AlignVCenter
                Rectangle {
                    width: 4
                    height: 8
                    color: "#DDDDDD"
                    radius: 4
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.left: parent.right
                    anchors.leftMargin: 1
                }
                Text {
                    anchors.centerIn: parent
                    font.pixelSize: 20
                    color: "#bfbfbf"
                    text: qsTr("100")
                }
            }
        }
    }


    function launchActivity(name) {
        rootItem.enabled = false
        indicatorShowTimer.stop()
        systemUICommonApiServer.launchApp(name)
    }


    SystemTime {
        id: systemTime
        enabled: rootItem.enabled
    }
}
