/******************************************************************
Copyright © Deng Zhimao Co., Ltd. 2021-2030. All rights reserved.
* @brief         DisplayPanel.qml
* @author        Deng Zhimao
* @email         dengzhimao@alientek.com/1252699831@qq.com
* @date          2025-03-31
* @link          http://www.alientek.com
* @LICENSE       GPLV3
*******************************************************************/
import QtQuick 2.12
import QtQuick.Controls 2.12
import QtQuick.Layouts 1.12
import com.alientek.qmlcomponents 1.0
Item {
    id: displayPanel
    property bool fullScreenFlag: false
    Rectangle {
        id: rect
        color: "black"
        width: parent.width
        height: fullScreenFlag ? displayPanel.height : displayPanel.height / 2
        Behavior on height { PropertyAnimation {id: animation; duration: 120; easing.type: Easing.Linear } }
        Connections {
            target: mediaPlayer
            function  onStateChanged() {
                switch (mediaPlayer.state) {
                case MediaPlayer.PlayingState:
                    break;
                case MediaPlayer.PausedState:
                    break;
                case MediaPlayer.StoppedState:
                    break;
                default:
                    break;
                }
            }
            function onMediaStatusChanged() {
                switch (mediaPlayer.mediaStatus) {
                case MediaPlayer.EndOfMedia:
                    delayToPlayTimer.restart()
                    break;
                default:
                    break;
                }
            }
        }
        Timer {
            id: delayToPlayTimer
            interval: 500
            repeat: false
            running: false
            onTriggered: {
                if (loopCheckedFlag)
                    mediaPlayer.play()
            }
        }

        VideoOutput {
            id: videoOutput
            mediaState: mediaPlayer.state
            anchors.fill: parent
            source: mediaPlayer.image
            orientation: fullScreenFlag ? 90 : 0
            MouseArea {
                id: mouseAreaPlayerItem
                anchors.centerIn: parent
                rotation: fullScreenFlag ? 90 : 0
                width: fullScreenFlag ? displayPanel.height  : displayPanel.width
                height: fullScreenFlag ? displayPanel.width : displayPanel.height / 2
                property int pressY
                onClicked: {
                    if (volume_dialogDelayTohideTimer.running)
                        return
                    if (timerCountToHide.running)
                        timerCountToHide.stop()
                    else
                        timerCountToHide.restart()
                }
                onPositionChanged: {
                    media_volume_Hprogress.value += Math.round(pressY - mouseY)
                    volume_dialogDelayTohideTimer.stop()
                    volume_dialog.visible = true
                    pressY = mouseY
                }
                onPressed: pressY = mouseY
                onReleased:  {
                    if (volume_dialog.visible)
                        volume_dialogDelayTohideTimer.restart()
                }

                Button {
                    id: loop_button
                    width: scaleFfactor * 80
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.right: parent.right
                    anchors.rightMargin: 30 * scaleFfactor
                    height: width
                    checkable: true
                    checked: false
                    visible: filmNameText.visible
                    opacity: loop_button.checked || loop_button.pressed ? 1.0 : 0.5
                    background: Rectangle {
                        color: "gray"
                        anchors.fill: parent
                        radius: height / 2
                        Image {
                            id: loop_image
                            width: scaleFfactor * 64
                            height: width
                            opacity: 1
                            anchors.centerIn: parent
                            source: "qrc:/icons/videoplayer_loop_icon.png"
                        }
                    }
                    onCheckedChanged: {
                        loopCheckedFlag = loop_button.checked
                    }
                }
            }
            Timer {
                id: volume_dialogDelayTohideTimer
                interval: 500
                repeat: false
                onTriggered: volume_dialog.visible = false
            }

            Rectangle {
                id: volume_dialog
                color: "#88808080"
                visible: false
                width: row.width * 1.1
                height: scaleFfactor * 60
                radius: 10 * scaleFfactor
                anchors.centerIn: parent
                rotation: fullScreenFlag ? 90 : 0
                Text {
                    visible: media_volume_Hprogress.value === 1
                    anchors.horizontalCenter: parent.horizontalCenter
                    anchors.bottom: parent.top
                    text: "最小音量了"
                    font.bold: true
                    font.pixelSize: 25 * scaleFfactor
                    color: "white"
                }
                Row {
                    id: row
                    anchors.centerIn: parent
                    Image {
                        anchors.verticalCenter: parent.verticalCenter
                        source: media_volume_Hprogress.value === 0 ? "qrc:/icons/videoplayer_mute_icon.png" : "qrc:/icons/videoplayer_volume_icon.png"
                        width: 32 * scaleFfactor
                        height: width
                    }
                    Slider {
                        anchors.verticalCenter: parent.verticalCenter
                        id: media_volume_Hprogress
                        implicitWidth: 280
                        from: 0
                        stepSize: 1
                        to: 100
                        value: mediaPlayer.volume
                        orientation: Qt.Horizontal
                        onValueChanged: {
                            if (value !== 0)
                                mediaPlayer.volume = value
                            else
                                value = 1
                        }
                        background: Rectangle {
                            x: media_volume_Hprogress.leftPadding
                            y: media_volume_Hprogress.topPadding + media_volume_Hprogress.availableHeight / 2 - height / 2
                            implicitWidth: 200
                            implicitHeight: 8
                            width: media_volume_Hprogress.availableWidth
                            height: 8
                            radius: 0
                            color: "#38383a"

                            Rectangle {
                                width: media_volume_Hprogress.visualPosition * parent.width
                                height: parent.height
                                color: "#00FFFF"
                                radius: 0
                            }
                        }
                        handle: Item{}
                    }
                }
            }

        }


        Item {
            visible: true
            width: fullScreenFlag ? parent.height : parent.width
            height: fullScreenFlag ? parent.width : parent.height
            Behavior on rotation { PropertyAnimation { duration: 120; easing.type: Easing.Linear } }
            rotation: fullScreenFlag ? 90 : 0
            anchors.centerIn: parent
            Rectangle {
                anchors.top: parent.top
                width: parent.width
                id: bottomPanel
                onVisibleChanged: {
                    // if (!visible)
                    // volume_dialog.close()
                }
                visible: timerCountToHide.running || mediaPlayer.state === MediaPlayer.StoppedState
                height: 120 * scaleFfactor
                gradient: Gradient {
                    GradientStop { position: 1.0; color: "transparent" }
                    GradientStop { position: 0.5; color: "#101010" }
                    GradientStop { position: 0.0; color: "black" }
                }
                Text{
                    id: filmNameText
                    width: parent.width / 2
                    anchors.centerIn: parent
                    text: mediaModel.currentIndex !== -1 ? mediaModel.getcurrentTitle() : ""
                    color: "white"
                    horizontalAlignment: Text.AlignHCenter
                    font.pixelSize: scaleFfactor * 24
                    font.bold: false
                    elide: Text.ElideRight
                }

                Button {
                    id: backBt
                    width: 120 * scaleFfactor
                    height: width
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.left: parent.left
                    anchors.leftMargin: 5
                    background: Image {
                        width: scaleFfactor * 64
                        height: width
                        anchors.centerIn: backBt
                        opacity: backBt.pressed ? 0.5 : 1.0
                        source: "qrc:/icons/videoplayer_back_icon.png"
                    }
                    onClicked: {
                        if (!fullScreenFlag) {
                            mediaPlayer.stop()
                            swipeView.currentIndex = 0
                        } else
                            fullScreenFlag = false
                    }
                }
            }

            Rectangle {
                anchors.bottom: parent.bottom
                width: parent.width
                visible: timerCountToHide.running || mediaPlayer.state === MediaPlayer.StoppedState
                height: 120 * scaleFfactor
                gradient: Gradient {
                    GradientStop { position: 0.0; color: "transparent" }
                    GradientStop { position: 0.5; color: "#101010" }
                    GradientStop { position: 1.0; color: "black" }
                }

                RowLayout {
                    id: rowLayout
                    anchors.fill: parent
                    Item {
                        width: 5
                        height: 5
                    }
                    Button {
                        id: play_button
                        Layout.preferredWidth: scaleFfactor * 120
                        Layout.preferredHeight: width
                        Layout.alignment: Qt.AlignVCenter
                        hoverEnabled: true
                        checkable: true
                        checked: false
                        opacity: play_button.pressed ? 0.5 : 1.0
                        background: Image {
                            id: play_image
                            width: scaleFfactor * 64
                            height: width
                            anchors.centerIn: play_button
                            //opacity: play_button.hovered && !play_button.pressed ? 0.5 : 1.0
                            source: mediaPlayer.state === MediaPlayer.PlayingState ?  "qrc:/icons/videoplayer_pause_icon.png" : "qrc:/icons/videoplayer_play_icon.png"
                        }
                        onClicked: {
                            if(mediaPlayer.state === MediaPlayer.PlayingState)
                                mediaPlayer.pause()
                            else {
                                mediaPlayer.play()
                            }
                        }
                    }

                    Button {
                        id: next_button
                        Layout.preferredWidth: scaleFfactor * 120
                        Layout.preferredHeight: width
                        hoverEnabled: true
                        visible: true
                        Layout.alignment: Qt.AlignVCenter
                        opacity: next_button.pressed ? 0.5 : 1.0
                        background: Image {
                            id: screen_image
                            width: scaleFfactor * 64
                            height: width
                            anchors.centerIn: next_button
                            source:  "qrc:/icons/videoplayer_next_icon.png"
                        }
                        onClicked: {
                            mediaModel.currentIndex++
                            mediaPlayer.play()
                            timerCountToHide.restart()
                        }
                    }


                    Text{
                        id: playTimePosition
                        Layout.alignment: Qt.AlignVCenter
                        text: currentMediaTime(mediaPlayer.position)
                        color: "white"
                        font.pixelSize: scaleFfactor * 20
                        font.bold: true
                    }

                    PlaySlider {
                        id: media_play_Hprogress
                        Layout.alignment: Qt.AlignVCenter
                        Layout.fillWidth: true
                        Layout.fillHeight: true
                    }

                    Text{
                        id: playTimeDuration
                        Layout.alignment: Qt.AlignVCenter
                        text: currentMediaTime(mediaPlayer.duration)
                        color: "white"
                        font.pixelSize: scaleFfactor * 20
                        font.bold: true
                    }
                    Button {
                        id: fullscreenBt
                        checkable: true
                        checked: false
                        Layout.preferredWidth: scaleFfactor * 120
                        Layout.preferredHeight: width / 2
                        background: Image {
                            width: scaleFfactor * 64
                            height: width
                            opacity: fullscreenBt.pressed ? 0.5 : 1
                            anchors.centerIn: fullscreenBt
                            source:  fullscreenBt.checked ? "qrc:/icons/videoplayer_fullscreen_icon.png": "qrc:/icons/videoplayer_smallscreen_icon.png"
                        }
                        onCheckedChanged: {
                            fullScreenFlag = !fullScreenFlag
                        }
                    }
                    Item {
                        width: 5
                        height: 5
                    }
                }
            }
        }
    }
}
