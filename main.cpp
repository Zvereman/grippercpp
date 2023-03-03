#include <QApplication>
#include <QQmlApplicationEngine>
#include <QQuickView>
#include <QQmlEngine>
#include <QQmlContext>
#include <Qt3DQuickExtras/Qt3DQuickWindow>
#include <QQuickStyle>

#include "gripper.h"
#include "defines.h"

int main(int argc, char *argv[])
{
#if QT_VERSION > QT_VERSION_CHECK(6, 0, 0)
    QCoreApplication::setAttribute(Qt::AA_EnableHighDpiScaling);
#endif
    QApplication app(argc, argv);

    qmlRegisterType<Gripper>("gripper", 1, 0, "Gripper");

    QQmlApplicationEngine engine;
    const QUrl url(QStringLiteral("qrc:/mainQt5.qml"));
    QObject::connect(&engine, &QQmlApplicationEngine::objectCreated,
                     &app, [url](QObject *obj, const QUrl &objUrl) {
        if (!obj && url == objUrl)
            QCoreApplication::exit(-1);
    }, Qt::QueuedConnection);
    engine.load(url);

    return app.exec();

//    // Right now solving issue with correct displaying of charts in Qt6
//    // using OpenGL or another tool. Right now chart is having some display glitches.
//    QApplication app(argc, argv);

//    QQuickView view;

//    qmlRegisterType<Gripper>("gripper", 1, 0, "Gripper");

//    view.resize(1024, 768);
//    view.setTitle(QString("%1 %2").arg(APP_NAME, APP_VERSION));
//    view.setResizeMode(QQuickView::SizeRootObjectToView);
//    view.setSource(QUrl("qrc:/mainQt6.qml"));
//    view.show();

//    return app.exec();
}
