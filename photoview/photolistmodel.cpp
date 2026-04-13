/******************************************************************
Copyright © Deng Zhimao Co., Ltd. 1990-2030. All rights reserved.
* @projectName   Photoview
* @brief         PhotoListModel.cpp
* @author        Deng Zhimao
* @email         1252699831@qq.com
* @date          2020-07-18
*******************************************************************/
#include "photolistmodel.h"
#include <QDir>
#include <QDebug>
#include <QDirIterator>
#include <QTimer>
Photo::Photo(QObject *parent) : QObject{ parent }, m_checked(false){
}

QString Photo::title() const
{
    return m_title;
}

void Photo::setTitle(const QString &newTitle)
{
    if (m_title == newTitle)
        return;
    m_title = newTitle;
    emit titleChanged();
}

QUrl Photo::path() const
{
    return m_path;
}

void Photo::setPath(const QUrl &newPath)
{
    if (m_path == newPath)
        return;
    m_path = newPath;
    emit pathChanged();
}

bool Photo::checked() const
{
    return m_checked;
}

void Photo::setChecked(bool newChecked)
{
    if (m_checked == newChecked)
        return;
    m_checked = newChecked;
    emit checkedChanged();
}

PhotoListModel::PhotoListModel(QObject *parent) : QAbstractListModel(parent) {
    m_currentIndex = -1;
    photoListData.clear();
    fileSystemWatcher = new QFileSystemWatcher(this);
    QTimer *timer = new QTimer(this);
    QObject::connect(timer, &QTimer::timeout, [this,timer](){
        timer->stop();
        updateModel();
    });
    QObject::connect(fileSystemWatcher, &QFileSystemWatcher::directoryChanged, [this,timer](){
        //this->add(m_albumPath);
        //updateModel();
        timer->stop();
        timer->start(2000);
    });
}

bool PhotoListModel::compareByCreationTime(const QFileInfo &a, const QFileInfo &b)
{
    return a.created() < b.created();
}

void PhotoListModel::updateModel()
{
    int tmpCount = photoListData.count() - 1;
    for (int i = tmpCount; i >= 0 ; --i) {
        QString localFilePath = photoListData[i]->path().toLocalFile();
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
    filters<<"*.jpg"<<"*.png"<<"*.jpeg";

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
        foreach (Photo *tmpPhoto, photoListData) {
            if (tmpPhoto->path() == QUrl::fromLocalFile(fileInfo.absoluteFilePath())) {
                isAreadyExists = true;
            }
        }
        if (!isAreadyExists)
            pathList.append(QUrl::fromLocalFile(fileInfo.absoluteFilePath()));
    }
    count = pathList.count();
    for (index = 0; index < count; index ++) {
        Photo *p = new Photo;
        title = pathList.at(index).fileName(QUrl::FullyDecoded).remove(-4, 4);
        p->setPath(pathList.at(index));
        p->setTitle(title);
        addPhoto(p);
    }

    if (m_currentIndex >= 0 && photoListData.count()) {
        setCurrentIndex(photoListData.count() - 1);
    }
}

PhotoListModel::~PhotoListModel()
{
}

int PhotoListModel::currentIndex() const {
    return m_currentIndex;
}

int PhotoListModel::rowCount(const QModelIndex & parent) const {
    Q_UNUSED(parent);
    return photoListData.count();
}

QVariant PhotoListModel::data(const QModelIndex & index, int role) const {
    if (index.row() < 0 || index.row() >= photoListData.count())
        return QVariant();
    switch (role) {
    case PhotoRole:
        return QVariant::fromValue(static_cast<QObject *>(photoListData.value(index.row())));
        break;
    default:
        return QVariant();
    }
}

int PhotoListModel::randomIndex() {
    int tmp;
    srand(time(NULL));
    do {
        tmp = qrand() % photoListData.count();
    } while (tmp == m_currentIndex);
    setCurrentIndex(tmp);
    return tmp;
}

QString PhotoListModel::getcurrentTitle() const {
    return photoListData.at(m_currentIndex)->title();
}

QUrl PhotoListModel::getcurrentPath() const {
    return photoListData.at(m_currentIndex)->path();
}

