/******************************************************************
Copyright © Deng Zhimao Co., Ltd. 1990-2030. All rights reserved.
* @projectName   Photoview
* @brief         DisplayPhoto.qml
* @author        Deng Zhimao
* @email         1252699831@qq.com
* @date          2020-07-16
*******************************************************************/
import QtQuick 2.9
import QtQuick.Window 2.2
import QtQuick.Controls 1.4
import QtQuick.Controls 2.5
import QtQuick.Layouts 1.12
Item {
    id: displayView
    Connections {
        target: photoListModel
        function onCurrentIndexChanged() {
            viewController.currentIndex = photoListModel.currentIndex
        }
    }

    Rectangle {
        anchors.centerIn: parent
        width: parent.width
        height: window.height
        id: coverflowBg
        color: "white"
    }

    property int varDuration: 0
    PathView  {
        id: viewController
        anchors.fill: parent
        pathItemCount: 3
        currentIndex: -1
        model: photoListModel
        highlightMoveDuration: autoPlayBt.checked ? 200 : 0
        snapMode: PathView.SnapOneItem
        Component.onCompleted: positionViewAtIndex(photoListModel.currentIndex,  PathView.Beginning)
        delegate: Image {
            id: imageShow
            width: parent.width
            height: parent.height
            source: photo.path
            //scale: bt.checked && imageShow.PathView.isCurrentItem ? 1.0 : PathView.viewScale
            //z: PathView.viewZ
            //opacity: PathView.viewOpacity
            fillMode: Image.PreserveAspectCrop
            Behavior on scale { PropertyAnimation {id: animation; duration: varDuration; easing.type: Easing.Linear } }
            Button {
                id: bt
                opacity: 0
                anchors.fill: parent
                checkable: true
                enabled: imageShow.PathView.isCurrentItem
                onCheckedChanged: {
                    if (checked) {
                        varDuration = 200
                        row1.visible = false
                    } else {
                        if (imageShow.PathView.isCurrentItem)
                            row1.visible = true
                    }
                }
            }
            Connections {
                target: viewController
                function onCurrentIndexChanged() {
                    if (index !== viewController.currentIndex)
                        bt.checked = false
                }
            }
        }
        onCurrentIndexChanged: {
            varDuration = 0
            //row1.visible = true
        }

        preferredHighlightBegin: 0.5
        preferredHighlightEnd: 0.5

        path:  Path {
            id: viewControllerPath
            startX: - viewController.width // /2
            startY: viewController.height / 2

            PathAttribute { name: "viewScale"; value: 1.0} // 0.5
            PathAttribute { name: "viewZ"; value: 0}
            //PathAttribute { name: "viewOpacity"; value:0.5}

            PathLine { x: viewController.width / 2 ; y: viewController.height / 2}
            PathAttribute { name: "viewScale"; value: 1.0}
            PathAttribute { name: "viewZ"; value: 5}
            //PathAttribute { name: "viewOpacity"; value: 1.0}

            PathLine { x: viewController.width + viewController.width; y:viewController.height / 2} //x: + xx/2
            PathAttribute { name: "viewScale"; value: 1.0 }
            PathAttribute { name: "viewZ"; value: 0}
            //PathAttribute { name: "viewOpacity"; value: 0.5}
            PathPercent { value: 1.0}
        }
    }
    Rectangle {
        width: parent.width
        height: 128 * scaleFfactor
        anchors.bottom: parent.bottom
        visible: row1.visible
    }

    Row {
        id: row1
        visible: true
        anchors.bottom: parent.bottom
        anchors.bottomMargin: scaleFfactor * 32
        anchors.horizontalCenter: parent.horizontalCenter
        height: scaleFfactor * 64
        spacing:  scaleFfactor * 120
        Button {
            id: shareBt
            width: parent.height
            height: width
            opacity: 0.2
            background: Image {
                width: scaleFfactor * 64
                height: width
                anchors.centerIn: parent
                source: "qrc:/icons/share.png"
            }
        }

        Button {
            id: favariteBt
            width: parent.height
            height: width
            opacity: 0.2
            background: Image {
                width: scaleFfactor * 64
                height: width
                anchors.centerIn: parent
                source: "qrc:/icons/favorite.png"
            }
        }

        Button {
            id: infoBt
            width: parent.height
            height: width
            opacity: 0.2
            background: Image {
                width: scaleFfactor * 64
                height: width
                anchors.centerIn: parent
                source: "qrc:/icons/info.png"
            }
        }

        Button {
            id: deleteBt
            width: parent.height
            height: width
            opacity: deleteBt.pressed ? 0.8 : 1.0
            background: Image {
                width: scaleFfactor * 64
                height: width
                anchors.centerIn: parent
                source: "qrc:/icons/delete.png"
            }
            onClicked: {
                deletePage.visible = true
            }
        }
    }
    Rectangle {
        width: parent.width
        anchors.top: parent.top
        anchors.bottom: rowLayout.bottom
        anchors.bottomMargin: -32
        visible: rowLayout.visible
    }

    RowLayout {
        id: rowLayout
        anchors.top: parent.top
        anchors.topMargin: 64 * scaleFfactor
        anchors.left: parent.left
        anchors.leftMargin: 20 * scaleFfactor
        visible: row1.visible
        anchors.right: parent.right
        anchors.rightMargin: 20 * scaleFfactor
        height: 60 * scaleFfactor
        spacing: 20
        Button {
            id: backBt
            Layout.preferredWidth: scaleFfactor * 100
            Layout.preferredHeight: Layout.preferredWidth
            opacity: backBt.pressed ? 0.8 : 1.0
            Layout.alignment: Qt.AlignVCenter
            background: Rectangle {
                anchors.fill: parent
                //color: "#88101010"
                color: "transparent"
                radius: height / 2
                Image {
                    width: scaleFfactor * 48
                    height: width
                    anchors.centerIn: parent
                    source: "qrc:/icons/back.png"
                }
            }
            onClicked: {
                swipeView.currentIndex = 0
            }
        }
        Item { Layout.fillWidth: true;      Layout.alignment: Qt.AlignVCenter}
        Rectangle {
            Layout.alignment: Qt.AlignVCenter
            Layout.preferredWidth: scaleFfactor * 64
            Layout.preferredHeight: Layout.preferredWidth
            color: "#33101010"
            radius: height / 2
            Text {
                text: viewController.currentIndex
                anchors.centerIn: parent
                font.pixelSize: 30 * scaleFfactor
                color: "white"
            }
        }
        Button {
            id: autoPlayBt
            Layout.preferredWidth: scaleFfactor * 150
            Layout.preferredHeight: scaleFfactor * 64
            checkable: true
            checked: false
            opacity: backBt.pressed ? 0.8 : 1.0
            Layout.alignment: Qt.AlignVCenter
            background: Rectangle {
                width:  mText.contentWidth * 1.5 //scaleFfactor * 150
                height: scaleFfactor * 64
                anchors.centerIn: parent
                radius: height / 2
                //color: autoPlayBt.checked ? "#4ca2ff" : "#8101010"
                color: "#33101010"
                Text {
                    id: mText
                    text: autoPlayBt.checked ? qsTr("停止") : qsTr("幻灯片")
                    anchors.centerIn: parent
                    font.pixelSize: 30 * scaleFfactor
                    //color: autoPlayBt.checked ? "#4ca2ff" : "gray"
                    color:  "white"
                }
            }
            onCheckedChanged: {
                if (checked)
                    autoPlayTimer.restart()
                else
                    autoPlayTimer.stop()
            }
        }
    }
    Timer {
        id: autoPlayTimer
        repeat: true
        running: false
        interval: 3000
        onTriggered: viewController.currentIndex++
    }

    DeletePage {
        visible: false
        id: deletePage
        tiltle: "删除照片"
    }

    Connections {
        target: deletePage
        function onDeleteButtonClicked() {
            photoListModel.removeOne(viewController.currentIndex)
            if (viewController.count === 0) {
                displayView.visible = false
            }
        }
    }

    Connections {
        target: swipeView
        function onCurrentIndexChanged() {
            if (swipeView.currentIndex == 0)
                autoPlayTimer.stop()
            else {
                if (autoPlayBt.checked)
                    autoPlayTimer.restart()
            }
        }
    }
    onVisibleChanged: {
        if (visible) {
            if (swipeView.currentIndex == 0)
                autoPlayTimer.stop()
            else {
                if (autoPlayBt.checked)
                    autoPlayTimer.restart()
            }
        } else
            autoPlayTimer.stop()
    }
}
