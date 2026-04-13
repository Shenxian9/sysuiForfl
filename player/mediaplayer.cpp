/******************************************************************
Copyright 2022 Guangzhou ALIENTEK Electronincs Co.,Ltd. All rights reserved
Copyright © Deng Zhimao Co., Ltd. 1990-2030. All rights reserved.
* @projectName   videoplayer
* @brief         mediaplay.cpp
* @author        Deng Zhimao
* @email         dengzhimao@alientek.com/1252699831@qq.com
* @date          2022-11-22
* @link          http://www.openedv.com/forum.php
*******************************************************************/
#include "mediaplayer.h"

MediaPlayer::MediaPlayer(QObject *parent) : QMediaPlayer(parent)
{
    mCustomVideoSurface = new CustomVideoSurface(this);
    this->setVideoOutput(mCustomVideoSurface);
    connect(mCustomVideoSurface, SIGNAL(imageReady(QImage)), this, SLOT(setImage(QImage)));
    // QObject::connect(this, &QMediaPlayer::stateChanged, [this](QMediaPlayer::State state) {
    //     if (state == QMediaPlayer::StoppedState)
    //         this->setMedia(nullptr);
    // });
}

QString MediaPlayer::source() const
{
    return m_source;
}

void MediaPlayer::setSource(const QString &newSource)
{
    if (m_source == newSource)
        return;
    this->stop();
    m_source = newSource;
    emit sourceChanged();
    this->setMedia(QUrl(m_source));
}

QImage MediaPlayer::image() const
{
    return m_image;
}

void MediaPlayer::setImage(const QImage &newImage)
{
    // if (m_image == newImage) // Fix the bug that causes the program to crash due to frequent switching of resources.
    //     return;
    m_image = newImage;
    emit imageChanged();
}

