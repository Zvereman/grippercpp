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
#if QT_VERSION < QT_VERSION_CHECK(6, 0, 0)
    QCoreApplication::setAttribute(Qt::AA_EnableHighDpiScaling);
#endif
    QApplication app(argc, argv);

    QQuickStyle::setStyle("Imagine");

    QQuickView view;

    qmlRegisterType<Gripper>("gripper", 1, 0, "Gripper");

    view.resize(1024, 768);
    view.setTitle(QString("%1 %2").arg(APP_NAME).arg(APP_VERSION));
    view.setResizeMode(QQuickView::SizeRootObjectToView);
    view.setSource(QUrl("qrc:/main.qml"));
    view.show();

    return app.exec();

}
