/******************************************************************
Copyright © Deng Zhimao Co., Ltd. 2021-2030. All rights reserved.
* @brief         AnimationControl.qml
* @author        Deng Zhimao
* @email         dengzhimao@alientek.com/1252699831@qq.com
* @date          2024-10-26
* @link          http://www.openedv.com/forum.php
*******************************************************************/
import QtQuick 2.12
import QtQuick.Controls 2.5
import com.alientek.qmlcomponents 1.0
Item {
    SystemControl {
        id: systemControl
        Component.onCompleted: { systemControl.onSystemuiconfChanged(); systemControl.checkMemoryInfo() }
    }
    Text {
        font.pixelSize: scaleFfactor * 35
        text: "通用"
        color: "black"
        font.bold: true
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.bottom: flickable.top
    }
    Flickable {
        id: flickable
        anchors.top: parent.top
        anchors.topMargin: scaleFfactor * 150
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.bottom: parent.bottom
        contentHeight: column.height + 1
        clip: true
        Column {
            id: column
            anchors.top: parent.top
            anchors.topMargin: scaleFfactor * 96
            width: parent.width
            spacing: 10

            Rectangle {
                radius: 20
                width: parent.width - 10
                height: scaleFfactor * 80
                Text {
                    font.pixelSize: scaleFfactor * 30
                    text: "系统信息"
                    color: "black"
                    id: systemInfoText
                    anchors.left: parent.left
                    anchors.leftMargin: scaleFfactor * 10
                    anchors.verticalCenter: parent.verticalCenter
                }

                Text {
                    font.pixelSize: scaleFfactor * 30
                    text: systemControl.memoryInfoMation
                    color: "black"
                    anchors.left: systemInfoText.right
                    anchors.leftMargin: scaleFfactor * 10
                    anchors.verticalCenter: parent.verticalCenter
                }
            }
            Text {
                anchors.left: parent.left
                anchors.leftMargin: scaleFfactor * 10
                anchors.right: parent.right
                anchors.rightMargin: scaleFfactor * 5
                font.pixelSize: scaleFfactor * 25
                color: "#808A87"
                text: "注：市面上的储存容量与实际计算容量是有区别的。市面储存设备容量1KB=1000Byte,而在程序里实际容量1KiB＝1024Byte。"
                wrapMode: Text.WrapAnywhere
            }

            Column {
                Button {
                    id: rebootBt
                    width: flickable.width - 10
                    height: scaleFfactor * 80
                    background: CustomRectangle {
                        radius: 10 * scaleFfactor
                        anchors.fill: parent
                        radiusCorners: Qt.AlignLeft | Qt.AlignRight | Qt.AlignTop
                        color: rebootBt.pressed ? "#DCDCDC" : "white"
                        Text {
                            anchors.left: parent.left
                            anchors.leftMargin: 25
                            color: rebootBt.pressed ? "white" : "#4169e1"
                            anchors.verticalCenter: parent.verticalCenter
                            font.pixelSize: 30 * scaleFfactor
                            text: qsTr("重启")
                        }
                    }
                    onClicked: {
                        window.hide()
                        systemControl.systemReboot()
                        systemControl.uiKillall()
                    }
                }

                Button {
                    id: exitBt
                    width: flickable.width - 10
                    height: scaleFfactor * 80
                    background: CustomRectangle {
                        color: exitBt.pressed ? "#DCDCDC" : "white"
                        Rectangle {
                            height: 1
                            width: flickable.width - 25
                            anchors.right: parent.right
                            color: "#DCDCDC"
                        }
                        radius: 20 * scaleFfactor
                        anchors.fill: parent
                        radiusCorners: Qt.AlignLeft | Qt.AlignRight | Qt.AlignBottom
                        Text {
                            anchors.left: parent.left
                            anchors.leftMargin: 25
                            color: exitBt.pressed ? "white" : "#4169e1"
                            anchors.verticalCenter: parent.verticalCenter
                            font.pixelSize: 30 * scaleFfactor
                            text: qsTr("退出")
                        }
                    }
                    onClicked: {
                        window.hide()
                        systemControl.uiKillall()
                        Qt.quit()
                    }
                }
            }
            Text {
                anchors.left: parent.left
                anchors.leftMargin: scaleFfactor * 10
                anchors.right: parent.right
                anchors.rightMargin: scaleFfactor * 5
                font.pixelSize: scaleFfactor * 25
                color: "#808A87"
                text: "退出将关闭所有Qt程序，重启桌面UI请在串口终端上执行/etc/init.d/S50systemui start指令"
                wrapMode: Text.WrapAnywhere
            }
        }
    }
}
