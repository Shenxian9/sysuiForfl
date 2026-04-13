/******************************************************************
Copyright © Deng Zhimao Co., Ltd. 1990-2030. All rights reserved.
* @projectName   Photoview
* @brief         PhotoListModel.h
* @author        Deng Zhimao
* @email         1252699831@qq.com
* @date          2020-07-16
*******************************************************************/
#ifndef PHOTOLISTMODEL_H
#define PHOTOLISTMODEL_H

#include <QAbstractListModel>
#include <QDebug>
#include <QUrl>
#include <QFileInfo>
#include <QDateTime>
#include <QFileSystemWatcher>

class Photo : public QObject {
    Q_OBJECT
    Q_PROPERTY(QString title READ title WRITE setTitle NOTIFY titleChanged)
    Q_PROPERTY(QUrl path READ path WRITE setPath NOTIFY pathChanged)
    Q_PROPERTY(bool checked READ checked WRITE setChecked NOTIFY checkedChanged)
public:
    explicit Photo(QObject *parent = nullptr);

    QString title() const;
    void setTitle(const QString &newTitle);

    QUrl path() const;
    void setPath(const QUrl &newPath);

    bool checked() const;
    void setChecked(bool newChecked);

signals:
    void titleChanged();
    void pathChanged();
    void checkedChanged();

private:
    QString m_title;
    QUrl m_path;
    bool m_checked;
};

class PhotoListModel : public QAbstractListModel
{
    Q_OBJECT

    Q_PROPERTY(QString albumPath READ albumPath WRITE setAlbumPath NOTIFY albumPathChanged)
    Q_PROPERTY(int currentIndex READ currentIndex WRITE setCurrentIndex NOTIFY currentIndexChanged)
public:
    explicit PhotoListModel(QObject *parent = 0);
    ~PhotoListModel();
    int currentIndex() const;
    int rowCount(const QModelIndex & parent = QModelIndex()) const;
    QVariant data(const QModelIndex & index, int role = Qt::DisplayRole) const;
    Q_INVOKABLE int randomIndex();
    Q_INVOKABLE QString getcurrentTitle() const;
    Q_INVOKABLE QUrl getcurrentPath() const;
    Q_INVOKABLE void add(QString paths);
    Q_INVOKABLE void move(int from, int to);
    Q_INVOKABLE void remove(int first, int last);
    Q_INVOKABLE void removeOne(int index);
    Q_INVOKABLE void setCurrentTitle(QString title);
    Q_INVOKABLE void setCurrentIndex(const int & i);
    Q_INVOKABLE int count();
    Q_INVOKABLE void addPhoto(QString fileName);
    Q_INVOKABLE void addPhoto(Photo*);
    static bool compareByCreationTime(const QFileInfo &a, const QFileInfo &b);

    enum PhotoRole {
        PhotoRole = Qt::UserRole + 1,
    };

    QString albumPath() const;
    void setAlbumPath(const QString &newAlbumPath);
    void resetAlbumPath();

signals:
    void currentIndexChanged();
    void listModelInit();

    void albumPathChanged();

public slots:
    void deleteSelectPhotos();
    void updateModel();

private:
    QHash<int, QByteArray> roleNames() const;

    int m_currentIndex;
    QList<Photo *> photoListData;

    QString m_albumPath;
    QFileSystemWatcher *fileSystemWatcher;
    QString m_photoDirPath;
};

#endif // PHOTOLISTMODEL_H
