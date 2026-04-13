#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QQmlContext>
#include "systemuicommonapiclient.h"
#include "wifiservicessettings.h"
#include <QFile>
#include <QDir>
#include "systemcontrol.h"
int main(int argc, char *argv[])
{
#if QT_VERSION < QT_VERSION_CHECK(6, 0, 0)
    QCoreApplication::setAttribute(Qt::AA_EnableHighDpiScaling);
#endif
    system("rfkill unblock all");
    system("ifconfig wlan0 up");
    qputenv("QT_IM_MODULE", QByteArray("qtvirtualkeyboard"));
    QGuiApplication app(argc, argv);
    qmlRegisterType<SystemUICommonApiClient>("com.alientek.qmlcomponents", 1, 0, "SystemUICommonApiClient");
    qmlRegisterType<WifiServicesSettings>("com.alientek.qmlcomponents", 1, 0, "WifiServicesSettings");
    qmlRegisterType<SystemControl>("com.alientek.qmlcomponents", 1, 0, "SystemControl");
    QQmlApplicationEngine engine;
    engine.addImportPath(":/CustomStyle");
    qputenv("QT_VIRTUALKEYBOARD_STYLE", "greywhite");
    engine.rootContext()->setContextProperty("appCurrtentDir", QCoreApplication::applicationDirPath());
    const QUrl url(QStringLiteral("qrc:/main.qml"));
    QObject::connect(
        &engine,
        &QQmlApplicationEngine::objectCreated,
        &app,
        [url](QObject *obj, const QUrl &objUrl) {
            if (!obj && url == objUrl)
                QCoreApplication::exit(-1);
        },
        Qt::QueuedConnection);
    engine.load(url);

    return app.exec();
}
