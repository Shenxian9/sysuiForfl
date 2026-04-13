/******************************************************************
Copyright © Deng Zhimao Co., Ltd. 1990-2030. All rights reserved.
* @projectName   photoview
* @brief         photoListModel.cpp
* @author        Deng Zhimao
* @email         1252699831@qq.com
* @date          2020-07-18
*******************************************************************/
#include "photolistmodel.h"
#include <QDir>
#include <QDebug>
#include <QDirIterator>
#include <QDateTime>
photo::photo(QUrl path, QString title)
{
    m_path = path;
    m_title = title;
}

QUrl photo::getpath() const
{
    return m_path;
}

QString photo::gettitle() const
{
    return m_title;
}

void photo::settitle(QString title)
{
    m_title = title;
}

PhotoListModel::PhotoListModel(QObject *parent) : QAbstractListModel(parent)
{
    m_currentIndex = -1;
    photoListData.clear();
    m_fileSystemWather = new QFileSystemWatcher(this);
    connect(m_fileSystemWather, SIGNAL(directoryChanged(QString)), this, SLOT(updateModel()));
}

PhotoListModel::~PhotoListModel()
{
}

int PhotoListModel::currentIndex() const
{
    return m_currentIndex;
}

int PhotoListModel::rowCount(const QModelIndex & parent) const
{
    Q_UNUSED(parent);
    return photoListData.count();
}

QVariant PhotoListModel::data(const QModelIndex & index, int role) const
{
    if (index.row() < 0 || index.row() >= photoListData.count())
        return QVariant();
    const photo &s = photoListData.at(index.row());
    switch (role) {
    case pathRole:
        return s.getpath();
    case titleRole:
        return s.gettitle();
    default:
        return QVariant();
    }
}

int PhotoListModel::randomIndex()
{
    int tmp;
    srand(time(NULL));
    do {
        tmp = qrand() % photoListData.count();
    } while (tmp == m_currentIndex);
    setCurrentIndex(tmp);
    return tmp;
}

QString PhotoListModel::getcurrentTitle() const
{
    return photoListData.at(m_currentIndex).gettitle();
}

QUrl PhotoListModel::getcurrentPath() const
{
    return photoListData.at(m_currentIndex).getpath();
}

void PhotoListModel::updateModel()
{

    int tmpCount = photoListData.count() - 1;
    for (int i = tmpCount; i >= 0 ; --i) {
        QString localFilePath = photoListData[i].getpath().toLocalFile();
        QFile file(localFilePath);
        if (!file.exists()) {
            beginRemoveRows(QModelIndex(), i, i);
            photoListData.removeAt(i);
            endRemoveRows();
        }
    }
    int count, index;
    QString  title;
    QDir dir(m_photoDirPath);
    if(!dir.exists()){
        qDebug()<< m_photoDirPath + "does not exist"<<endl;
        return ;
    }
    QStringList filters;
    QList<QUrl> pathList;
    QFileInfoList fileList;
    filters<<"*.jpg"<<"*.png"<<"*jpeg";

    /*for (const QString &filter : filters) {
    QStringList singleFilter;
    singleFilter << filter;
    QFileInfoList tempList = dir.entryInfoList(QDir::Files | QDir::NoDotAndDotDot, singleFilter);
    fileList.append(tempList);
    }*/

    QDirIterator it(m_photoDirPath, filters, QDir::Files | QDir::NoSymLinks);
    while (it.hasNext()){
        it.next();
        fileList.append(it.fileInfo());
        /*QFileInfo fileif = it.fileInfo();
        qDebug() << fileif.created();
        QString photosPath = QString::fromUtf8((QString("file:///" + fileif.filePath()).toUtf8().data()));
        bool isAreadyExists = false;
        foreach (photo tmpPoto, photoListData) {
            if (tmpPoto.m_path == photosPath)
                isAreadyExists = true;
        }
        if (!isAreadyExists)
            pathList.append(photosPath);*/
    }

    std::sort(fileList.begin(), fileList.end(), compareByCreationTime);

    for (const QFileInfo &fileInfo : fileList) {
        bool isAreadyExists = false;
        foreach (photo tmpPhoto, photoListData) {
            if (tmpPhoto.getpath() == QUrl::fromLocalFile(fileInfo.absoluteFilePath()))
                isAreadyExists = true;
        }
        if (!isAreadyExists)
            pathList.append(QUrl::fromLocalFile(fileInfo.absoluteFilePath()));
    }
    count = pathList.count();
    for (index = 0; index < count; index ++) {
        title = pathList.at(index).fileName(QUrl::FullyDecoded).remove(-4, 4);
        addPhoto(pathList.at(index), title);
    }

    if (m_currentIndex >= 0 && photoListData.count()) {
        setCurrentIndex(photoListData.count() - 1);
    }
}

