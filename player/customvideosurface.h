/******************************************************************
Copyright 2022 Guangzhou ALIENTEK Electronincs Co.,Ltd. All rights reserved
Copyright © Deng Zhimao Co., Ltd. 1990-2030. All rights reserved.
* @projectName   videoplayer
* @brief         customvideosurface.h
* @author        Deng Zhimao
* @email         dengzhimao@alientek.com/1252699831@qq.com
* @date          2022-11-22
* @link          http://www.openedv.com/forum.php
*******************************************************************/
#ifndef CUSTOMVIDEOSURFACE_H
#define CUSTOMVIDEOSURFACE_H

#include <QObject>
#include <QAbstractVideoSurface>

class CustomVideoSurface : public QAbstractVideoSurface
{
    Q_OBJECT
public:
    CustomVideoSurface(QObject *parent = nullptr);

signals:
    void imageReady(QImage);

protected:
    bool present(const QVideoFrame &frame);
    QList<QVideoFrame::PixelFormat> supportedPixelFormats(QAbstractVideoBuffer::HandleType handleType = QAbstractVideoBuffer::NoHandle) const;
};

#endif // CUSTOMVIDEOSURFACE_H
