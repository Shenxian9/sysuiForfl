/******************************************************************
Copyright © Deng Zhimao Co., Ltd. 2021-2030. All rights reserved.
* @brief         BottomApp.qml
* @author        Deng Zhimao
* @email         dengzhimao@alientek.com/1252699831@qq.com
* @date          2024-04-07
* @link          http://www.openedv.com/forum.php
*******************************************************************/
import QtQuick 2.0
import QtQuick.Controls 2.12
import com.alientek.qmlcomponents 1.0
Item {
    anchors.fill: parent
    ApkListModel {
        id: apkListModel
        Component.onCompleted: apkListModel.add(appCurrtentDir + "/src/"+ hostName +"/apk3.cfg")
    }

    Rectangle {
        id: bottom_app_rect
        clip: true
        anchors.fill: bottom_appItem_parent
        radius: bottom_appItem_parent.height / 2.5
        color: "#55f0f0f0"
        visible: true
    }

    Item {
        id: bottom_appItem_parent
        width: item_listView.contentWidth
        height: desktop.uiWidth / 4.4
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 32 * scaleFfactor

        ListView {
            id: item_listView
            visible: true
            anchors.centerIn: parent
            height: desktop.uiWidth / 6.5 * 1.5
            width: item_listView.contentWidth
            interactive: false
            orientation: ListView.Horizontal
            currentIndex: -1
            clip: true
            snapMode: ListView.SnapOneItem
            model: apkListModel
            delegate: item_listView_delegate
            spacing: 0
        }
    }

    Component {
        id: item_listView_delegate
        Button {
            id: appButton
            width: desktop.uiWidth / 4.4
            height: width
            enabled: installed
            onClicked: {
                launchActivity(programName)
            }
            background: Image {
                id: appIcon
                anchors.centerIn: parent
                width: desktop.uiWidth / 6.5
                height: width
                source: apkIconPath
                visible: systemUICommonApiServer.currtentLauchAppName !== programName
                Rectangle {
                    radius: 20 * scaleFfactor
                    color: "#33101010"
                    anchors.fill: parent
                    visible: appButton.pressed
                }
            }

           Image {
                id: appIcon2
                anchors.centerIn: parent
                width: appIcon.width
                height: width
                source: apkIconPath
                visible: systemUICommonApiServer.coldLaunch
                Rectangle {
                    radius: 20 * scaleFfactor
                    color: "#33101010"
                    anchors.fill: parent
                    visible: appButton.pressed
                }
            }
        }
    }
}
