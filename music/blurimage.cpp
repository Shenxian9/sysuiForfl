/******************************************************************
Copyright © Deng Zhimao Co., Ltd. 1990-2030. All rights reserved.
* @projectName   SystemUI
* @brief         blurimage.cpp
* @author        Deng Zhimao
* @email         1252699831@qq.com/dengzhimao@alientek.com
* @date          2023-12-09
*******************************************************************/
#include "blurimage.h"
#include <QPainter>
#include <QPainterPath>
#include <QDebug>
#include <QRectF>
BlurImage::BlurImage(QQuickItem *parent) : QQuickPaintedItem(parent), m_radius(-1)
{
    setFlag(ItemHasContents, true);
    connect(this, SIGNAL(radiusChanged()), this, SLOT(updateProperties()));
    connect(this, SIGNAL(radiusChanged()), this, SLOT(update()));
    connect(this, SIGNAL(sourceChanged()), this, SLOT(update()));
}

QVariant BlurImage::source() const
{
    return m_source;
}

qreal BlurImage::radius() const
{
    return m_radius;
}

void BlurImage::setSource(const QVariant &source)
{
    m_source = source;
    updateProperties();
    emit sourceChanged();
}

void BlurImage::setBlur(qreal &radius)
{
    m_radius = radius;
    emit radiusChanged();
}

void BlurImage::paint(QPainter *painter)
{
    if (painter == nullptr) {
        return;
    }
    if (m_pixmapsrc.isNull())
        return;

    QPixmap pixmap(width(), width());
    pixmap.fill(Qt::transparent);
    painter->setRenderHints(QPainter::Antialiasing | QPainter::SmoothPixmapTransform);

    int tmpWidth = width() + m_radius / 2;
    QPainterPath path;
    path.addRect(0, 0, tmpWidth, tmpWidth);
    painter->setClipPath(path);
    painter->drawPixmap(-(tmpWidth - width()) / 2, -(tmpWidth - height()) / 2, tmpWidth, tmpWidth, m_pixmapsrc);
}

void BlurImage::updateProperties()
{
    if (m_source == "")
        return;

    if (!m_source.isValid())
        return;

    QString filePath;

    if (m_source.toUrl().isLocalFile())
        filePath = m_source.toUrl().toLocalFile();
    else
        filePath  = m_source.toString();

    QImage image(filePath);

    if (image.isNull())
        return;

    image = image.scaled(width(), height(), Qt::KeepAspectRatioByExpanding);
    qt_blurImage(image, m_radius, false, false);
    m_pixmapsrc = QPixmap::fromImage(image);
}
