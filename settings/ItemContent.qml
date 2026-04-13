/******************************************************************
Copyright © Deng Zhimao Co., Ltd. 2021-2030. All rights reserved.
* @brief         ItemContent.qml
* @author        Deng Zhimao
* @email         dengzhimao@alientek.com/1252699831@qq.com
* @date          2024-08-29
* @link          http://www.openedv.com/forum.php
*******************************************************************/
import QtQuick 2.12
import QtQuick.Controls 2.12
import Connman 0.2
Item {
    anchors.fill: parent
    Text {
        font.pixelSize: scaleFfactor * 30
        text: networkService.name
        width: parent.width / 2
        elide: Text.ElideRight
        color: "black"
        anchors.verticalCenter: parent.verticalCenter
        anchors.left: parent.left
        anchors.leftMargin: scaleFfactor * 80
    }
    Row {
        anchors.right: parent.right
        anchors.rightMargin: scaleFfactor * 30
        anchors.verticalCenter: parent.verticalCenter
        spacing: 10
        Image {
            source: "qrc:/icons/wifi_lock_icon.png"
            fillMode: Image.PreserveAspectFit
            width: scaleFfactor * 32
            visible: networkService.securityType !== NetworkService.SecurityNone
            anchors.verticalCenter: parent.verticalCenter
        }

        Image {
            id: signal_icon
            width: scaleFfactor * 48
            height: width
            fillMode: Image.PreserveAspectFit
            anchors.verticalCenter: parent.verticalCenter
            source: if (networkService.strength < 40)
                        "qrc:/icons/wifi_singal_weak.png"
                    else if (networkService.strength >= 40 && networkService.strength < 60)
                        "qrc:/icons/wifi_singal_medium.png"
                    else
                        "qrc:/icons/wifi_singal_strong.png"
        }

        Button {
            id: info_icon
            width: scaleFfactor * 64
            focus: Qt.NoFocus
            height: width
            opacity: info_icon.pressed ? 0.8 : 1.0
            anchors.verticalCenter: parent.verticalCenter
            background: Image {
                source: "qrc:/icons/wifi_info_icon.png"
                anchors.verticalCenter: parent.verticalCenter
                width: scaleFfactor * 64
                fillMode: Image.PreserveAspectFit
            }
            onClicked: {
                ns.path = networkService.path
                wifiPageSwipeView.currentIndex = 1
            }
        }
    }
}
