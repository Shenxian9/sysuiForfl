/******************************************************************
Copyright © Deng Zhimao Co., Ltd. 2021-2030. All rights reserved.
* @brief         AppMainBody.qml
* @author        Deng Zhimao
* @email         dengzhimao@alientek.com/1252699831@qq.com
* @date          2024-08-16
* @link          http://www.openedv.com/forum.php
*******************************************************************/
import QtQuick 2.12
Rectangle {
    property real scaleFfactor: parent.width / 720
    anchors.fill: parent
    color: "black"

    /*Text {
        text: "ov5640"
        anchors.centerIn: parent
        color: "white"
        font.pixelSize: scaleFfactor * 20
    }*/

    Loader {
        active: true
        asynchronous: true
        id: loader
        anchors.fill: parent
        source: "CameraLayout.qml"
    }
}
