/******************************************************************
Copyright © Deng Zhimao Co., Ltd. 2021-2030. All rights reserved.
* @brief         camera.cpp
* @author        Deng Zhimao
* @email         dengzhimao@alientek.com/1252699831@qq.com
* @date          2024-11-05
* @link          http://www.openedv.com/forum.php
*******************************************************************/
#include "camera.h"
#include <QVideoProbe>
#include <QFile>
#include <QProcess>
#include <QBuffer>
#include <QCameraImageCapture>

Camera::Camera(QMediaPlayer *parent)
    : QMediaPlayer{parent}
{
    m_customCameraSurface = new CustomCameraSurface(this);
    this->setVideoOutput(m_customCameraSurface);
    connect(m_customCameraSurface, SIGNAL(imageReady(QImage)), this, SLOT(setImage(QImage)));
}

QString Camera::source() const
{
    return m_source;
}

void Camera::setSource(const QString &newSource)
{
    if (m_source == newSource)
        return;
    m_source = newSource;
    this->stop();
    this->setMedia(QUrl(m_source));
    this->play();
    emit sourceChanged();
}

QImage Camera::image() const
{
    return m_image;
}

QString Camera::path() const
{
    return m_path;
}

void Camera::setPath(const QString &newPath)
{
    if (m_path == newPath)
        return;
    m_path = newPath;
    emit pathChanged();
}

void Camera::capture()
{
    QString fileName = generateFileName(m_path,
                                         MediaType::Pictures,
                                         QLatin1String("IMG_"),
                                         QLatin1String("JPG"));
     QTransform transform;
     //transform.rotate(270);

     QByteArray ba;
     QBuffer buffer(&ba);
     buffer.open(QIODevice::WriteOnly);
     m_image.transformed(transform, Qt::SmoothTransformation).save(&buffer, "JPG", 100);

     QFile file(fileName);
     if (file.open(QFile::WriteOnly)) {
         if (file.write(ba) == ba.size()) {
             emit imageCapture(fileName);
         } else {
             emit imageCaptureError(file.errorString());
         }
     } else {
         const QString errorMessage = tr("Could not open destination file: %1").arg(fileName);
         emit imageCaptureError(QCameraImageCapture::ResourceError, errorMessage);
     }

}

QString Camera::generateFileName(const QString &requestedName, MediaType type, const QString &prefix, const QString &extension)
{
    if (requestedName.isEmpty())
        return generateFileName(prefix, defaultLocation(type), extension);

    QString path = requestedName;

    if (QFileInfo(path).isRelative())
        path = defaultLocation(type).absoluteFilePath(path);

    if (QFileInfo(path).isDir())
        return generateFileName(prefix, QDir(path), extension);

    if (!path.endsWith(extension))
        path.append(QString(QLatin1String(".%1")).arg(extension));

    return path;
}

QString Camera::generateFileName(const QString &prefix, const QDir &dir, const QString &extension)
{
    QMutexLocker lock(&m_mutex);

    const QString lastMediaKey = dir.absolutePath() + QLatin1Char(' ') + prefix + QLatin1Char(' ') + extension;
    qint64 lastMediaIndex = m_lastUsedIndex.value(lastMediaKey, 0);

    if (lastMediaIndex == 0) {
        // first run, find the maximum media number during the fist capture
        const auto list = dir.entryList(QStringList() << QString(QLatin1String("%1*.%2")).arg(prefix).arg(extension));
        for (const QString &fileName : list) {
            const qint64 mediaIndex = fileName.midRef(prefix.length(), fileName.size() - prefix.length() - extension.length() - 1).toInt();
            lastMediaIndex = qMax(lastMediaIndex, mediaIndex);
        }
    }

    // don't just rely on cached lastMediaIndex value,
    // someone else may create a file after camera started
    while (true) {
        const QString name = QString(QLatin1String("%1%2.%3")).arg(prefix)
                .arg(lastMediaIndex + 1, 8, 10, QLatin1Char('0'))
                .arg(extension);

        const QString path = dir.absoluteFilePath(name);
        if (!QFileInfo::exists(path)) {
            m_lastUsedIndex[lastMediaKey] = lastMediaIndex + 1;
            return path;
        }

        lastMediaIndex++;
    }

    return QString();
}

QDir Camera::defaultLocation(MediaType type)
{
    QStringList dirCandidates;

    dirCandidates << m_customLocations.value(type);

    switch (type) {
    case Movies:
        dirCandidates << QStandardPaths::writableLocation(QStandardPaths::MoviesLocation);
        break;
    case Music:
        dirCandidates << QStandardPaths::writableLocation(QStandardPaths::MusicLocation);
        break;
    case Pictures:
        dirCandidates << QStandardPaths::writableLocation(QStandardPaths::PicturesLocation);
    default:
        break;
    }

    dirCandidates << QDir::homePath();
    dirCandidates << QDir::currentPath();
    dirCandidates << QDir::tempPath();

    for (const QString &path : qAsConst(dirCandidates)) {
        if (QFileInfo(path).isWritable())
            return QDir(path);
    }

    return QDir();
}


void Camera::setImage(const QImage &newImage)
{
    if (m_image == newImage)
        return;

    m_image = newImage;
    emit imageChanged();
}

