#include "KxDesktopServices.h"
#include <QDesktopServices>
#include <QUrl>

KxDesktopServices::KxDesktopServices(QObject *parent)
    : QObject(parent)
{

}

void KxDesktopServices::openUrl(const QString &url)
{
    QDesktopServices::openUrl(QUrl(url));
}
