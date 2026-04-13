/******************************************************************
Copyright © Deng Zhimao Co., Ltd. 2021-2030. All rights reserved.
* @brief         WifiInfo.qml
* @author        Deng Zhimao
* @email         dengzhimao@alientek.com/1252699831@qq.com
* @date          2024-08-30
* @link          http://www.openedv.com/forum.php
*******************************************************************/
import QtQuick 2.12
import Connman 0.2
import QtQuick.Controls 2.12
Item {
    id: wifiInfo
    Button {
        id: backBt
        anchors.topMargin: 64 * scaleFfactor
        anchors.top: parent.top
        width: image.width + nameW.width
        height: 128 * scaleFfactor
        opacity: backBt.pressed ? 0.8 : 1.0
        onClicked: {
            wifiPageSwipeView.currentIndex = 0
        }
        background: Row {
            id: row
            Image {
                id: image
                source: "qrc:/icons/back.png"
                anchors.verticalCenter: parent.verticalCenter
                height: width
                width: 48 * scaleFfactor
                fillMode: Image.PreserveAspectFit
            }
            Text {
                id: nameW
                text: qsTr("无线局域网")
                color: "#4169e1"
                font.pixelSize: scaleFfactor * 35
                anchors.verticalCenter: parent.verticalCenter
            }
        }
    }

    Text {
        font.pixelSize: scaleFfactor * 30
        text: ns.name
        color: "black"
        width: parent.width / 3
        elide: Text.ElideRight
        horizontalAlignment: Text.AlignHCenter
        anchors.horizontalCenter: parent.horizontalCenter
        font.bold: true
        anchors.bottom: flickable.top
    }

    Timer {
        id: delayToRemoveServiesTimer
        interval: 200
        repeat: false
        running: false
        onTriggered: {
            wifiServicesSettings.remove()
        }
    }

    Connections {
        target: ns
        function onPathChanged() {
            wifiServicesSettings.path = ns.path
        }
        function onNameChanged() {
            wifiServicesSettings.name = ns.name
        }
    }

    Flickable {
        id: flickable
        anchors.top: parent.top
        anchors.topMargin: scaleFfactor * 150
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.bottom: parent.bottom
        contentHeight: column.height + scaleFfactor *  30
        clip: true
        Column {
            id: column
            spacing: 35 * scaleFfactor
            Button {
                id: btIgnore
                width: wifiInfo.width
                height: scaleFfactor * 80
                visible: ns.active
                background: Rectangle {
                    radius: 10
                    color: btIgnore.pressed ? "#DCDCDC" : "white"
                    Text {
                        color: "#4169e1"
                        anchors.left: parent.left
                        anchors.leftMargin: scaleFfactor * 10
                        anchors.verticalCenter: parent.verticalCenter
                        text: qsTr("忽略此网络")
                        font.pixelSize: scaleFfactor * 30
                    }
                }
                onClicked: {
                    // wifiServicesSettings.name = ns.name
                    // wifiServicesSettings.path = ns.path
                    // modelConnectedServices.data(modelConnectedServices.index(0, 0), 257).requestDisconnect()
                    // modelConnectedServices.data(modelConnectedServices.index(0, 0), 257).remove()
                    ns.requestDisconnect()
                    ns.remove()
                    delayToRemoveServiesTimer.restart()
                    wifiPageSwipeView.currentIndex = 0
                }
            }

            Button {
                id: btJoin
                visible: !ns.connected
                width: wifiInfo.width
                height: scaleFfactor * 80
                background: Rectangle {
                    radius: 20 * scaleFfactor
                    color: btJoin.pressed ? "#DCDCDC" : "white"
                    Text {
                        color: "#4169e1"
                        anchors.left: parent.left
                        anchors.leftMargin: scaleFfactor * 10
                        anchors.verticalCenter: parent.verticalCenter
                        text: qsTr("加入此网络")
                        font.pixelSize: scaleFfactor * 30
                    }
                }
                onClicked: {
                    if (ns.active)
                        ns.requestConnect()
                    else {
                        actionSheet.open()
                    }
                    wifiPageSwipeView.currentIndex = 0
                }
            }
        }
    }
}
