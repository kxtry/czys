#ifndef _KXDESKTOPSERVICES_H_
#define _KXDESKTOPSERVICES_H_

#include<QObject>

class KxDesktopServices : public QObject
{
    Q_OBJECT

public:
    explicit KxDesktopServices(QObject *parent = NULL);

    Q_INVOKABLE void openUrl(const QString& url);
};

#endif
