/******************************************************************
Copyright © Deng Zhimao Co., Ltd. 2021-2030. All rights reserved.
* @brief         SettingsLayout.qml
* @author        Deng Zhimao
* @email         dengzhimao@alientek.com/1252699831@qq.com
* @date          2024-06-05
* @link          http://www.openedv.com/forum.php
*******************************************************************/
import QtQuick 2.0
import QtQuick.Layouts 1.12
import QtQuick.VirtualKeyboard 2.2
import QtQuick.VirtualKeyboard.Settings 2.2
import Connman 0.2
import com.alientek.qmlcomponents 1.0
import QtQuick.Controls 2.12

Item {
    id: settingsLayout
    anchors.fill: parent

    NetworkTechnology {
        id: networkTechnology
        path: "/net/connman/technology/wifi"
    }

    NetworkManager{
        id: networkManager
        onPassphraseIncorrect: {
            customDialog.title = "“" + name + "”" + "\n连接失败"
            customDialog.subTitle = "密码不正确或热点信号弱"
            customDialog.open()
        }
    }

    NetworkService{
        id: ns
    }

    WifiServicesSettings {
        id: wifiServicesSettings
    }

    TechnologyModel {
        id: modelConnectedServices
        name: "wifi"
        filter: TechnologyModel.ActiveConnectedServices
    }

    TechnologyModel {
        id: modelActiveNotConnectedServices
        name: "wifi"
        filter: TechnologyModel.ActiveNotConnectedServices
        onCountChanged: {
        }
    }

    TechnologyModel {
        id: modelNotActiveServices
        name: "wifi"
        filter: TechnologyModel.NotActiveServices
    }

    Rectangle {
        anchors.fill: parent
        color: "#eff2f7"
    }

    /*Rectangle {
        id: top_line
        anchors.top: parent.top
        anchors.topMargin: 60 * scaleFfactor
        width: parent.width
        height: 1
        color: "#ddc6c6c8"
        z: 5
    }*/

    Item {
        width: parent.width - 80 * scaleFfactor
        height: parent.height
        anchors.centerIn: parent
        SwipeView {
            id: settings_swipeView
            visible: true
            anchors.fill: parent
            clip: true
            currentIndex: 0
            interactive: false
            MainPage {
                visible: settings_swipeView.currentIndex === 0
                id: mainPage
            }
            Item {
                visible: settings_swipeView.currentIndex === 1
                Item {
                    anchors.top: parent.top
                    anchors.bottom: parent.bottom
                    anchors.right: parent.right
                    anchors.left: parent.left
                    anchors.margins: 25
                    Column {
                        spacing: 10
                        width: parent.width
                        anchors.centerIn: parent
                        Image {
                            id: logo
                            height: 256 * scaleFfactor
                            fillMode: Image.PreserveAspectFit
                            anchors.horizontalCenter: parent.horizontalCenter
                            source: "file://" + appCurrtentDir + "/resource/logo/alientek_logo.png"
                        }
                        Text {
                            text: qsTr("正点原子")
                            anchors.horizontalCenter: parent.horizontalCenter
                            font.pixelSize: 35 * scaleFfactor
                        }
                        Text {
                            width: parent.width
                            id: infoText
                            text: qsTr("　　广州市星翼电子科技有限公司（正点原子）是一家从事嵌入式开发平台、智能仪表、IoT物联网和企业服务等软硬件研发、\
销售一体化的国家高新技术企业。公司成立于2012年，是国内知名度较高的嵌入式开发平台供应商，产品远销东南亚欧美各国，国内数百家高校实验室和培训机构采用正点原子开发平台\
作为实验教学平台，累计服务超过100万电子工程师，1万＋企业用户。\n　　正点原子专注嵌入式教育和智能仪表，推出的STM32、Linux和FPGA等产品广受用户好评。\
申请了多项发明专利和著作权，出版了《原子教你玩STM32》、《原子嵌入式Linux驱动开发详解》\
和《原子教你玩FPGA》等10余本专业著作。与ST意法半导体、紫光同创、北航出版社、清华大学出版社等保持长期合作伙伴关系\
2017年被评为国家高新技术企业、2016年被评为广州科技创新小巨人、2023年被评为广东省专精特新企业等。\n　　更多信息，请关注https://www.alientek.com")
                            horizontalAlignment: Text.AlignLeft
                            font.pixelSize: 25 * scaleFfactor
                            wrapMode: Text.WrapAnywhere
                            color: "#88101010"
                            font.bold: false
                        }
                    }
                }
            }
            Item { visible: settings_swipeView.currentIndex === 2 }
            SwipeView {
                visible: settings_swipeView.currentIndex === 3
                id: wifiPageSwipeView
                interactive: false
                clip: true
                WifiLayout{}
                WifiInfo{}
            }
            General { visible: settings_swipeView.currentIndex === 4}

            Component.onCompleted: settings_swipeView.contentItem.highlightMoveDuration = 120
        }
    }
    Rectangle {
        color: "#22101010"
        anchors.fill: parent
        visible: actionSheet.opened
    }

    ActionSheet {
        id: actionSheet
        PasswordPanel{
            id: passwordPanel
        }
    }

    CustomDialog {
        id: customDialog
        modal: true
    }

    InputPanel {
        id: inputPanel
        z: 99
        x: 0
        y: appMainBody.height
        width: appMainBody.width
        states: State {
            name: "visible"
            when: inputPanel.active
            PropertyChanges {
                target: inputPanel
                y: appMainBody.height - inputPanel.height - 50
            }
        }
        transitions: Transition {
            from: ""
            to: "visible"
            reversible: true
            ParallelAnimation {
                NumberAnimation {
                    properties: "y"
                    duration: 50
                    easing.type: Easing.InOutQuad
                }
            }
        }
    }

    Binding {
        target: VirtualKeyboardSettings
        property: "activeLocales"
        value: ["en_US","zh_CN"]
    }

    // Rectangle {
    //     id: top_line
    //     anchors.top: parent.top
    //     anchors.topMargin: 128 * scaleFfactor
    //     width: parent.width
    //     height: 1
    //     color: "#ddc6c6c8"
    // }

    Button {
        id: backBt
        anchors.leftMargin: 40 * scaleFfactor
        anchors.left: parent.left
        anchors.top: parent.top
        anchors.topMargin: 64 * scaleFfactor
        width: 128 * scaleFfactor
        height: width
        visible: settings_swipeView.currentIndex !== 0 && !actionSheet.opened && wifiPageSwipeView.currentIndex !== 1
        background: Row {
            anchors.centerIn: parent
            Image {
                width: scaleFfactor * 48
                height: width
                source: "qrc:/icons/back.png"
                anchors.verticalCenter: parent.verticalCenter
            }
            Text {
                text: qsTr("设置")
                font.pixelSize: 40 * scaleFfactor
                color: "#4169e1"
                anchors.verticalCenter: parent.verticalCenter
            }
        }

        onClicked: settings_swipeView.currentIndex = 0
    }
}
