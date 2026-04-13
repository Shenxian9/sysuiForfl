/******************************************************************
Copyright © Deng Zhimao Co., Ltd. 2021-2030. All rights reserved.
* @projectName   fileview
* @brief         FileViewLayout.qml
* @author        Deng Zhimao
* @email         dengzhimao@alientek.com/1252699831@qq.com
* @link          www.openedv.com
* @date          2024-11-25
*******************************************************************/
import QtQuick 2.9
import Qt.labs.folderlistmodel 2.1
import QtQuick.Controls 2.5
import com.alientek.qmlcomponents 1.0
Rectangle {
    id : fileView
    anchors.fill: parent
    property string folderPathName: "file:/"
    property string currtentPathName
    property int folderNavigationItemCount: 0
    property real scaleFacter: parent.width / 720

    FolderPathList {
        id: folderPathList
        mediaPath: "/mnt"
        onCurrentIndexChanged: {
            if (currentIndex < 0)
                return
            folderNavigation.model.clear()
            fileView.folderPathName = "file:" + folderPathList.currentMediaPath
            fileView.currtentPathName = folderPathList.currentMediaPath
            var components = folderPathList.splitPath(folderPathList.currentMediaPath)
            for (var i = 0; i < components.length; ++i) {
                folderNavigation.model.insert(folderNavigation.model.count, {"currtentPathName": components[i],
                                                  "folderPathName": "file:" + components[i]})
            }
            fileView.folderNavigationItemCount = folderNavigation.count
            folderNavigation.currentIndex = folderNavigation.count - 1
        }
    }

    Component.onCompleted: {
        folderNavigation.model.insert(folderNavigation.model.count, {"currtentPathName": "/",
                                          "folderPathName": "file:/"})
        fileView.folderNavigationItemCount = folderNavigation.count
        folderNavigation.currentIndex = folderNavigation.count - 1
    }
    Item {
        id: bottomPanel
        height: 256 * scaleFacter
        width: parent.width
        anchors.bottom: parent.bottom
        /*Row {
            anchors.centerIn: parent
            Button {
                width: 128
                height: 128
                background: Item {
                    anchors.fill: parent
                    Column {
                        anchors.centerIn: parent
                        Image {
                            anchors.horizontalCenter: parent.horizontalCenter
                            width: 80
                            height: 80
                            source: "qrc:/icons/folder_checked.png"
                        }
                        Text {
                            anchors.horizontalCenter: parent.horizontalCenter
                            text: "根目录"
                            font.pixelSize: 30 * scaleFacter
                        }
                    }
                }
            }
        }*/
        ListView {
            id: folderPathListView
            model: folderPathList
            width: contentWidth
            interactive: false
            height: 128 * scaleFacter
            anchors.centerIn: bottomPanel
            spacing: 128 * scaleFacter
            orientation: ListView.Horizontal
            currentIndex: folderPathList.currentIndex
            delegate: Rectangle {
                width: 128
                height: width
                //color: ListView.isCurrentItem ? "white" : "transparent"
                color: "transparent"
                radius: 10
                MouseArea {
                    anchors.fill: parent
                    onClicked: folderPathList.currentIndex = index
                }
                Column {
                    anchors.centerIn: parent
                    Image {
                        width: 64
                        height: 64
                        id: mediaTypeIcon
                        source:  if (mediaInfo.mediaType === FolderPathList.MMC)
                                     return folderPathList.currentIndex === index ? "qrc:/icons/latest_checked.png" : "qrc:/icons/latest_uncheck.png"
                                 else if (mediaInfo.mediaType === FolderPathList.USB)
                                     return folderPathList.currentIndex === index ? "qrc:/icons/folder_checked.png" : "qrc:/icons/folder_unchecked.png"
                                 else
                                     return folderPathList.currentIndex === index ? "qrc:/icons/folder_checked.png" : "qrc:/icons/folder_unchecked.png"
                        anchors.horizontalCenter: parent.horizontalCenter
                    }
                    Text {
                        visible: true
                        //text: mediaInfo.path
                        text: if (mediaInfo.mediaType === FolderPathList.MMC)
                                  return "最近项目"
                              else if (mediaInfo.mediaType === FolderPathList.USB)
                                  return "Ｕ盘"
                              else if (mediaInfo.mediaType === FolderPathList.SD)
                                  return "SD"
                              else
                                  return "浏览"
                        font.pixelSize: 30 * scaleFacter
                        elide: Text.ElideLeft
                        color: folderPathList.currentIndex === index ? "#4169e1" : "gray"
                        anchors.horizontalCenter: parent.horizontalCenter
                    }
                }
            }
        }
    }
    Item {
        height: 128 * scaleFacter
        width: parent.width
        anchors.top: parent.top
        anchors.topMargin: 64 * scaleFacter
        id: folderNavigationItem

        ListView {
            id: folderNavigation
            anchors.verticalCenter: parent.verticalCenter
            width: fileView.width - 40 * scaleFacter
            anchors.horizontalCenter: parent.horizontalCenter
            height: 80 * scaleFacter
            clip: true
            spacing: 3
            orientation : ListView.Horizontal
            delegate: Rectangle{
                radius: 10
                width: pathText.contentWidth * 1.2 < height ? height : pathText.contentWidth * 1.2
                height: 80 * scaleFacter
                color: "#e8e2e6"
                Text{
                    id: pathText
                    color: parent.ListView.isCurrentItem ? "black": "gray"
                    text: currtentPathName
                    font.pixelSize: 25
                    anchors.centerIn: parent
                    font.bold: parent.ListView.isCurrentItem ? true : false
                }
                Text {
                    id: textMyPath
                    visible: false
                    text: folderPathName
                }
                MouseArea{
                    anchors.fill: parent
                    onClicked: {
                        fileView.folderPathName = folderNavigation.model.get(index).folderPathName
                        if (index < folderNavigation.count - 1)
                            for(var i = index;  i < fileView.folderNavigationItemCount -1 ; i++ ){
                                listmodel.remove(index+1)
                            }
                        fileView.folderNavigationItemCount = folderNavigation.count
                    }
                }
            }
            model:ListModel{
                id: listmodel
            }
        }
    }


    function insertItem(){
        folderNavigation.model.insert(folderNavigation.model.count, {"currtentPathName" : fileView.currtentPathName, "folderPathName": fileView.folderPathName})
        fileView.folderNavigationItemCount = folderNavigation.count
        folderNavigation.currentIndex = folderNavigation.count -1
    }

    GridView {
        id: listFileView
        cellWidth: listFileView.width / 3
        cellHeight: listFileView.width / 3
        snapMode: GridView.SnapOneRow
        anchors {
            bottom: parent.bottom
            bottomMargin: 256 * scaleFacter
            right: parent.right
            leftMargin: 20 * scaleFacter
            rightMargin: 20 * scaleFacter
            left: parent.left
            top: folderNavigationItem.bottom
        }
        onFlickStarted: scrollBar.opacity = 1.0
        onFlickEnded: scrollBar.opacity = 0.0

        ScrollBar.vertical: ScrollBar {
            id: scrollBar
            width: 10
            opacity: 0.0
            onActiveChanged: {
                active = true;
            }
            Component.onCompleted: {
                scrollBar.active = true;
            }
            contentItem: Rectangle{
                implicitWidth: 6
                implicitHeight: 100
                radius: 2
                color: scrollBar.hovered ? "#101010" : "#80101010"
            }
            Behavior on opacity { PropertyAnimation { duration: 500; easing.type: Easing.Linear } }
        }

        clip: true
        delegate: Item{
            width: listFileView.cellWidth
            height: width
            Image {
                id: folderIcon
                anchors.centerIn: parent
                width: 150 * scaleFacter
                height: width
                source: folderModel.get(index, "fileIsDir") ? "qrc:/icons/folder.png"  : "qrc:/icons/file.png"
            }

            Text {
                id: textfileName
                text: fileName
                width: 200 * scaleFacter
                color: "black"
                font.pixelSize: 30 * scaleFacter
                font.bold: true
                anchors.top: folderIcon.bottom
                anchors.horizontalCenter: folderIcon.horizontalCenter
                anchors.topMargin: 5
                elide: Text.ElideRight
                horizontalAlignment: Text.AlignHCenter
            }

            Text {
                visible: false
                id: textModify
                text: fileModified
                anchors.top: textfileName.bottom
                anchors.horizontalCenter: textfileName.horizontalCenter
                color: "black"
                font.bold: true
                font.pixelSize: 13 * scaleFacter
            }

            MouseArea{
                anchors.fill: parent
                onClicked: {
                    if(folderModel.isFolder(index)){
                        fileView.folderPathName = folderModel.get(index, "fileURL")
                        fileView.currtentPathName = folderModel.get(index, "fileName")
                        insertItem()
                    } else {
                        warningDialog.open()
                        globalFileName.text = folderModel.get(index, "fileName")
                        globalFilePath.text = "文件路径:" + folderModel.get(index, "filePath")
                        globalFileSize.text = "文件大小:" + folderModel.get(index, "fileSize") + "b"
                        globalFilefileModified.text = "修改日期:" + folderModel.get(index, "fileModified")
                        /*var size = folderModel.get(index, "fileSize")
                        if (size < 10000) {
                            switch (folderModel.get(index, "fileSuffix")) {
                            case "txt":
                            case "sh":
                            case "conf":
                            case "cpp":
                            case "c":
                            case "h":
                            case "sh":
                            case "local":
                            case "lrc":
                            case "blacklist":
                            case "py":
                                break
                            default:
                                warningDialog.open()
                                return;
                            }
                            dialog.open()
                            //myFile.source = folderModel.get(index, "filePath")
                            //myText.text = myFile.read()
                        } else {
                            //warningDialog.open()
                        }*/
                    }
                }
            }
        }
        model: FolderListModel{
            id: folderModel
            objectName: "folderModel"
            showDirs: true
            showFiles: true
            showDirsFirst: true
            showDotAndDotDot: false
            nameFilters: ["*"]
            folder: fileView.folderPathName
            onFolderChanged: {

            }
        }
    }

    Dialog {
        id: warningDialog
        modal: true
        width: parent.width / 1.2
        height: parent.height / 3
        anchors.centerIn: parent
        //standardButtons: Dialog.Close
        background: Rectangle {
            anchors.fill: parent
            color: "#f8f8ff"
            radius: 20
            CustomRectangle {
                width: parent.width
                height: 80
                color: "#e4e1e4"
                radius: 20
                radiusCorners: Qt.AlignLeft | Qt.AlignRight | Qt.AlignTop
                Text {
                    width: parent.width / 2
                    id: globalFileName
                    anchors.centerIn: parent
                    color: "black"
                    font.bold: true
                    font.pixelSize: 25 * scaleFacter
                    elide: Text.ElideRight
                    horizontalAlignment: Text.AlignHCenter
                }
            }

            Flickable {
                width: parent.width
                height: parent.height - 150
                anchors.centerIn: parent
                contentHeight: column.height
                clip: true
                Column {
                    id : column
                    width: parent.width
                    Text {
                        color: "black"
                        font.pixelSize: 25 * scaleFacter
                        width: parent.width - 10
                        text: qsTr("文件名称:" + globalFileName.text)
                        horizontalAlignment: Text.AlignLeft
                        wrapMode: Text.WrapAnywhere
                    }
                    Text {
                        width: parent.width - 10
                        id: globalFilePath
                        color: "black"
                        font.pixelSize: 25 * scaleFacter
                        horizontalAlignment: Text.AlignLeft
                        wrapMode: Text.WrapAnywhere
                    }
                    Text {
                        width: parent.width - 10
                        id: globalFileSize
                        color: "black"
                        font.pixelSize: 25 * scaleFacter
                        horizontalAlignment: Text.AlignLeft
                    }
                    Text {
                        width: parent.width - 10
                        id: globalFilefileModified
                        color: "black"
                        font.pixelSize: 25 * scaleFacter
                        horizontalAlignment: Text.AlignLeft
                    }
                }
            }
            Button {
                id: okBt
                anchors.bottom: parent.bottom
                height: 80 * scaleFacter
                width: parent.width
                background: CustomRectangle {
                    color: okBt.pressed ? "#e4e1e4" :  "#1e90ff"
                    anchors.fill: parent
                    radius: 20 * scaleFacter
                    radiusCorners:  Qt.AlignLeft | Qt.AlignRight | Qt.AlignBottom
                }
                Text {
                    anchors.centerIn: parent
                    text: qsTr("确定")
                    font.bold: true
                    color: okBt.pressed ? "#1e90ff" : "white"
                    font.pixelSize: 35 * scaleFacter
                }
                onClicked: {
                    warningDialog.close()
                }
            }
        }
    }
}

