/******************************************************************
Copyright © Deng Zhimao Co., Ltd. 2021-2030. All rights reserved.
* @brief         customcamerasurface.cpp
* @author        Deng Zhimao
* @email         dengzhimao@alientek.com/1252699831@qq.com
* @date          2024-11-05
* @link          http://www.openedv.com/forum.php
*******************************************************************/
#include  "customcamerasurface.h"
#include <QVideoFrame>
#include <QDebug>

CustomCameraSurface::CustomCameraSurface(QObject *parent)
    : QAbstractVideoSurface{parent}
{}

bool CustomCameraSurface::present(const QVideoFrame &frame)
{
    if (frame.isValid()) {
        QVideoFrame cloneFrame(frame);
        cloneFrame.map(QAbstractVideoBuffer::ReadOnly);
        QImage image(cloneFrame.bits(), cloneFrame.width(), cloneFrame.height(),
                     QVideoFrame::imageFormatFromPixelFormat(cloneFrame.pixelFormat()));
        cloneFrame.unmap();
        int newWidth = cloneFrame.height() / 4 * 3;
        // keep 3 : 4
        QImage croppedImage = image.copy((cloneFrame.width() - newWidth) / 2 , 0, newWidth, cloneFrame.height());
        // emit imageReady(image.copy());
        emit imageReady(croppedImage);
        return true;
    }
    return false;
}

QList<QVideoFrame::PixelFormat> CustomCameraSurface::supportedPixelFormats(QAbstractVideoBuffer::HandleType handleType) const
{
    Q_UNUSED(handleType);
    QList<QVideoFrame::PixelFormat> listPixelFormats;
    listPixelFormats << QVideoFrame::Format_RGB24;
    return listPixelFormats;
}
