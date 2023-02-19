#ifndef GRIPPER_H
#define GRIPPER_H

#include <QObject>
#include <QModbusDataUnit>
#include <QModbusTcpClient>
#include <QtDebug>
#include <QTimer>

#include "defines.h"

class QModbusClient;
class QModbusReply;

class Gripper : public QObject
{
    Q_OBJECT
public:
    explicit Gripper(QObject *parent = nullptr);
    ~Gripper();

    Q_INVOKABLE void setPosition(int position);
    Q_INVOKABLE void setVelocity(int velocity);
    Q_INVOKABLE void connectDevice();
    Q_INVOKABLE void disconnectDevice();

    Q_PROPERTY(QString title READ title WRITE setTitle NOTIFY titleChanged)
    Q_PROPERTY(QString version READ version WRITE setVersion NOTIFY versionChanged)
    Q_PROPERTY(uint currentPosition READ currentPosition WRITE setCurrentPosition NOTIFY currentPositionChanged)
    Q_PROPERTY(uint currentVelocity READ currentVelocity WRITE setCurrentVelocity NOTIFY currentVelocityChanged)
    Q_PROPERTY(bool isConnected READ isConnected WRITE setIsConnected NOTIFY isConnectedChanged)

    QString title() const;
    QString version() const;
    uint currentPosition() const;
    uint currentVelocity() const;
    bool isConnected() const;

signals:    
    QString recievedData ();
    void titleChanged(QString title);
    void versionChanged(QString vesion);
    void writeSuccess();    
    void currentPositionChanged(uint);
    void currentVelocityChanged(uint);
    void isConnectedChanged(bool);
    void infoMsg(QString errorMsg, bool noError);

private slots:
    void getCurrentPosition();
    void getCurrentVelocity();
    void isDeviceConnected();

public slots:
    void setTitle(QString title);
    void setVersion(QString version);
    void setCurrentPosition(uint currentPosition);
    void setCurrentVelocity(uint currentVelocity);
    void setIsConnected(bool isConnected);

private:
    void read();

    uint m_currentPosition = 0;
    uint m_currentVelocity = 0;

    bool m_isConnected = false;

    QString m_title;
    QString m_version;
    QTimer *m_getInfoTimer = nullptr;
    QModbusReply *m_reply = nullptr;
    QModbusClient *m_modbusClient = nullptr;

};

#endif // GRIPPER_H
