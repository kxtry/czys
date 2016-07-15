#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QDebug>
#include <QByteArray>
#include <QScreen>
#include <QStandardPaths>
#include <QDir>
#include <QQmlContext>
#include <QSettings>
#include <QQuickStyle>
#include <QFontDatabase>
#include <QTranslator>
#include <QQuickWindow>

#include "kxmob/KxUtils.h"
#include "kxmob/KxFileSearch.h"
#include "kxmob/KxTagParser.h"
#include "kxmob/KxBluetooth.h"
#include "kxmob/KxDesktopServices.h"
#include "kxmob/KxTheme.h"

int main(int argc, char *argv[])
{
    QGuiApplication::setApplicationName("czys");
    QGuiApplication::setOrganizationName("kxtry");
    QGuiApplication::setOrganizationDomain("kxtry.com");
    QGuiApplication::setAttribute(Qt::AA_EnableHighDpiScaling);

    QGuiApplication app(argc, argv);

    int fontId = QFontDatabase::addApplicationFont(":/fonts/iconfont.ttf");
    QStringList fontFamilies = QFontDatabase::applicationFontFamilies(fontId);
    qDebug() << "fontId:" << fontId << ",fontFamily:" << fontFamilies;

    QTranslator translator;
    if(translator.load(":/czys.qm")){
        app.installTranslator(&translator);
    }

    QQuickStyle::setStyle("material");

    qmlRegisterType<KxFileSearch>("KxFileSearch", 1,0, "KxFileSearch");
    qmlRegisterType<KxTagParser>("KxTagParser", 1,0, "KxTagParser");
    qmlRegisterType<KxBluetooth>("KxBluetooth", 1,0, "KxBluetooth");
    qmlRegisterType<KxDesktopServices>("KxDesktopServices", 1,0, "KxDesktopServices");
    qmlRegisterType<QObject>("KxObject", 1, 0, "KxObject");

    QQmlApplicationEngine engine;
    QQmlContext *qmlContext = engine.rootContext();
    qmlContext->setContextProperty("KxUtils", new KxUtils(qmlContext));
    engine.load(QUrl(QStringLiteral("qrc:/main.qml")));
    if (engine.rootObjects().isEmpty()) {
        return -1;
    }
    QQuickWindow *appWindow = qobject_cast<QQuickWindow*>(engine.rootObjects().first());
    qmlContext->setContextProperty("AppWindow", appWindow);
    return app.exec();
}

