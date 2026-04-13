/******************************************************************
Copyright © Deng Zhimao Co., Ltd. 2021-2030. All rights reserved.
* @projectName   aquickplugin
* @brief         customcamerasurface.h
* @author        Deng Zhimao
* @email         dengzhimao@alientek.com/1252699831@qq.com
* @link          www.openedv.com
* @date          2023-03-20
* @link          http://www.openedv.com/forum.php
*******************************************************************/
#ifndef CUSTOMCAMERASURFACE_H
#define CUSTOMCAMERASURFACE_H

#include <QObject>
#include <QAbstractVideoSurface>

class CustomCameraSurface : public QAbstractVideoSurface
{
    Q_OBJECT
public:
    CustomCameraSurface(QObject *parent = nullptr);

signals:
    void imageReady(QImage);

protected:
    bool present(const QVideoFrame &frame);
    QList<QVideoFrame::PixelFormat> supportedPixelFormats(QAbstractVideoBuffer::HandleType handleType = QAbstractVideoBuffer::NoHandle) const;
};

#endif // CUSTOMCAMERASURFACE_H
