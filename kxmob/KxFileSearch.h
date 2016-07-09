#ifndef _KXFILESEARCH_H_
#define _KXFILESEARCH_H_

#include<QObject>

class KxFileSearch : public QObject
{
    Q_OBJECT
    Q_PROPERTY(QString state READ getState)
public:
    explicit KxFileSearch(QObject *parent = NULL);

    QString getState() const;

    Q_INVOKABLE void search(const QString& path, const QStringList &nameFilters=QStringList("*"));
    Q_INVOKABLE void pause();
    Q_INVOKABLE void resume();
    Q_INVOKABLE void stop();


Q_SIGNALS:
    void statusChanged();
    void searchResult(const QString& folder, const QString& file, bool isDir);

private Q_SLOTS:
    void doSearch(const QString& path, const QStringList& filters);

private:
    struct Data{
        Data(const QString& p, const QStringList& f){
            path = p;
            filter = f;
        }

        QString path;
        QStringList filter;
    };
    QList<Data> m_list;
    QList<Data> m_listPause;
    bool m_isRuning;
    QString m_state;
};

#endif
