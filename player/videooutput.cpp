/******************************************************************
Copyright © Deng Zhimao Co., Ltd. 2021-2030. All rights reserved.
* @brief         videooutput.cpp
* @author        Deng Zhimao
* @email         dengzhimao@alientek.com/1252699831@qq.com
* @date          2024-09-24
* @link          http://www.openedv.com/forum.php
*******************************************************************/
#include "videooutput.h"
#include <QDebug>

VideoOutput::VideoOutput(QQuickPaintedItem *parent) : QQuickPaintedItem(parent), frameCount(0), m_orientation(0), isBusy(false)
{
    setFlag(ItemHasContents, true);
    this->setRenderTarget(QQuickPaintedItem::FramebufferObject);
    timer = new QTimer(this);
    QObject::connect(timer, &QTimer::timeout, [this]() {
        setFrameRateInfo("显示帧率:" + QString::number(frameCount) + "fps");
        frameCount = 0;
        timer->stop();
    });

    QObject::connect(this, &QQuickPaintedItem::widthChanged, [this]() {
        if (m_source.isNull())
            return;
        isBusy = true;
        this->update();
    });

    QObject::connect(this, &QQuickPaintedItem::heightChanged, [this]() {
        if (m_source.isNull())
            return;
        isBusy = true;
        this->update();
    });
}

void VideoOutput::paint(QPainter *painter)
{
    if (painter == nullptr) {
        return;
    }
    if (m_source.isNull())
        return;
    QPixmap m_pixmapsrc;

    QMatrix leftmatrix;
    leftmatrix.translate(m_source.width() / 2 , m_source.height() / 2);
    leftmatrix.rotate(m_orientation);
    if (m_mediaState == State::PlayingState) {
        if (m_orientation == 0 || m_orientation == 180 ) {
            m_source = m_source.scaledToWidth(width(), Qt::FastTransformation).transformed(leftmatrix, Qt::FastTransformation);
        } else
            m_source = m_source.scaledToWidth(height(), Qt::FastTransformation).transformed(leftmatrix, Qt::FastTransformation);

        m_pixmapsrc = QPixmap::fromImage(m_source);
        painter->drawPixmap((width() - m_source.width()) / 2, (height() - m_source.height()) / 2,
                            m_source.width(), m_source.height(), m_pixmapsrc);
    } else {
        QImage tmpImage = m_source.copy();
        if (m_orientation == 0 || m_orientation == 180 ) {
            tmpImage = tmpImage.scaledToWidth(width(), Qt::FastTransformation).transformed(leftmatrix, Qt::FastTransformation);
        } else
            tmpImage = tmpImage.scaledToWidth(height(), Qt::FastTransformation).transformed(leftmatrix, Qt::FastTransformation);

        m_pixmapsrc = QPixmap::fromImage(tmpImage);
        painter->drawPixmap((width() - tmpImage.width()) / 2, (height() - tmpImage.height()) / 2,
                            tmpImage.width(), tmpImage.height(), m_pixmapsrc);
    }
    frameCount++;
    isBusy = false;
}

int VideoOutput::mediaState() const
{
    return m_mediaState;
}

void VideoOutput::setMediaState(int newMediaState)
{
    if (m_mediaState == newMediaState)
        return;
    m_mediaState = newMediaState;
    emit mediaStateChanged();
}

int VideoOutput::orientation() const
{
    return m_orientation;
}

void VideoOutput::setOrientation(int newOrientation)
{
    if (m_orientation == newOrientation)
        return;
    if (newOrientation == 0 || newOrientation == 180 || newOrientation == 90 || newOrientation == 270) {
        m_orientation = newOrientation;
        qDebug() << "Orientation set to: " << newOrientation ;
    } else {
        qDebug() << "Invalid orientation value. Allowed values are 0, 90, 180, 270." ;
        m_orientation = 0;
    }

    emit orientationChanged();
}

QString VideoOutput::frameRateInfo() const
{
    return m_frameRateInfo;
}

void VideoOutput::setFrameRateInfo(const QString &newFrameRateInfo)
{
    if (m_frameRateInfo == newFrameRateInfo)
        return;
    m_frameRateInfo = newFrameRateInfo;
    emit frameRateInfoChanged();
}

QImage VideoOutput::source() const
{
    return m_source;
}

void VideoOutput::setSource(const QImage &newSource)
{
    if (isBusy)
        return;
    if (m_source == newSource)
        return;
    isBusy = true;
    m_source = newSource.copy();
    this->update();
    emit sourceChanged();
    if (!timer->isActive()) {
        timer->start(1000);
    }
}
