/******************************************************************
Copyright © Deng Zhimao Co., Ltd. 2021-2030. All rights reserved.
* @projectName   desktop
* @brief         PlayList.qml
* @author        Deng Zhimao
* @email         dengzhimao@alientek.com
* @link          www.openedv.com
* @date          2021-09-13
*******************************************************************/
import QtQuick.Controls 2.12
import QtQuick 2.0
import QtMultimedia 5.0
import com.alientek.qmlcomponents 1.0

Item {
    id: root
    property int music_currentIndex: -1
    property int musicCount: 0
    property string musicName

    onMusic_currentIndexChanged: {
        music_listView.currentIndex = music_currentIndex
    }

    Item {
        anchors.top: parent.top
        anchors.topMargin: 25 * scaleFactor
        width: parent.width
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.bottom: parent.bottom

        Item {
            width: 80 * scaleFacter
            height: 50 * scaleFacter
            anchors.left: parent.left
            anchors.leftMargin: 20  * scaleFacter
            anchors.top: parent.top
            Text {
                text: qsTr("播放列表")
                anchors.verticalCenter: parent.verticalCenter
                font.pixelSize: 30 * scaleFactor
                color: "white"
            }
        }
        ListView {
            id: music_listView
            visible: true
            width: parent.width
            anchors.topMargin: 50 * scaleFacter
            anchors.top: parent.top
            anchors.bottom: parent.bottom
            currentIndex: 0
            clip: true
            spacing: 10
            onFlickStarted: scrollBar.opacity = 1.0
            onFlickEnded: scrollBar.opacity = 0.0

            onCountChanged: {
                musicCount = music_listView.count
            }
            /*header: Item {
                width: 80 * scaleFacter
                height: 50 * scaleFacter
                Text {
                    text: qsTr("播放列表")
                    anchors.verticalCenter: parent.verticalCenter
                    font.pixelSize: 30 * scaleFactor
                    color: "white"
                }
            }*/

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
                    color: scrollBar.hovered ? "#88101010" : "#30101010"
                }
                Behavior on opacity { PropertyAnimation { duration: 500; easing.type: Easing.Linear } }
            }

            model: music_playlistModel
            delegate: Item {
                id: itembg
                width: parent.width - 10
                //height: music_listView.currentIndex === index && musicPlayer.playbackState === MediaPlayer.PlayingState ? 80 : 60
                height: 80 * scaleFactor
                Rectangle {
                    height: parent.height
                    anchors.right: parent.right
                    anchors.left: ablum_item.left
                    radius: 5
                    color: music_listView.currentIndex === index && musicPlayer.playbackState
                           === MediaPlayer.PlayingState ? "#55808a87" : "transparent"
                }
                Text {
                    visible: false
                    id: listIndex
                    text: index < 9 ? "0" + (index + 1) : index + 1
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.left: parent.left
                    anchors.leftMargin: 25 * scaleFacter
                    font.pixelSize: 25 * scaleFacter
                    color: "white"
                }

                Item {
                    id: ablum_item
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.left: parent.left
                    anchors.leftMargin: 40 * scaleFacter
                    width: itembg.height
                    height: itembg.height
                    AlbumImage {
                        anchors.verticalCenter: parent.verticalCenter
                        anchors.leftMargin: 25 * scaleFacter
                        width: itembg.height
                        height: itembg.height
                        id: album
                        visible: true
                        radius: 5
                        source: "file://" + appCurrtentDir + "/resource/artist/" + music_playlistModel.getSongName(index)
                    }
                }
                Rectangle {
                    height: 1
                    anchors.left: column.left
                    anchors.right: parent.right
                    anchors.bottom: parent.bottom
                    color: "#33ffffff"
                }
                Column {
                    id: column
                    anchors.left: ablum_item.right
                    anchors.leftMargin: 20 * scaleFacter
                    anchors.verticalCenter: parent.verticalCenter
                    Text {
                        id: songsname
                        // width: itembg.width - 220
                        // anchors.verticalCenter: parent.verticalCenter
                        // anchors.left: ablum_item.right
                        // verticalAlignment: Text.AlignVCenter
                        text: title
                        elide: Text.ElideRight
                        anchors.leftMargin: 10 * scaleFacter
                        color: parent.ListView.isCurrentItem && musicPlayer.playbackState === MediaPlayer.PlayingState ? "white" : "#D0D0D0"
                        font.pixelSize: 30 * scaleFacter
                        font.bold: parent.ListView.isCurrentItem && musicPlayer.playbackState === MediaPlayer.PlayingState
                    }

                    Text {
                        id: songsauthor
                        visible: true
                        width: 200 * scaleFacter
                        height: 15 * scaleFacter
                        // anchors.bottom: parent.bottom
                        // anchors.left: ablum_item.right
                        // verticalAlignment: Text.AlignVCenter
                        text: author
                        //anchors.leftMargin: 10
                        elide: Text.ElideRight
                        color: parent.ListView.isCurrentItem && musicPlayer.playbackState === MediaPlayer.PlayingState ? "white" : "#D0D0D0"
                        font.pixelSize: 20 * scaleFacter
                        font.bold: parent.ListView.isCurrentItem
                    }
                }

                MouseArea {
                    id: mouserArea
                    anchors.fill: parent
                    acceptedButtons: Qt.LeftButton | Qt.RightButton
                    onClicked: {
                        music_playlistModel.currentIndex = index
                        music_listView.currentIndex = index
                        musicLayout.playBtnSignal()
                        musicPlayer.play()
                    }
                }

                Button {
                    id: itembtn
                    visible: false
                    anchors.right: parent.right
                    anchors.verticalCenter: itembg.verticalCenter
                    width: itembg.height
                    height: itembg.height
                    onClicked: {
                        music_playlistModel.currentIndex = index
                        music_listView.currentIndex = index
                        if (musicPlayer.playbackState !== MediaPlayer.PlayingState)
                            musicPlayer.play()
                    }
                    background: Rectangle {
                        width: Control.width
                        height: Control.height
                        radius: 3
                        color: Qt.rgba(0,0,0,0)
                        Image {
                            id: itemImage
                            width: 40
                            height: 40
                            anchors.centerIn: parent
                            source:  music_listView.currentIndex !== index || musicPlayer.playbackState !== MediaPlayer.PlayingState
                                     ? "qrc:/icons/btn_play.png" : "qrc:/icons/btn_pause.png"
                            opacity: 0.8
                        }
                    }
                }
            }
        }
    }
}
