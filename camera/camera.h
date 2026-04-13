/******************************************************************
Copyright © Deng Zhimao Co., Ltd. 2021-2030. All rights reserved.
* @brief         mediaengine.h
* @author        Deng Zhimao
* @email         dengzhimao@alientek.com/1252699831@qq.com
* @date          2024-11-05
* @link          http://www.openedv.com/forum.php
*******************************************************************/
#ifndef CAMERA_H
#define CAMERA_H
#include <QMediaPlayer>
#include <QObject>
#include <QUrl>
#include <QImage>
#include <QStandardPaths>
#include <QDir>
#include <QMutexLocker>
#include "customcamerasurface.h"
class Camera : public QMediaPlayer
{
    Q_OBJECT
    Q_PROPERTY(QString source READ source WRITE setSource NOTIFY sourceChanged FINAL)
    Q_PROPERTY(QImage image READ image WRITE setImage NOTIFY imageChanged FINAL)
    Q_PROPERTY(QString path READ path WRITE setPath NOTIFY pathChanged FINAL)
public:
    explicit Camera(QMediaPlayer *parent = nullptr);

    enum MediaType{ Movies, Music, Pictures};

    QString source() const;
    void setSource(const QString &newSource);

    QImage image() const;

    QString path() const;
    void setPath(const QString &newPath);

    Q_INVOKABLE void capture();


signals:
    void sourceChanged();
    void imageChanged();
    void pathChanged();
    void noCameraAvailable();
    //void updateVideoListNotification();
    void imageCaptureError(QString);
    void imageCaptureError(int, QString);
    void imageCapture(QString fileName);

private:
    QString m_source;
    CustomCameraSurface * m_customCameraSurface;
    QImage m_image;

    mutable QMutex m_mutex;
    mutable QHash<QString, qint64> m_lastUsedIndex;
    QString m_path;
    QMap<MediaType, QStringList> m_customLocations;
    QString generateFileName(const QString &requestedName,
                             MediaType type,
                             const QString &prefix,
                             const QString &extension);
    QString generateFileName(const QString &prefix,
                             const QDir &dir,
                             const QString &extension);
    QDir defaultLocation(MediaType type);

private slots:
    void setImage(const QImage &newImage);
};

#endif // CAMERA_H
