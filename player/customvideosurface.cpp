/******************************************************************
Copyright 2022 Guangzhou ALIENTEK Electronincs Co.,Ltd. All rights reserved
Copyright © Deng Zhimao Co., Ltd. 1990-2030. All rights reserved.
* @projectName   videoplayer
* @brief         customvideosurface.cpp
* @author        Deng Zhimao
* @email         dengzhimao@alientek.com
* @date          2022-11-21
* @link          http://www.openedv.com/forum.php
*******************************************************************/
#include "customvideosurface.h"
#include <QDebug>

CustomVideoSurface::CustomVideoSurface(QObject *parent) : QAbstractVideoSurface(parent)
{

}

QList<QVideoFrame::PixelFormat> CustomVideoSurface::supportedPixelFormats(QAbstractVideoBuffer::HandleType handleType) const
{
    Q_UNUSED(handleType);
    QList<QVideoFrame::PixelFormat> listPixelFormats;
    listPixelFormats << QVideoFrame::Format_RGB565;

    return listPixelFormats;
}

bool CustomVideoSurface::present(const QVideoFrame &frame)
{
    if (frame.isValid()) {
        QVideoFrame cloneFrame(frame);
        cloneFrame.map(QAbstractVideoBuffer::ReadOnly);
        QImage image(cloneFrame.bits(), cloneFrame.width(), cloneFrame.height(),
                     QVideoFrame::imageFormatFromPixelFormat(cloneFrame.pixelFormat()));
        cloneFrame.unmap();
        emit imageReady(image);
        return true;
    }
    return false;
}

