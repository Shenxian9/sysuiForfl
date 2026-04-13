/******************************************************************
Copyright © Deng Zhimao Co., Ltd. 2021-2030. All rights reserved.
* @projectName   music
* @brief         imageanalyzer.cpp
* @author        Deng Zhimao
* @email         dengzhimao@alientek.com/1252699831@qq.com
* @date          2023-10-20
* @link          http://www.openedv.com/forum.php
*******************************************************************/
#include "imageanalyzer.h"

QString ImageAnalyzer::getColor1()
{
    return m_color1.name();
}

QString ImageAnalyzer::getColor2()
{
    return m_color2.name();
}

QString ImageAnalyzer::getColor3()
{
    return m_color3.name();
}

ImageAnalyzer::ImageAnalyzer(QQuickItem *parent)
    : QQuickItem(parent),
      m_dominantHue(0)
{

}

ImageAnalyzer::~ImageAnalyzer()
{

}

void ImageAnalyzer::analyzeImage(const QUrl &imageUrl)
{
    QString localFilePath = imageUrl.toLocalFile();
    QImage image(localFilePath);
    if (!image.isNull()) {
        QColor dominantColor = image.scaled(1, 1).pixelColor(0, 0);
        m_dominantHue = dominantColor.hueF();
        emit dominantHueChanged();
    }
}

void ImageAnalyzer::analyzeImage(const QString &imageStr)
{
    //QString localFilePath = imageUrl.toLocalFile();
    QImage image(imageStr);
    if (!image.isNull()) {
        QColor dominantColor = image.scaled(1, 1).pixelColor(0, 0);
        //QColor dominantColor = findDominantColor(image);
        m_color3 =  QColor(dominantColor.red() / 2, dominantColor.green() / 2, dominantColor.blue() / 2);
        m_color2 =  dominantColor;
        m_color1 = QColor(dominantColor.red() * 1.2, dominantColor.green() * 1.2, dominantColor.blue() * 1.2);
        m_dominantHue = dominantColor.hueF();
        emit dominantHueChanged();
    }
}

qreal ImageAnalyzer::dominantHue() const
{
    return m_dominantHue;
}

/*QColor ImageAnalyzer::findDominantColor(const QImage &image)
{
    QMap<QRgb, int> colorCounts;

       // 遍历图片的每一个像素
       for (int y = 0; y < image.height(); ++y) {
           for (int x = 0; x < image.width(); ++x) {
               QRgb color = image.pixel(x, y);
               colorCounts[color]++;
           }
       }

       // 找到出现次数最多的颜色
       QRgb dominantColorRgb = 0;
       int maxCount = 0;
       QMapIterator<QRgb, int> i(colorCounts);
       while (i.hasNext()) {
           i.next();
           if (i.value() > maxCount) {
               maxCount = i.value();
               dominantColorRgb = i.key();
           }
       }

       // 返回QColor对象
       return QColor(dominantColorRgb);
}*/
