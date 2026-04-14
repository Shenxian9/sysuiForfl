#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QQmlContext>
#include <QProcess>
#include <QTimer>
#include "systemuicommonapiclient.h"

int main(int argc, char *argv[])
{
#if QT_VERSION < QT_VERSION_CHECK(6, 0, 0)
    QCoreApplication::setAttribute(Qt::AA_EnableHighDpiScaling);
#endif
    QGuiApplication app(argc, argv);
    qmlRegisterType<SystemUICommonApiClient>("com.alientek.qmlcomponents", 1, 0, "SystemUICommonApiClient");
    QQmlApplicationEngine engine;
    engine.rootContext()->setContextProperty("appCurrtentDir", QCoreApplication::applicationDirPath());
    const QString configStudioPath = QStringLiteral("/userdata/ConfigStudio");
    const bool launched = QProcess::startDetached(configStudioPath);
    if (launched) {
        QTimer::singleShot(0, &app, &QCoreApplication::quit);
    }

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
