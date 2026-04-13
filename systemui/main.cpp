#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QTextCodec>
#include <QQmlContext>
#include <QFile>
#include "apklistmodel.h"
#include "systemuicommonapiserver.h"
#include "launchintent.h"

int main(int argc, char *argv[])
{
    // Rotate full UI 90° to the left for portrait-mounted development boards (eglfs).
    qputenv("QT_QPA_EGLFS_ROTATION", "270");
#if QT_VERSION < QT_VERSION_CHECK(6, 0, 0)
    QCoreApplication::setAttribute(Qt::AA_EnableHighDpiScaling);
#endif
    QGuiApplication app(argc, argv);
    QTextCodec::setCodecForLocale(QTextCodec::codecForName("UTF-8"));

    QLocale locale(QLocale::Chinese);
    QLocale::setDefault(locale);

    QString hostName;
    QFile file("/etc/hostname");
    if (file.open(QIODevice::ReadOnly | QIODevice::Text)) {
        hostName =  file.readLine().simplified();
        file.close();
    }

    QQmlApplicationEngine engine;
    engine.rootContext()->setContextProperty("appCurrtentDir", QCoreApplication::applicationDirPath());
    engine.rootContext()->setContextProperty("hostName", hostName);
    qmlRegisterType<ApkListModel>("com.alientek.qmlcomponents", 1, 0, "ApkListModel");
    qmlRegisterType<SystemUICommonApiServer>("com.alientek.qmlcomponents", 1, 0, "SystemUICommonApiServer");
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
