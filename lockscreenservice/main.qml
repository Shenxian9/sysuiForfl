/******************************************************************
Copyright © Deng Zhimao Co., Ltd. 2021-2030. All rights reserved.
* @brief         main.qml
* @author        Deng Zhimao
* @email         dengzhimao@alientek.com/1252699831@qq.com
* @date          2024-10-11
* @link          http://www.openedv.com/forum.php
*******************************************************************/
import QtQuick 2.12
import QtQuick.Window 2.12
import com.alientek.qmlcomponents 1.0
Window {
    visible: true
    width: Screen.desktopAvailableWidth + 1
    height: Screen.desktopAvailableHeight + 1
    id: window
    x: 0
    y: 0
    color: "transparent"
    flags: Qt.FramelessWindowHint
    property real scaleFacter: window.width / 1024

    SystemTime {
        id: systemTime
    }

    Image {
        id: phonebg
        anchors.centerIn: parent
        height: parent.height
        width: parent.width
        fillMode: Image.PreserveAspectCrop
        smooth: true
        source: "file://" + appCurrtentDir + "/../iphone/iphone/iphone.jpg"
    }

    Item {
        id: wallpaper
        x: 0
        y: 0
        height: parent.height
        width: parent.width
        //opacity: 1 - Math.abs(wallpaper.y) / wallpaper.height
        //fillMode: Image.PreserveAspectCrop
        smooth: true
        antialiasing: true
        //source: "file://" + appCurrtentDir + "/../iphone/iphone/iphone.jpg"
        Behavior on y { PropertyAnimation { duration: 300; easing.type: Easing.OutCubic } }
        onYChanged: {
            if (Math.abs(wallpaper.y) == wallpaper.height) {
                window.flags = Qt.FramelessWindowHint |  Qt.WindowTransparentForInput
                systemUICommonApiClient.askSystemUItohideOrShow(SystemUICommonApiClient.Show)
                window.hide()
                lockText.opacity = 1.0
            }
        }
        MouseArea {
            anchors.fill: parent
            drag.target: wallpaper
            drag.maximumX: 0
            drag.minimumX: 0
            drag.minimumY: -wallpaper.height
            drag.maximumY: 0
            onReleased: {
                if (wallpaper.y <= -wallpaper.height / 3) {
                    wallpaper.y = -wallpaper.height
                } else {
                    wallpaper.y = 0
                    lockText.opacity = 1.0
                }
            }
            onPositionChanged: function(mouse) {
                lockText.opacity = 0.0
            }
            onPressed: {
                lockText.opacity = 1.0
            }

        }
        Text {
            id: lockText
            opacity:  1 - Math.abs(wallpaper.y) / wallpaper.height
            y: parent.height - 128 - opacity * 10
            anchors.horizontalCenter: parent.horizontalCenter
            text: qsTr("向上轻扫以解锁")
            color: "white"
            font.pixelSize: 50 * scaleFacter
            Behavior on opacity { PropertyAnimation { duration: 1000; easing.type: Easing.Linear } }
        }
        //Dock {}

        Text {
            id : date
            anchors.top: parent.top
            anchors.topMargin: 256 * scaleFacter
            anchors.horizontalCenter: parent.horizontalCenter
            text: systemTime.system_date2 + " " + systemTime.system_week
            color: "white"
            font.pixelSize: 80 * scaleFacter
        }

        Text {
            id : time
            anchors.top: date.bottom
            anchors.horizontalCenter: parent.horizontalCenter
            text: systemTime.system_time
            color: "white"
            font.pixelSize: 250 * scaleFacter
        }
    }

    SystemUICommonApiClient {
        id: systemUICommonApiClient
        appName: "lockscreenservice"
        onActionCommand: {
            if (cmd === SystemUICommonApiClient.Show) {
                window.flags = Qt.FramelessWindowHint
                window.show()
                //window.requestActivate()
                wallpaper.y = 0
                systemUICommonApiClient.askSystemUItohideOrShow(SystemUICommonApiClient.Hide)
            }
            if (cmd === SystemUICommonApiClient.Quit)
                Qt.quit()
        }
    }
}
