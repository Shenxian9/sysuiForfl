/******************************************************************
Copyright 2022 Guangzhou ALIENTEK Electronincs Co.,Ltd. All rights reserved
Copyright © Deng Zhimao Co., Ltd. 1990-2030. All rights reserved.
* @projectName   videoplayer
* @brief         mediaplay.h
* @author        Deng Zhimao
* @email         dengzhimao@alientek.com/1252699831@qq.com
* @date          2022-11-22
* @link          http://www.openedv.com/forum.php
*******************************************************************/
#ifndef MEDIAPLAYER_H
#define MEDIAPLAYER_H

#include <QObject>
#include <QMediaPlayer>
#include <QVideoFrame>
#include <QUrl>
#include "customvideosurface.h"

class MediaPlayer : public QMediaPlayer
{
    Q_OBJECT
    Q_PROPERTY(QString source READ source WRITE setSource NOTIFY sourceChanged)
    Q_PROPERTY(QImage image READ image NOTIFY imageChanged)
public:
    explicit MediaPlayer(QObject *parent = nullptr);

    QString source() const;
    void setSource(const QString &newSource);

    QImage image() const;

signals:
    void imageReady(QImage);
    void sourceChanged();
    void imageChanged();

private:
    CustomVideoSurface *mCustomVideoSurface;
    QString m_source;
    QImage m_image;

private slots:
    void setImage(const QImage &newImage);
};

#endif // MEDIAPLAYER_H