void PhotoListModel::move(int from, int to)
{
    beginMoveRows(QModelIndex(), from, from, QModelIndex(), to);
    photoListData.move(from, to);
    endMoveRows();
}

void PhotoListModel::remove(int first, int last)
{
    if ((first < 0) && (first >= photoListData.count()))
        return;
    if ((last < 0) && (last >= photoListData.count()))
        return;
    if (first > last) {
        first ^= last;
        last ^= first;
        first ^= last;
    }
    beginRemoveRows(QModelIndex(), first, last);
    while (first <= last) {
        photoListData.removeAt(first);
        last --;
    }
    endRemoveRows();
    if (m_currentIndex >= photoListData.count()) {
        setCurrentIndex(photoListData.count() - 1);
    }
}

void PhotoListModel::removeOne(int index)
{
    if (photoListData.count() != 0) {
        QFile file(photoListData.at(index).getpath().toString().mid(8));
        beginRemoveRows(QModelIndex(), index, index);
        photoListData.removeAt(index);
        if (file.remove())
            qDebug() << "delete ok" <<endl;
        endRemoveRows();
    }
}

void PhotoListModel::setCurrentTitle(QString title)
{
    photo s = photoListData.at(m_currentIndex);
    s.settitle(title);
    photoListData.replace(m_currentIndex, s);
}

void PhotoListModel::setCurrentIndex(const int & i)
{
    if (i >= photoListData.count() && m_currentIndex != 0) {
        m_currentIndex = 0;
        emit currentIndexChanged();
    } else if ((i >= 0) && (i < photoListData.count()) && (m_currentIndex != i)) {
        m_currentIndex = i;
        emit currentIndexChanged();
    }
}

QHash<int, QByteArray> PhotoListModel::roleNames() const {
    QHash<int, QByteArray> role;
    role[pathRole] = "path";
    role[titleRole] = "title";
    return role;
}

const QString &PhotoListModel::photoDirPath() const
{
    return m_photoDirPath;
}

void PhotoListModel::setPhotoDirPath(const QString &newPhotoDirPath)
{
    if (m_photoDirPath == newPhotoDirPath)
        return;
    m_photoDirPath = newPhotoDirPath;
    m_fileSystemWather->addPath(m_photoDirPath);
    emit photoDirPathChanged();
    updateModel();
}

void PhotoListModel::addPhoto(QString fileName)
{
    QUrl path;
    QString title;
    QFile file(fileName);
    if (file.exists()) {
        QString str = "file:///" + fileName;
        path = QString::fromUtf8((str.toUtf8()).data());
        title = file.fileName();
    } else {
        qDebug() << "Resource error! No such file or dir!" << endl;
        return;
    }
    beginInsertRows(QModelIndex(), photoListData.count(), photoListData.count());
    photoListData.append(photo(path, title));
    endInsertRows();
    setCurrentIndex(photoListData.count() - 1);
}

void PhotoListModel::addPhoto(QUrl path, QString title)
{
    beginInsertRows(QModelIndex(), photoListData.count(), photoListData.count());
    photoListData.append(photo(path, title));
    endInsertRows();
    setCurrentIndex(photoListData.count() - 1);
}

bool PhotoListModel::compareByCreationTime(const QFileInfo &a, const QFileInfo &b)
{
    return a.created() < b.created();
}

int PhotoListModel::count()
{
    return photoListData.count();
}
