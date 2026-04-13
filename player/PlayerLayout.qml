/******************************************************************
Copyright © Deng Zhimao Co., Ltd. 2021-2030. All rights reserved.
* @projectName   player
* @brief         PlayerLayout.qml
* @author        Deng Zhimao
* @email         dengzhimao@alientek.com/1252699831@qq.com
* @link          www.openedv.com
* @date          2023-03-08
* @link          http://www.openedv.com/forum.php
*******************************************************************/
import QtQuick 2.12
import QtQuick.Window 2.12
import QtQuick.Controls 2.5
import com.alientek.qmlcomponents 1.0
import QtQuick.Layouts 1.12

Rectangle {
    signal mediaDuratrionChaged()
    signal mediaPositonChaged()
    signal sliderPressChaged(bool pressed)
    property bool progress_pressed: false
    property bool tiltleHeightShow: true
    property bool tiltleWidthShow: true
    id: playerLayout
    property real scaleFfactor: window.width / 720
    anchors.fill: parent
    color: "#F0F0F0"
    property bool loopCheckedFlag: false

    AMediaList {
        id: mediaModel
        currentIndex: -1
        onCurrentIndexChanged: {
        }
        onCurrentMediaChanged: {
        }
    }


    Component.onCompleted: {
        mediaModel.add(appCurrtentDir +  "/resource/media/movies")
    }

    property int statePreVious: -1
    onVisibleChanged: {
        if (visible)
            timerCountToHide.start()
        if (visible) {
            if (statePreVious === MediaPlayer.PlayingState) {
                mediaPlayer.play()
            }
        } else {
            statePreVious = mediaPlayer.state
            if (mediaPlayer.state === MediaPlayer.PlayingState) {
                mediaPlayer.pause()
            }
        }
    }

    Timer {
        id: playStarttimer
        function setTimeout(cb, delayTime) {
            playStarttimer.interval = delayTime;
            playStarttimer.repeat = false
            playStarttimer.triggered.connect(cb);
            playStarttimer.triggered.connect(function release () {
                playStarttimer.triggered.disconnect(cb)
                playStarttimer.triggered.disconnect(release)
            })
            playStarttimer.start()
        }
    }

    Timer {
        id: timerCountToHide
        interval: 8000
        repeat: false
        onTriggered: {
        }
    }

    Timer {
        id: loopdelayToplayTimer
        interval: 1000
        onTriggered: {
            if (mediaPlayer.state === MediaPlayer.StoppedState &&  visible) {
                mediaPlayer.play()
            }
        }
    }

    MediaPlayer {
        id: mediaPlayer
        volume: 20
        source: mediaModel.currentMedia
        onPositionChanged: {
            if (!progress_pressed)
                playerLayout.mediaPositonChaged()
        }

        onDurationChanged: {
            playerLayout.mediaDuratrionChaged()
        }

        onStateChanged: function() {
            switch (mediaPlayer.state) {
            case MediaPlayer.PlayingState:
                timerCountToHide.interval = 15000
                timerCountToHide.start()
                break;
            case MediaPlayer.PausedState:
                timerCountToHide.interval = 50000000
                timerCountToHide.restart()
                break;
            case MediaPlayer.StoppedState:
                timerCountToHide.interval = 50000000
                timerCountToHide.restart()
                break;
            default:
                break;
            }
        }
    }

    SwipeView {
        id: swipeView
        clip: true
        anchors.fill: parent
        interactive: false
        MediaListView {}
        DisplayPanel{}
    }

    function currentMediaTime(time){
        var sec = Math.floor(time / 1000);
        var hours = Math.floor(sec / 3600);
        var minutes = Math.floor((sec - hours * 3600) / 60);
        var seconds = sec - hours * 3600 - minutes * 60;
        var hh, mm, ss;
        if(hours.toString().length < 2)
            hh = "0" + hours.toString();
        else
            hh = hours.toString();
        if(minutes.toString().length < 2)
            mm="0" + minutes.toString();
        else
            mm = minutes.toString();
        if(seconds.toString().length < 2)
            ss = "0" + seconds.toString();
        else
            ss = seconds.toString();
        return hh+":" + mm + ":" + ss
    }

}
