/******************************************************************
Copyright © Deng Zhimao Co., Ltd. 2021-2030. All rights reserved.
* @projectName   music
* @brief         MusicLayout.qml
* @author        Deng Zhimao
* @email         dengzhimao@alientek.com/1252699831@qq.com
* @link          www.openedv.com
* @date          2024-05-04
*******************************************************************/
import QtQuick 2.12
import QtMultimedia 5.0
import QtQuick.Controls 2.5
import com.alientek.qmlcomponents 1.0
import QtQuick.Layouts 1.12
Item {
    id: musicLayout
    anchors.fill: parent
    property int lyric_CurrtentIndex: -1
    property int control_duration: 0
    signal playBtnSignal()
    signal previousBtnSignal()
    signal nextBtnSignal()
    signal playProgressChanged(real playProgress)
    property int progress_maximumValue: 0
    property bool progress_pressed: false
    property int progress_value: 0
    property int music_loopMode: 2
    property real scaleFacter: musicLayout.width / 720

    property string color1
    property string color2
    property string color3

    function songsInit(){
        music_playlistModel.add(appCurrtentDir)
    }

    LyricModel {
        id: music_lyricModel
    }

    PlayListModel {
        id: music_playlistModel
        currentIndex: 0
        onCurrentIndexChanged: {
            musicPlayer.source = getcurrentPath()
            musicPlayer.play() // ???
        }

        onSongNameChanged: {
            music_lyricModel.setPathofSong(music_playlistModel.songName, appCurrtentDir)
        }
        Component.onCompleted: {
            songsInit()
        }
    }

    function currentMusicTime(time){
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
        return /*hh+":"*/ + mm + ":" + ss
    }

    onPlayBtnSignal: {
        if (playList.musicCount === 0)
            return
        if (music_playlistModel.currentIndex !== -1) {
            musicPlayer.source =  music_playlistModel.getcurrentPath()
            playList.music_currentIndex = music_playlistModel.currentIndex
            playList.musicName = music_playlistModel.getcurrentSongName()
            musicPlayer.playbackState === MediaPlayer.PlayingState ? musicPlayer.pause() : musicPlayer.play()
        }
    }

    onPreviousBtnSignal: {
        switch (music_loopMode) {
        case 0:
        case 1:
        case 2:
            music_playlistModel.currentIndex--
            musicPlayer.play()
            break;
        case 3:
            music_playlistModel.randomIndex();
            musicPlayer.play()
            break;
        }
    }

    onNextBtnSignal: {
        if (musicPlayer.hasAudio)
            switch (music_loopMode) {
            case 0:
            case 1:
            case 2:
                music_playlistModel.currentIndex++
                musicPlayer.play()
                break;
            case 3:
                music_playlistModel.randomIndex()
                musicPlayer.play()
                break;
            }
    }

    Connections {
        target: musicPlayer
        function onPositionChanged() {
            progress_maximumValue = musicPlayer.duration
            if(!progress_pressed) {
                progress_value = musicPlayer.position
                playProgressChanged(musicPlayer.position / musicPlayer.duration)
            }
        }
        function onPlaybackStateChanged() {
            switch (musicPlayer.playbackState) {
            case MediaPlayer.PlayingState:
                break;
            case MediaPlayer.PausedState:
            case MediaPlayer.StoppedState:
                break;
            default:
                break;
            }
        }
        function onStatusChanged() {
            switch (musicPlayer.status) {
            case MediaPlayer.NoMediaMedia:
                break;
            case MediaPlayer.LoadingMedia:
                break;
            case MediaPlayer.LoadedMedia:
                progress_maximumValue = musicPlayer.duration
                break;
            case MediaPlayer.BufferingMedia:
                break;
            case MediaPlayer.StalledMedia:
                break;
            case MediaPlayer.BufferedMedia:
                break;
            case MediaPlayer.InvalidMediaMedia:
                switch (musicPlayer.error) {
                case MediaPlayer.FormatError:
                    ttitle.text = qsTr("需要安装解码器");
                    break;
                case MediaPlayer.ResourceError:
                    ttitle.text = qsTr("文件错误");
                    break;
                case MediaPlayer.NetworkError:
                    ttitle.text = qsTr("网络错误");
                    break;
                case MediaPlayer.AccessDenied:
                    ttitle.text = qsTr("权限不足");
                    break;
                case MediaPlayer.ServiceMissing:
                    ttitle.text = qsTr("无法启用多媒体服务");
                    break;
                }
                break;
            case MediaPlayer.EndOfMedia:
                musicPlayer.autoPlay = true
                music_lyricModel.currentIndex = 0
                progress_maximumValue = 0
                progress_value = 0
                switch (music_loopMode) {
                case 1:
                    musicPlayer.play()
                    break;
                case 2:
                    music_playlistModel.currentIndex++
                    break;
                case 3:
                    music_playlistModel.randomIndex()
                    break;
                default:
                    break;
                }
                break;
            }
        }
    }
    Connections {
        target: music_playlistModel
        function onCurrentIndexChanged() {
            playList.music_currentIndex = music_playlistModel.currentIndex
            playList.musicName = music_playlistModel.songName
        }
    }

    Connections {
        target: playList
        function onMusicNameChanged() {
            music_lyricModel.setPathofSong(playList.musicName, appCurrtentDir)
            //artBg.source = "file://" + appCurrtentDir + "/resource/artist/" + playList.musicName + ".jpg"
        }
    }

    property int art_album_width: parent.width - 250 * scaleFacter
    Item {
        id: album
        z: 10
        x: 125 * scaleFacter
        y: 90 * scaleFacter
        width: parent.width - 250 * scaleFacter
        height: width
        Behavior on width { PropertyAnimation { duration: 250; easing.type: Easing.Linear } }
        Behavior on height { PropertyAnimation { duration: 250; easing.type: Easing.Linear } }
        AlbumImage {
            id: art_album1
            anchors.fill: parent
            visible: false
            source: musicPlayer.hasAudio ?
                        appCurrtentDir + "/resource/artist/" + playList.musicName + ".jpg"  : appCurrtentDir + "/resource/artist/default.jpg"
            radius: 20
        }

        Item {
            anchors.fill: parent
            AlbumImage {
                id: art_album2
                anchors.centerIn: parent
                height: musicPlayer.playbackState === Audio.PlayingState ? art_album_width : art_album_width / 1.2
                width: musicPlayer.playbackState === Audio.PlayingState ? art_album_width : art_album_width / 1.2
                Behavior on width { PropertyAnimation { duration: 250; easing.type: Easing.InOutBack} }
                Behavior on height { PropertyAnimation { duration: 250; easing.type: Easing.InOutBack} }
                visible: !art_album1.visible
                source: musicPlayer.hasAudio ?
                            appCurrtentDir + "/resource/artist/" + playList.musicName + ".jpg"  : appCurrtentDir + "/resource/artist/default.jpg"
                radius: 20

                onSourceChanged: {
                    imageAnalyzer.analyzeImage(art_album2.source);
                    //console.log("Dominant hue: " + imageAnalyzer.dominantHue);
                    color1 =  imageAnalyzer.getColor1()
                    color2 =  imageAnalyzer.getColor2()
                    color3 =  imageAnalyzer.getColor3()
                }
                Component.onCompleted: art_album2.visible = false
            }
        }
    }

    Item {
        z: 10
        anchors.top: parent.verticalCenter
        anchors.right: parent.right
        anchors.left: parent.left
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 150 * scaleFacter
        anchors.rightMargin: 50 * scaleFacter
        anchors.leftMargin: 50 * scaleFacter
        PlayPanel {}
    }

    Rectangle {
        anchors.fill: parent
        gradient: Gradient {
            GradientStop { position: 0.0; color: color1 }
            GradientStop { position: 0.6; color: color2 }
            GradientStop { position: 1.0; color: color3 }
        }
    }
    Rectangle {
        anchors.fill: parent
        opacity: 0.5
        gradient: Gradient {
            orientation: Gradient.Horizontal
            GradientStop { position: 0.0; color: "#8d6e59" }
            GradientStop { position: 0.5; color: "#6b6160" }
            GradientStop { position: 1.0; color: "#394b57" }
        }
    }

    AudioSpectrumAnalyzer {
        id: audioSpectrumAnalyzer
        onBarValueChanged: {
            //fastBlur.radius = 80 + 40 * value
            //fastBlur.scale = 1 + 0.1 * value
            //console.log(value)
        }
    }

    ImageAnalyzer {
        id: imageAnalyzer
    }

    Connections {
        target: musicPlayer
        function onSourceChanged()  {
            audioSpectrumAnalyzer.reset()
        }
    }

    Timer{
        id: myTimer
        running: true
        interval: 2000
        repeat: false
        onTriggered: {
            art_album2.visible = true
            //audioSpectrumAnalyzer.setMediaPlayer(myplayer)
            // releaseResources
            myTimer.destroy()
        }
    }

    Button {
        id: playListBt
        z: 11
        width: 64 * scaleFactor
        height: width
        anchors.right: parent.right
        anchors.rightMargin: 24 * scaleFacter
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 32 * scaleFacter
        opacity: playListBt.pressed ? 0.5 : 1.0
        checkable: true
        checked: false
        background: Rectangle {
            width: 64 * scaleFactor
            height: width
            radius: 10
            color: playListBt.checked ? "#94a2c6" : "transparent"
            Image {
                source: "qrc:/icons/btn_playlist.png"
                width: 44 * scaleFactor
                height: width
                anchors.centerIn: parent
            }
        }
        onCheckedChanged: {
            album.visible = !playListBt.checked
        }
    }

    Button {
        z: 11
        id: broadcatingBt
        anchors.left: parent.left
        anchors.leftMargin: 24 * scaleFacter
        width: 64 * scaleFactor
        height: width
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 32 * scaleFacter
        //opacity: broadcatingBt.pressed ? 0.5 : 1.0
        background: Image {
            source: "qrc:/icons/broadcasting_station.png"
            width: 64 * scaleFactor
            height: width
            anchors.centerIn: parent
            Text {
                text: playList.musicName === "" ?  qsTr("小原的 Solo Pro") : playList.musicName
                color: "white"
                font.pixelSize: 30 * scaleFactor
                anchors.left: parent.right
                anchors.leftMargin: 10
                anchors.verticalCenter: parent.verticalCenter
            }
        }
    }

    PlayList {
        id: playList
        z: 10
        clip: true
        visible: playListBt.checked
        anchors.top: parent.top
        anchors.topMargin: 64 * scaleFacter
        width: parent.width - 120
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.bottom: parent.verticalCenter
    }
}
