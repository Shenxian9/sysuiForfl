/******************************************************************
Copyright 2022 Guangzhou ALIENTEK Electronincs Co.,Ltd. All rights reserved
Copyright © Deng Zhimao Co., Ltd. 1990-2030. All rights reserved.
* @projectName   player
* @brief         mediaListView.qml
* @author        Deng Zhimao
* @email         dengzhimao@alientek.com/1252699831@qq.com
* @date          2022-11-21
* @link          http://www.openedv.com/forum.php
*******************************************************************/
import QtQuick 2.12
import QtQuick.Controls 2.5
import com.alientek.qmlcomponents 1.0
Item {
    Text {
        text: "视频列表"
        font.bold: true
        font.pixelSize: 50 * scaleFfactor
        anchors.bottom: mediaGridView.top
        anchors.left: mediaGridView.left
        anchors.leftMargin: 10 * scaleFfactor
    }
    id: mediaListView

    GridView  {
        anchors.top: parent.top
        anchors.topMargin: 142 * scaleFfactor
        width: parent.width
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 36
        id: mediaGridView
        visible: true
        clip: true
        model: mediaModel
        cellWidth: mediaGridView.width / 2
        cellHeight: cellWidth * 1.2
        onCountChanged: {
            mediaGridView.currentIndex = -1
        }

        Component.onCompleted:  mediaGridView.currentIndex = -1

        onFlickEnded: scrollBar.visible = false
        onFlickStarted: scrollBar.visible = true
        ScrollBar.vertical: ScrollBar {
            id: scrollBar
            width: scaleFfactor * 10
            visible: false
            background: Rectangle {color: "transparent"}
            onActiveChanged: {
                active = true;
            }
            Component.onCompleted: {
                scrollBar.active = true;
            }
            contentItem: Rectangle{
                implicitWidth: scaleFfactor * 15
                implicitHeight: scaleFfactor * 100
                radius: scaleFfactor * 10
                color: scrollBar.pressed ? "#88101010" : "#30101010"
            }
        }

        delegate: Item {
            id: itembg
            width: mediaGridView.cellWidth
            height: mediaGridView.cellHeight
            Rectangle {
                id: rectPanel
                radius: 10
                anchors.centerIn: parent
                width: mediaGridView.cellWidth - scaleFfactor * 10
                height: mediaGridView.cellHeight - scaleFfactor * 10
                MouseArea {
                    id: mouseArea
                    anchors.fill: parent
                    onClicked: {
                        swipeView.currentIndex = 1
                        mediaGridView.currentIndex = index
                        mediaModel.currentIndex = index
                        mediaPlayer.play()
                    }
                    Connections {
                        target: mediaModel
                        function onUpdateCoverplan() {
                            moviesCoverplan.source = ""
                            moviesCoverplan.source = content
                        }
                    }

                    AlbumImage {
                        id: moviesCoverplan
                        source: content
                        anchors.top: parent.top
                        anchors.left: parent.left
                        anchors.right: parent.right
                        height: parent.height * 0.6
                        radius: 10
                        opacity: mouseArea.pressed ? 0.8 : 1.0
                        visible: true
                    }
                    // Image {
                    //     id: moviesCoverplan
                    //     source: content
                    //     anchors.top: parent.top
                    //     anchors.left: parent.left
                    //     anchors.right: parent.right
                    //     height: parent.height * 0.6
                    //     fillMode: Image.PreserveAspectCrop
                    //     opacity: mouseArea.pressed ? 0.8 : 1.0
                    //     visible: true
                    // }

                    Text {
                        id: moviesName
                        text: qsTr(title)
                        anchors.bottom: up.top
                        width: parent.width - scaleFfactor * 20
                        anchors.horizontalCenter: parent.horizontalCenter
                        font.pixelSize: scaleFfactor * 30
                        color: "black"
                        horizontalAlignment: Text.AlignLeft
                        wrapMode: Text.WrapAnywhere
                    }
                    Text {
                        id: up
                        text: qsTr("up: 正点原子")
                        anchors.bottom: parent.bottom
                        anchors.bottomMargin: 10 * scaleFfactor
                        width: parent.width - scaleFfactor * 20
                        anchors.horizontalCenter: parent.horizontalCenter
                        font.pixelSize: scaleFfactor * 30
                        color: "#808080"
                    }
                }
            }
        }
    }
}
