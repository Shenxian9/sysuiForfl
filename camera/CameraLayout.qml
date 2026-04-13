/******************************************************************
Copyright © Deng Zhimao Co., Ltd. 2021-2030. All rights reserved.
* @projectName   camera
* @brief         CameraLayout.qml
* @author        Deng Zhimao
* @email         dengzhimao@alientek.com/1252699831@qq.com
* @link          www.openedv.com
* @date          2024-11-24
*******************************************************************/
import QtQuick 2.12
import QtQuick.Layouts 1.12
import QtQuick.Controls 2.12
import com.alientek.qmlcomponents 1.0
Rectangle {
    anchors.fill: parent
    color: "black"
    property QtObject camera
    property string  cmd: "gst-pipeline: v4l2src device=/dev/video0 ! video/x-raw,format=YUY2,width=640,height=480,framerate=30/1  ! videoconvert ! qtvideosink"

    PhotoListModel {
        id: photoListModel
        photoDirPath: appCurrtentDir + "/resource/images/"
    }

    onVisibleChanged: {
        if(!visible) {
            loader.sourceComponent = undefined
        } else if (!viewController.visible) {
            loader.sourceComponent = component
        }
    }

    Loader {
        id: loader
        anchors.fill: parent
        asynchronous: true
        Component.onCompleted: loader.sourceComponent = component
    }

    Component {
        id: component
        Camera {
            id: m_camera
            path: appCurrtentDir + "/resource/images/"  // Where the album is stored
            source: cmd
            onNoCameraAvailable: { // When there's no camera to do
            }
            onImageCapture: {
                console.log("IMG has been saved in " + fileName)
                //photoListModel.addPhoto(fileName)
                photoListModel.updateModel(appCurrtentDir + "/resource/images/");
            }
            Component.onCompleted: camera = m_camera
        }
    }

    Text {
        anchors.centerIn: parent
        text: qsTr("仅支持YUV格式USB摄像头\n注意请勿拍过多照片，内存用完会卡顿")
        color: "#44ffffff"
        font.pixelSize: 30 * scaleFfactor
        horizontalAlignment: Qt.AlignHCenter
    }

    VideoOutput {
        source: camera.image
        width: parent.width
        height: parent.width / 3 * 4
        anchors.top: parent.top
        anchors.topMargin: 96 * scaleFfactor
    }


    Item {
        id: bottonWidget
        anchors.bottom: parent.bottom
        width: parent.width
        height: 224 * scaleFfactor

        Row {
            anchors.centerIn: parent
            spacing: 128 * scaleFfactor
            Image {
                id: capturePhoto
                source: photoListModel.currentIndex !== -1  ? photoListModel.getcurrentPath() : ""
                width: scaleFfactor * 128
                height: width
                fillMode: Image.PreserveAspectCrop
                visible: true
                MouseArea {
                    anchors.fill: parent
                    onClicked: {
                        viewController.visible = true
                        loader.sourceComponent = undefined
                    }
                }
            }

            RoundButton {
                id: roundButton1
                width: scaleFfactor * 128
                height: width
                background: Rectangle {
                    anchors.fill: parent
                    radius:  height / 2
                    border.color: "white"
                    border.width: scaleFfactor * 6
                    color: "transparent"
                    Rectangle {
                        width: roundButton1.pressed ? scaleFfactor * 100 : scaleFfactor * 110
                        height: roundButton1.pressed ? scaleFfactor * 100 : scaleFfactor * 110
                        Behavior on width { PropertyAnimation { duration: 100; easing.type: Easing.Linear } }
                        Behavior on height { PropertyAnimation { duration: 100; easing.type: Easing.Linear } }
                        color: "white"
                        radius: height / 2
                        anchors.centerIn: parent
                    }
                }

                onClicked: {
                    camera.capture()
                }
            }
            Item {
                width: 128 * scaleFfactor
                height: width
            }
        }
    }

    Connections {
        target: photoListModel
        function onCurrentIndexChanged() {
            viewController.currentIndex = photoListModel.currentIndex
            thumbnailListView.currentIndex = photoListModel.currentIndex
        }
    }
    Connections {
        target: viewController
        function onVisibleChanged() {
            if (viewController.visible && autoPlayBt.checked)
                autoPlayTimer.restart()
            else
                autoPlayTimer.stop()
        }
    }

    property int varDuration: 0
    PathView  {
        visible: false
        id: viewController
        anchors.fill: parent
        pathItemCount: 3
        model: photoListModel
        snapMode: PathView.SnapOneItem
        Component.onCompleted: positionViewAtIndex(viewController.count, PathView.End)
        delegate: Image {
            id: imageShow
            width: parent.width
            height: parent.height
            source: path
            scale: bt.checked && imageShow.PathView.isCurrentItem ? 1.0 : PathView.viewScale
            z: PathView.viewZ
            opacity: PathView.viewOpacity
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
                        bottomWidgets.visible = false
                    } else {
                        if (imageShow.PathView.isCurrentItem)
                            bottomWidgets.visible = true
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
            photoListModel.currentIndex = viewController.currentIndex
        }

        preferredHighlightBegin: 0.5
        preferredHighlightEnd: 0.5

        path:  Path {
            id: viewControllerPath
            startX: - viewController.width // /2
            startY: viewController.height / 2

            PathAttribute { name: "viewScale"; value: 1.0} // 0.5
            PathAttribute { name: "viewZ"; value: 0}
            PathAttribute { name: "viewOpacity"; value:1.0}

            PathLine { x: viewController.width / 2 ; y: viewController.height / 2}
            PathAttribute { name: "viewScale"; value: 1.0}
            PathAttribute { name: "viewZ"; value: 5}
            PathAttribute { name: "viewOpacity"; value: 1.0}

            PathLine { x: viewController.width + viewController.width; y:viewController.height / 2} //x: + xx/2
            PathAttribute { name: "viewScale"; value: 1.0 }
            PathAttribute { name: "viewZ"; value: 0}
            PathAttribute { name: "viewOpacity"; value: 1.0}
            PathPercent { value: 1.0}
        }
    }

    Rectangle {
        id: bottomWidgets
        visible: viewController.visible
        color: "white"
        anchors.bottom: parent.bottom
        height: scaleFfactor *  224
        width: parent.width
        MouseArea {
            anchors.fill: parent
        }

        ListView {
            id: thumbnailListView
            height: parent.height / 3
            width: parent.width
            anchors.top: parent.top
            anchors.topMargin: 2
            orientation: ListView.Horizontal
            clip: true
            model: photoListModel
            snapMode: ListView.SnapOneItem
            delegate:  Rectangle {
                width: photoListModel.currentIndex === index ?  height : height / 2 + 5
                height: thumbnailListView.height
                Image {
                    width: photoListModel.currentIndex === index ?  height : height / 2
                    height: thumbnailListView.height
                    fillMode: Image.PreserveAspectCrop
                    source: path
                    anchors.centerIn: parent
                    opacity: mouseArea2.pressed ? 0.8 : 1.0
                    Behavior on width { PropertyAnimation { duration: 100; easing.type: Easing.OutQuart } }
                }
                MouseArea {
                    id: mouseArea2
                    anchors.fill: parent
                    onClicked: {
                        photoListModel.currentIndex = index
                    }
                }
            }
        }

        Button {
            anchors.right: parent.right
            anchors.rightMargin: 24 * scaleFfactor
            anchors.top: parent.top
            anchors.topMargin: 12 * scaleFfactor
            id: deleteBt
            width: 80 * scaleFfactor
            height: width
            anchors.verticalCenter: parent.verticalCenter
            opacity: deleteBt.pressed ? 0.8 : 1.0
            background: Image {
                width: 48 * scaleFfactor
                height: width
                source: "qrc:/icons/delete.png"
                anchors.centerIn: parent
            }
            onClicked: {
                deletePage.visible = true
                autoPlayBt.checked = false
            }
        }
    }

    Rectangle {
        width: parent.width
        height: 176 * scaleFfactor
        visible: topWidgets.visible
    }
    RowLayout {
        id: topWidgets
        anchors.top: parent.top
        anchors.topMargin: 64
        anchors.left: parent.left
        anchors.leftMargin: 20
        visible: bottomWidgets.visible
        anchors.right: parent.right
        anchors.rightMargin: 20
        height: 80 * scaleFfactor
        spacing: 32 * scaleFfactor
        Button {
            id: backBt
            Layout.preferredWidth: scaleFfactor * 80
            Layout.preferredHeight: Layout.preferredWidth
            opacity: backBt.pressed ? 0.8 : 1.0
            background: Item {
                anchors.fill: parent
                //color: "#33101010"
                //radius: height / 2
                Image {
                    width: scaleFfactor * 48
                    height: width
                    anchors.centerIn: parent
                    source: "qrc:/icons/back.png"
                }
            }
            onClicked: {
                viewController.visible = false
                bottomWidgets.visible = false
                autoPlayTimer.stop()
                loader.sourceComponent = component
            }
        }
        Item { Layout.fillWidth: true}
        Rectangle {
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
            Layout.preferredWidth: scaleFfactor * 100
            Layout.preferredHeight: scaleFfactor * 40
            checkable: true
            checked: false
            opacity: backBt.pressed ? 0.8 : 1.0
            background: Rectangle {
                height: scaleFfactor * 64
                anchors.centerIn: parent
                width:  mText.contentWidth * 1.5 //scaleFfactor * 150
                radius: height / 2
                color: "#33101010"
                Text {
                    text: autoPlayBt.checked ? qsTr("停止") : qsTr("幻灯片")
                    id: mText
                    anchors.centerIn: parent
                    font.pixelSize: 30 * scaleFfactor
                    //color: autoPlayBt.checked ? "#4169e1" : "gray"
                    color: "white"
                }
            }
            onCheckedChanged: {
                if (checked)
                    autoPlayTimer.restart()
                else
                    autoPlayTimer.stop()
            }
        }
        Item {
            Layout.preferredHeight: scaleFfactor * 40
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
        onDeleteButtonClicked:{
            photoListModel.removeOne(viewController.currentIndex)
            if (viewController.count === 0) {
                viewController.visible = false
                bottomWidgets.visible = false
                autoPlayTimer.stop()
            }
        }
    }
}
