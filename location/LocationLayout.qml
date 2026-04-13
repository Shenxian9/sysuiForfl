/******************************************************************
Copyright © Deng Zhimao Co., Ltd. 2021-2030. All rights reserved.
* @projectName   weather
* @brief         WeatherLayout.qml
* @author        Deng Zhimao
* @email         dengzhimao@alientek.com/1252699831@qq.com
* @link          www.openedv.com
* @date          2023-04-06
* @link          http://www.openedv.com/forum.php
*******************************************************************/
import QtQuick 2.0
import QtQuick.Layouts 1.12
import com.alientek.qmlcomponents 1.0
Rectangle {
    id: weatherBg
    color: "#6391cf" // #232730
    property real scaleFfactor: window.width / 720
    anchors.fill: parent

    NetworkPosition {
        id: networkPosition
        Component.onCompleted: networkPosition.refreshPosition()
        interval: 30 // 30 min
    }

    Item {
        anchors.centerIn: parent
        Row {
            spacing: 5
            anchors.centerIn: parent
            Text {
                text: networkPosition.cityName + networkPosition.position + networkPosition.area
                font.pixelSize: scaleFfactor * 50
                color: "white"
            }
            Image {
                source: "qrc:/icons/location.png"
                anchors.verticalCenter: parent.verticalCenter
            }
        }
    }


    Rectangle {
        id: bottomRect
        Rectangle {
            width: parent.width
            height: 1
            color: "gray"
        }
        anchors.bottom: parent.bottom
        width: parent.width
        height: scaleFfactor * 128
        color: weatherBg.color
        Text {
            anchors.centerIn: parent
            text: qsTr("请连接网络获取网络定位")
            font.pixelSize: 30 * scaleFfactor
            color: "#55ffffff"
        }
        Image {
            visible: false
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.top: parent.top
            anchors.topMargin: scaleFfactor * 10
            source: "qrc:/icons/location.png"
        }
    }
}
