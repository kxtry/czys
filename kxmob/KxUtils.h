#ifndef _KXUTILS_H_
#define _KXUTILS_H_

#include<QObject>

class KxUtils : public QObject
{
    Q_OBJECT
    Q_PROPERTY(QString genericPath READ genericPath)

public:
    explicit KxUtils(QObject *parent = NULL);

    QString genericPath() const;
};

#endif
