#include "KxFileSearch.h"
#include <QDebug>
#include <QFileInfo>
#include <QDir>

KxFileSearch::KxFileSearch(QObject *parent)
    : QObject(parent)
    , m_isRuning(false)
    , m_state("init")
{
}

QString KxFileSearch::getState() const
{
    return m_state;
}

void KxFileSearch::search(const QString &path, const QStringList &nameFilters)
{
    if(m_listPause.isEmpty()){
        if(!m_isRuning){
            QMetaObject::invokeMethod(this, "doSearch", Qt::QueuedConnection, Q_ARG(QString, path), Q_ARG(QStringList, nameFilters));
            m_isRuning = true;
            m_state = "start";
            emit statusChanged();
        }else{
            m_list.append(Data(path, nameFilters));
        }
    }else{
        m_listPause.append(Data(path, nameFilters));
    }
}

void KxFileSearch::pause()
{
    if(!m_list.isEmpty()){
        m_listPause.append(m_list);
        m_list.clear();
    }
}

void KxFileSearch::resume()
{
    if(!m_listPause.isEmpty())
    {
        m_list.append(m_listPause);
        m_listPause.clear();
        Data d = m_list.takeFirst();
        search(d.path, d.filter);
    }
}

void KxFileSearch::stop()
{
    m_listPause.clear();
    m_list.clear();
    if(m_state != "stop"){
        m_state = "stop";
        emit statusChanged();
    }
}

void KxFileSearch::doSearch(const QString &path, const QStringList &filters)
{
    QDir dir(path);
    dir.setNameFilters(filters);
    QFileInfoList files = dir.entryInfoList(QDir::AllEntries|QDir::NoDotAndDotDot, QDir::DirsFirst);
    for(int i = 0; i < files.count(); i++){
        QFileInfo fi = files.at(i);
        emit searchResult(path, fi.filePath(), fi.isDir());
    }
    if(!m_listPause.isEmpty()){
        m_isRuning = false;
        m_state = "pause";
        emit statusChanged();
    }else if(!m_list.isEmpty()){
        Data d = m_list.takeFirst();
        QMetaObject::invokeMethod(this, "doSearch", Qt::QueuedConnection, Q_ARG(QString, d.path), Q_ARG(QStringList, d.filter));
    }else{
        m_isRuning = false;
        m_state = "stop";
        emit statusChanged();
    }
}
