/******************************************************************
Copyright © Deng Zhimao Co., Ltd. 2021-2030. All rights reserved.
* @brief         Page1.qml
* @author        Deng Zhimao
* @email         dengzhimao@alientek.com/1252699831@qq.com
* @date          2024-04-07
* @link          http://www.openedv.com/forum.php
*******************************************************************/
import QtQuick 2.12
import QtQuick.Layouts 1.12
import QtQuick.Controls 2.12
import com.alientek.qmlcomponents 1.0
Item {
    id: page1
    ApkListModel {
        id: apkListModel
        Component.onCompleted: apkListModel.add(appCurrtentDir + "/src/"+ hostName +"/apk1.cfg")
    }

    ColumnLayout {
        id: columnLayout2
        width: desktop.width
        height: desktop.height / 3 * 2
        anchors.top: parent.top
        anchors.topMargin: 64 * scaleFfactor
        GridView {
            Layout.alignment: Qt.AlignHCenter
            Layout.fillHeight: true
            width: desktop.width - desktop.width / 13
            height: desktop.width / 4 * 5
            id: item_gridView
            visible: true
            interactive: false
            clip: false
            snapMode: ListView.SnapOneItem
            cellWidth: item_gridView.width / 4
            cellHeight: cellWidth * 1.2
            model: apkListModel
            delegate: item_gridView_delegate
        }
    }

    Component {
        id: item_gridView_delegate
        Button {
            id: appButton
            width: item_gridView.cellWidth
            height: item_gridView.cellHeight
            enabled: installed
            onClicked: {
                launchActivity(programName)
            }

            background: Image {
                id: appIcon
                anchors.centerIn: parent
                width: 110 * scaleFfactor
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

            Text {
                anchors.bottom: parent.bottom
                anchors.bottomMargin: desktop.width / 720 * 5
                anchors.horizontalCenter: parent.horizontalCenter
                text: apkName
                color: "white"
                font.pixelSize: desktop.width / 720 * 25
                font.bold: true
            }
        }
    }
}
