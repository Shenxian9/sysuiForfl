/******************************************************************
Copyright © Deng Zhimao Co., Ltd. 1990-2030. All rights reserved.
* @projectName   photoview
* @brief         photoListModel.h
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
#include <QFileSystemWatcher>

class photo {
public:
    explicit photo(QUrl path, QString title);
    QString gettitle() const;
    QUrl getpath() const;
    void settitle(QString title);

public:
    QString  m_title;
    QUrl m_path;
};

class PhotoListModel : public QAbstractListModel
{
    Q_OBJECT
    Q_PROPERTY(QString photoDirPath READ photoDirPath WRITE setPhotoDirPath NOTIFY photoDirPathChanged)
public:
    explicit PhotoListModel(QObject *parent = 0);
    ~PhotoListModel();
    int currentIndex() const;
    int rowCount(const QModelIndex & parent = QModelIndex()) const;
    QVariant data(const QModelIndex & index, int role = Qt::DisplayRole) const;
    Q_INVOKABLE int randomIndex();
    Q_INVOKABLE QString getcurrentTitle() const;
    Q_INVOKABLE QUrl getcurrentPath() const;
    Q_INVOKABLE void move(int from, int to);
    Q_INVOKABLE void remove(int first, int last);
    Q_INVOKABLE void removeOne(int index);
    Q_INVOKABLE void setCurrentTitle(QString title);
    Q_PROPERTY(int currentIndex READ currentIndex WRITE setCurrentIndex NOTIFY currentIndexChanged)
    Q_INVOKABLE void setCurrentIndex(const int & i);
    Q_INVOKABLE int count();
    Q_INVOKABLE void addPhoto(QString fileName);
    Q_INVOKABLE void addPhoto(QUrl path, QString title);
    static bool compareByCreationTime(const QFileInfo &a, const QFileInfo &b);

    enum photoRole {
        pathRole = Qt::UserRole + 1,
        titleRole,
    };

    const QString &photoDirPath() const;
    void setPhotoDirPath(const QString &newPhotoDirPath);

signals:
    void currentIndexChanged();
    void photoDirPathChanged();

public slots:
    void updateModel();

private:
    QHash<int, QByteArray> roleNames() const;
    int m_currentIndex;
    QList<photo> photoListData;
    QFileSystemWatcher *m_fileSystemWather;
    QString m_photoDirPath;
};

#endif // PHOTOLISTMODEL_H
