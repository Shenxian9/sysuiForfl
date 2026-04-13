/******************************************************************
Copyright © Deng Zhimao Co., Ltd. 2021-2030. All rights reserved.
* @brief         DashboardLayout.qml
* @author        Deng Zhimao
* @email         dengzhimao@alientek.com/1252699831@qq.com
* @date          2024-09-05
* @link          http://www.openedv.com/forum.php
*******************************************************************/
import QtQuick 2.12
import QtQuick.Layouts 1.12
Item {
    anchors.fill: parent

    onVisibleChanged: {
        if(!visible)
            dashBoardTimer.stop()
        else
            dashBoardTimer.start()
    }


    DashBoard {
        anchors.fill: parent
        id: dashBoard1
        Timer {
            id: dashBoardTimer
            repeat: true
            interval: 1500
            running: appMainBody.visible
            onTriggered: {
                dashBoard1.accelerating = !dashBoard1.accelerating
            }
        }
    }

    Rectangle {
        visible: false
        width: 180 * scaleFacter
        height: 200 * scaleFacter
        color: "#AA515151"
        radius: 10 * scaleFacter
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 120 * scaleFacter
        Text {
            text: qsTr("P")
            anchors.centerIn: parent
            font.pixelSize: 200 * scaleFacter
            color: "white"
            font.bold: true
        }
    }
}