void PhotoListModel::add( QString paths) {
    m_photoDirPath = paths;
    if (photoListData.count() > 0)
        this->remove(0, photoListData.count() - 1);
    int count, index;
    QString  title;
    QDir dir(paths);
    if(!dir.exists()){
        qDebug()<<"src/images or src/Photos Dir not exist"<<endl;
        return ;
    }
    QStringList filter;
    filter<<"*.jpg"<<"*.png"<<"*.jpeg";
    QDirIterator it(paths, filter, QDir::Files | QDir::NoSymLinks);
    QList<QUrl> pathList;
    while (it.hasNext()){
        it.next();
        QFileInfo fileif = it.fileInfo();
        QString PhotosPath = QString::fromUtf8((QString("file://" + fileif.filePath()).toUtf8().data()));

        //qDebug()<<PhotosPath<<endl;
        pathList.append(PhotosPath);
    }
    count = pathList.count();
    for (index = 0; index < count; index ++) {
        title = pathList.at(index).fileName(QUrl::FullyDecoded).remove(-4, 4);
        Photo *p = new Photo;
        p->setPath(pathList.at(index));
        p->setTitle(title);
        addPhoto(p);
    }

    /*if (m_currentIndex < 0 && photoListData.count()) {
        setCurrentIndex(photoListData.count() - 1);
    }*/
    emit listModelInit();
}

void PhotoListModel::move(int from, int to) {
    beginMoveRows(QModelIndex(), from, from, QModelIndex(), to);
    photoListData.move(from, to);
    endMoveRows();
}

void PhotoListModel::remove(int first, int last) {
    revert();
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
    revert();
    if (m_currentIndex >= photoListData.count()) {
        setCurrentIndex(photoListData.count() - 1);
    }
}

void PhotoListModel::removeOne(int index) {
    if (photoListData.count() != 0) {
        QFile file(photoListData.at(index)->path().toString().mid(8));
        qDebug() << file.fileName();
        beginRemoveRows(QModelIndex(), index, index);
        photoListData.removeAt(index);
        if (file.remove())
            qDebug() << "delete ok" <<endl;
        endRemoveRows();
        /*if (m_currentIndex >= photoListData.count()) {
            setCurrentIndex(photoListData.count() - 1);
        }*/
    } else {
    }
}

void PhotoListModel::setCurrentTitle(QString title) {
    Photo *s = photoListData.at(m_currentIndex);
    s->setTitle(title);
    photoListData.replace(m_currentIndex, s);
}

void PhotoListModel::setCurrentIndex(const int & i) {
    if (i >= photoListData.count() && m_currentIndex != 0) {
        m_currentIndex = 0;
        emit currentIndexChanged();
    } else if ((i >= 0) && (i < photoListData.count()) && (m_currentIndex != i)) {
        m_currentIndex = i;
        emit currentIndexChanged();
    } else if(i < 0) {
        m_currentIndex = -1;
        emit currentIndexChanged();
    }
}

QHash<int, QByteArray> PhotoListModel::roleNames() const {
    QHash<int, QByteArray> role;
    role[PhotoRole] = "photo";
    return role;
}

QString PhotoListModel::albumPath() const
{
    return m_albumPath;
}

void PhotoListModel::setAlbumPath(const QString &newAlbumPath)
{
    if (m_albumPath == newAlbumPath)
        return;
    if (m_albumPath != "")
        fileSystemWatcher->removePath(m_albumPath);
    m_albumPath = newAlbumPath;

    // upate album
    add(m_albumPath);

    fileSystemWatcher->addPath(newAlbumPath);

    emit albumPathChanged();
}

void PhotoListModel::deleteSelectPhotos()
{
    int tmpCount = photoListData.count() - 1;
    for (int i = tmpCount; i >= 0 ; --i) {
        if (photoListData[i]->checked()) {
            QString localFilePath = photoListData[i]->path().toLocalFile();
            QFile file(localFilePath);
            if (file.exists())
                file.remove();;
            beginRemoveRows(QModelIndex(), i, i);
            photoListData.removeAt(i);
            endRemoveRows();
        }
    }
    //Q_EMIT countChanged();
}

void PhotoListModel::addPhoto(QString fileName) {
    QUrl path;
    QString title;
    QFile file(fileName);
    Photo *p = new Photo();
    if (file.exists()) {
        QString str = "file:///" + fileName;
        path = QString::fromUtf8((str.toUtf8()).data());
        title = file.fileName();
        p->setPath(path);
        p->setTitle(title);
    } else {
        qDebug() << "Resource error! No such file or dir!" << endl;
        return;
    }
    beginInsertRows(QModelIndex(), photoListData.count(), photoListData.count());
    photoListData.append(p);
    endInsertRows();
    //setCurrentIndex(photoListData.count() - 1);
}

void PhotoListModel::addPhoto(Photo *p) {
    beginInsertRows(QModelIndex(), photoListData.count(), photoListData.count());
    photoListData.append(p);
    endInsertRows();
    //setCurrentIndex(photoListData.count() - 1);
}

int PhotoListModel::count()
{
    return photoListData.count();
}
