/******************************************************************
Copyright © Deng Zhimao Co., Ltd. 2021-2030. All rights reserved.
* @projectName   QDesktop
* @brief         MainPage.qml
* @author        Deng Zhimao
* @email         dengzhimao@alientek.com
* @link          www.openedv.com
* @date          2021-10-27
*******************************************************************/
import QtQuick 2.12
import QtQuick.Controls 2.5

Item {
    id: mainPage

    Text {
        id: settingText1
        text: qsTr("设置")
        font.pixelSize: scaleFfactor * 80
        anchors.left: parent.left
        anchors.leftMargin: 10
        anchors.top: parent.top
        anchors.topMargin: 64 * scaleFfactor
    }


    Flickable {
        anchors.top: settingText1.bottom
        anchors.left: parent.left
        anchors.leftMargin: 0
        anchors.rightMargin: 0
        anchors.right: parent.right
        anchors.bottom: parent.bottom
        id: settings_flickable
        contentHeight: column.height
        contentWidth: parent.width
        clip: true
        visibleArea.onYPositionChanged: {
            //console.log(visibleArea.yPosition)
        }

        Column {
            id: column
            anchors.top: parent.top
            anchors.left: parent.left
            anchors.topMargin: 0
            spacing: scaleFfactor * 70
            anchors.horizontalCenter: parent.horizontalCenter

            ListModel {
                id: listModel

                ListElement {
                    itemName: "正点原子"
                    itemIcon: "qrc:/icons/alientek_logo.png"
                    itemHeight: 160
                    iconWidth: 128
                    underLineVisable: false
                    subText: qsTr("Alientek 关于正点原子")
                    corners: 0x0063
                }

                ListElement {
                    itemName: ""
                    itemHeight: 32
                    itemIcon: ""
                    iconWidth: 0
                    underLineVisable: false
                    subText: ""
                    corners: 0
                }

                ListElement {
                    itemName: "无线局域网"
                    itemIcon: "qrc:/icons/wifi_icon.png"
                    itemHeight: 80
                    iconWidth: 64
                    underLineVisable: true
                    subText: ""
                    corners: 0x0023
                }
                /*ListElement {
                    itemName: "蓝牙"
                    itemHeight: 50
                    itemIcon: "qrc:/icons/bluetooth_icon.png"
                    iconWidth: 35
                    underLineVisable: true
                    subText: ""
                    corners: 0
                }
                ListElement {
                    itemName: "个人热点"
                    itemHeight: 50
                    itemIcon: "qrc:/icons/connet_icon.png"
                    iconWidth: 35
                    underLineVisable: false
                    subText: ""
                    corners: 0x0043
                }
                ListElement {
                    itemName: ""
                    itemHeight: 10
                    itemIcon: ""
                    iconWidth: 0
                    underLineVisable: false
                    subText: ""
                    corners: 0
                }

                ListElement {
                    itemName: "声音"
                    itemHeight: 50
                    itemIcon: "qrc:/icons/volume_icon.png"
                    iconWidth: 35
                    underLineVisable: true
                    subText: ""
                    corners: 0x0023
                }

                ListElement {
                    itemName: "显示与亮度"
                    itemHeight: 50
                    itemIcon: "qrc:/icons/brightness_icon.png"
                    iconWidth: 35
                    underLineVisable: true
                    subText: ""
                    corners: 0
                }*/

                ListElement {
                    itemName: "通用"
                    itemHeight: 80
                    itemIcon: "qrc:/icons/device_icon.png"
                    iconWidth: 64
                    underLineVisable: false
                    subText: ""
                    corners: 0x0043
                }
            }

            ListView {
                id: listView
                width: parent.width
                height: settings_flickable.height
                model: listModel
                currentIndex: -1
                onCurrentIndexChanged : {
                    //settings_swipeView.currentIndex  = currentIndex + 1
                }
                delegate: CustomRectangle {
                    //color: ListView.isCurrentItem ? "#4ca2ff" : "white"
                    Behavior on color { PropertyAnimation { duration: 100; easing.type: Easing.Linear } }
                    radius: 25 * scaleFfactor
                    radiusCorners: corners
                    color: device_mouseArea.pressed ? "#DCDCDC" : "white"

                    MouseArea {
                        id: device_mouseArea
                        anchors.fill: parent
                        enabled: itemName !== ""
                        onClicked: {
                            listView.currentIndex = index
                            settings_swipeView.currentIndex  = index + 1
                        }
                    }
                    height: itemHeight * scaleFfactor
                    width: listView.width
                    opacity: itemHeight === 32 ? 0 : 1.0
                    Rectangle {
                        id: line_net1
                        anchors.left: image.right
                        anchors.right: parent.right
                        height: 1
                        color: "#DCDCDC"
                        visible: underLineVisable
                        anchors.bottom: parent.bottom
                    }
                    Image {
                        id: image
                        width:  scaleFfactor * iconWidth
                        height: width
                        source: itemIcon
                        anchors.verticalCenter: parent.verticalCenter
                        anchors.left: parent.left
                        anchors.leftMargin: scaleFfactor * 10
                    }
                    Column {
                        anchors.verticalCenter: parent.verticalCenter
                        anchors.left: image.right
                        anchors.leftMargin: image.anchors.leftMargin
                        Text {
                            text: itemName
                            //color: index === listView.currentIndex  ? "white" : "black"
                            font.pixelSize: subText !== "" ? scaleFfactor * 40 : scaleFfactor * 35
                            font.weight: subText !== ""  ? Font.Medium : Font.Normal
                        }

                        Text {
                            text: subText
                            color: "black"
                            font.pixelSize: scaleFfactor * 30
                            visible: subText !== ""
                        }
                    }
                }
            }
        }
    }
}
