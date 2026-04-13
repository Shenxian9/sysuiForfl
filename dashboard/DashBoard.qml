/******************************************************************
Copyright © Deng Zhimao Co., Ltd. 2021-2030. All rights reserved.
* @brief         DashBoard.qml
* @author        Deng Zhimao
* @email         dengzhimao@alientek.com/1252699831@qq.com
* @date          2024-07-18
* @link          http://www.openedv.com/forum.php
*******************************************************************/
import QtQuick 2.12
import QtQuick.Extras 1.4
import QtQuick.Layouts 1.2
import QtQuick.Controls.Styles 1.4

Item {
    id: dashboardItem
    property int  dashboarMaximumValue: 100
    property bool accelerating: false

    width: 640
    height: width

    Rectangle {
        anchors.centerIn: parent
        width: 230 * scaleFacter
        height: width
        color: "#88515151"
        radius: height / 2
    }

    property real minimumValue: 0
    property real maximumValue: 130 * (dashboarMaximumValue / 100)
    property real currentValue: 0
    Behavior on currentValue { PropertyAnimation { duration: 1500; easing.type: Easing.InOutExpo} }


    onCurrentValueChanged: canvas.requestPaint()

    Canvas {
        id: canvas
        width: 640 * scaleFacter
        renderTarget: Canvas.FramebufferObject
        height: width
        antialiasing: true
        anchors.centerIn: parent

        property real centerWidth: width / 2
        property real centerHeight: height / 2
        property real radius: width / 4 // 半径

        // this is the angle that splits the circle in two arcs
        // first arc is drawn from 0 radians to angle radians
        // second arc is angle radians to 2*PI radians
        property real angle: (currentValue - minimumValue) / (maximumValue - minimumValue) * 2 * Math.PI

        // we want both circle to start / end at 12 o'clock
        // without this offset we would start / end at 9 o'clock
        property real angleOffset: -Math.PI / 2
        signal clicked()

        onPaint: {
            var ctx = getContext("2d")
            ctx.save()
            ctx.clearRect(0, 0, canvas.width, canvas.height)

            // inside background arc 1
            ctx.beginPath()
            ctx.lineWidth = 50 * scaleFacter
            ctx.strokeStyle = "#123e48"
            ctx.lineCap = "round"
            ctx.arc(canvas.centerWidth,
                    canvas.centerHeight,
                    canvas.radius,
                    2.3,
                    7.1)
            ctx.stroke()

            // outside background arc 1
            ctx.beginPath()
            ctx.lineWidth = 30 * scaleFacter
            var grd = ctx.createLinearGradient(0, 0, 640, 0)
            grd.addColorStop(0, "#57c2fd")
            grd.addColorStop(0.5, "#63fbab")
            grd.addColorStop(1.0, "#5dfbd4")
            ctx.strokeStyle = grd
            ctx.fillStyle = grd
            ctx.lineCap = "round"
            ctx.arc(canvas.centerWidth,
                    canvas.centerHeight,
                    canvas.radius * 1.5,
                    2.3,
                    5)
            ctx.stroke()

            // outside background arc 2
            ctx.beginPath()
            ctx.lineWidth = 30 * scaleFacter
            grd.addColorStop(0, "#51a7fd")
            grd.addColorStop(0.5, "#63fbab")
            grd.addColorStop(1.0, "#51a7fd")
            ctx.strokeStyle = grd
            ctx.fillStyle = grd
            ctx.lineCap = "round"
            ctx.arc(canvas.centerWidth,
                    canvas.centerHeight,
                    canvas.radius * 1.5,
                    5.2,
                    6)
            ctx.stroke()

            // outside background arc 3
            ctx.beginPath()
            ctx.lineWidth = 30 * scaleFacter
            grd.addColorStop(0, "#51a7fd")
            grd.addColorStop(0.5, "#63fbab")
            grd.addColorStop(1.0, "#51a7fd")
            ctx.strokeStyle = grd
            ctx.fillStyle = grd
            ctx.lineCap = "round"
            ctx.arc(canvas.centerWidth,
                    canvas.centerHeight,
                    canvas.radius * 1.5,
                    6.2,
                    8.2)
            ctx.stroke() // draw path

            //progress arc
            ctx.beginPath()
            ctx.lineWidth = 30 * scaleFacter
            ctx.lineCap = "round"
            //grd = ctx.createLinearGradient(0, 0, 640, 0)
            grd.addColorStop(0, "#57c2fd")
            grd.addColorStop(0.5, "#63fbab")
            grd.addColorStop(1.0, "#5dfbd4")
            ctx.strokeStyle = grd
            ctx.fillStyle = grd

            ctx.arc(canvas.centerWidth,
                    canvas.centerHeight,
                    canvas.radius,
                    2.3,
                    2.3 + canvas.angle)
            ctx.stroke()
            ctx.restore()

            ctx.save();
            ctx.lineWidth = 20;
            ctx.beginPath()
            ctx.lineCap = "round"
            grd = ctx.createLinearGradient(0, -200, 0, 0)
            grd.addColorStop(0, "#72e6eb")
            grd.addColorStop(1.0, "transparent")
            ctx.strokeStyle = grd
            ctx.fillStyle = grd
            ctx.translate(canvas.width / 2, canvas.height / 2);
            ctx.rotate(( (220 + currentValue * 2.8)) * Math.PI / 180);
            ctx.moveTo(0, 0);
            ctx.lineTo(0, -canvas.centerWidth / 2);
            ctx.stroke();
            ctx.restore(); // draw preview, ctx.save();
        }
    }

    Text {
        id: txt_progress
        anchors.centerIn: parent

        font.pixelSize: 80 * scaleFacter
        font.bold: true
        text: Math.round(currentValue)
        color: "white"
    }


    function getRandomNumber() {
        var min = 0;
        var max = 100;
        var random = Math.floor(Math.random() * (max - min + 1)) + min;
        return random;
    }
    Timer {
        interval: 2000
        running: true
        repeat: true
        onTriggered: {
            currentValue = getRandomNumber()
        }
    }
}
