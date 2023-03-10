#include "gripper.h"

Gripper::Gripper(QObject *parent)
    : QObject{parent}
{
    m_modbusClient = new QModbusTcpClient(this);
    m_getInfoTimer = new QTimer(this);
    setTitle(APP_NAME);
    setVersion(APP_VERSION);
    connect(m_getInfoTimer, &QTimer::timeout, this, &Gripper::read);
    connect(m_modbusClient, &QModbusDevice::stateChanged, this, &Gripper::isDeviceConnected);
}

Gripper::~Gripper()
{
    if (m_modbusClient) {
        m_modbusClient->disconnectDevice();
    }
    delete m_modbusClient;
}

void Gripper::read()
{
    quint16 numberOfEntries = 1;

    if (!m_modbusClient)
        return;

    // Getting current position
    if (auto *reply = m_modbusClient->sendReadRequest(QModbusDataUnit(QModbusDataUnit::HoldingRegisters,
                                                                      CURRENT_POSITION_ADDRESS, numberOfEntries), DEVICE_ID)) {
        if (!reply->isFinished())
            connect(reply, &QModbusReply::finished, this, &Gripper::getCurrentPosition);
        else
            delete reply;
    }

    // Getting current velocity
    if (auto *reply = m_modbusClient->sendReadRequest(QModbusDataUnit(QModbusDataUnit::HoldingRegisters,
                                                                      VELOCITY_ADDRESS, numberOfEntries), DEVICE_ID)) {
        if (!reply->isFinished())
            connect(reply, &QModbusReply::finished, this, &Gripper::getCurrentVelocity);
        else
            delete reply;
    }
}

void Gripper::isDeviceConnected()
{
    if (m_modbusClient->state() == QModbusDevice::UnconnectedState) {
        emit infoMsg("No connection. Please check device.", false);
    } else if (m_modbusClient->state() == QModbusDevice::ConnectingState) {
        emit infoMsg("Connecting", true);
    } else if (m_modbusClient->state() == QModbusDevice::ConnectedState) {
        setIsConnected(true);
        emit infoMsg("Connected", true);
    }
}

void Gripper::setTitle(QString title)
{
    if (m_title == title)
        return;

    m_title = title;
    emit titleChanged(m_title);
}

void Gripper::setVersion(QString version)
{
    if (m_version == version)
        return;

    m_version = version;
    emit titleChanged(m_version);
}

void Gripper::setPosition(int position)
{
    if (!m_modbusClient)
        return;

    quint16 numberOfEntries = 1;

    QModbusDataUnit writeUnit = QModbusDataUnit(QModbusDataUnit::HoldingRegisters, POSITION_ADDRESS, numberOfEntries);
    writeUnit.setValue(0, (qint16)position);

    if (auto *reply = m_modbusClient->sendWriteRequest(writeUnit, DEVICE_ID)) {
        if (!reply->isFinished()) {
            connect(reply, &QModbusReply::finished, this, [reply, this]() {
                if (reply->error() == QModbusDevice::ProtocolError) {
                    // ERROR PROTOCOL
                    QString errorString = tr("Write response error: %1 (Mobus exception: 0x%2)")
                            .arg(reply->errorString()).arg(reply->rawResult().exceptionCode(), -1, 16);
                    emit infoMsg(errorString, false);
                } else if (reply->error() != QModbusDevice::NoError) {
                    // ERROR
                    QString errorString = tr("Write response error: %1 (code: 0x%2)").
                            arg(reply->errorString()).arg(reply->error(), -1, 16);
                    emit infoMsg(errorString, false);
                }
                reply->deleteLater();
            });
        } else {
            reply->deleteLater();
        }
    } else {

    }
}

void Gripper::setVelocity(int velocity)
{
    if (!m_modbusClient)
        return;

    quint16 numberOfEntries = 1;

    QModbusDataUnit writeUnit = QModbusDataUnit(QModbusDataUnit::HoldingRegisters, VELOCITY_ADDRESS, numberOfEntries);
    writeUnit.setValue(0, (qint16)velocity);

    if (auto *reply = m_modbusClient->sendWriteRequest(writeUnit, DEVICE_ID)) {
        if (!reply->isFinished()) {
            connect(reply, &QModbusReply::finished, this, [reply, this]() {
                if (reply->error() == QModbusDevice::ProtocolError) {
                    // ERROR PROTOCOL
                    QString errorString = tr("Write response error: %1 (Mobus exception: 0x%2)")
                            .arg(reply->errorString()).arg(reply->rawResult().exceptionCode(), -1, 16);
                    emit infoMsg(errorString, false);
                } else if (reply->error() != QModbusDevice::NoError) {
                    // ERROR
                    QString errorString = tr("Write response error: %1 (code: 0x%2)").
                            arg(reply->errorString()).arg(reply->error(), -1, 16);
                    emit infoMsg(errorString, false);
                }
                reply->deleteLater();
            });
        } else {
            reply->deleteLater();
        }
    } else {

    }
}

void Gripper::connectDevice()
{
    if (!m_modbusClient)
        return;

    if (m_modbusClient->state() != QModbusDevice::ConnectedState) {
        m_getInfoTimer->start(10);

        m_modbusClient->setConnectionParameter(QModbusDevice::NetworkPortParameter, HOST_PORT);
        m_modbusClient->setConnectionParameter(QModbusDevice::NetworkAddressParameter, HOST_ADDRESS);

        m_modbusClient->setTimeout(1000);
        m_modbusClient->setNumberOfRetries(3);

        if (!m_modbusClient->connectDevice()) {
            emit infoMsg("Connection error", false);
        }
    }
}

void Gripper::disconnectDevice()
{
    if (m_modbusClient) {
        m_modbusClient->disconnectDevice();
        m_getInfoTimer->stop();
        setIsConnected(false);
        emit infoMsg("Disconnected", true);
    }
}

QString Gripper::title() const
{
    return m_title;
}

QString Gripper::version() const
{
    return m_version;
}

uint Gripper::currentPosition() const
{
    return m_currentPosition;
}

uint Gripper::currentVelocity() const
{
    return m_currentVelocity;
}

bool Gripper::isConnected() const
{
    return m_isConnected;
}

void Gripper::setCurrentPosition(uint currentPosition)
{
    if (m_currentPosition != currentPosition)
        m_currentPosition = currentPosition;
    emit currentPositionChanged(currentPosition);
}

void Gripper::setCurrentVelocity(uint currentVelocity)
{
    if (m_currentVelocity != currentVelocity)
        m_currentVelocity = currentVelocity;
    emit currentVelocityChanged(m_currentVelocity);
}

void Gripper::setIsConnected(bool isConnected)
{
    if (m_isConnected != isConnected)
        m_isConnected = isConnected;
    emit isConnectedChanged(m_isConnected);
}

void Gripper::getCurrentPosition()
{
    auto reply = qobject_cast<QModbusReply *>(sender());
    if (!reply)
        return;

    QString entry;

    if (reply->error() == QModbusDevice::NoError) {
        const QModbusDataUnit unit = reply->result();
        for (int i = 0, total = int(unit.valueCount()); i < total; ++i) {
            entry = QString::number(unit.value(i), 16);
            setCurrentPosition(unit.value(i));
        }
    } else if (reply->error() == QModbusDevice::ProtocolError) {
        // ERROR PROTOCOL
        entry = tr("Read response error: %1 (Mobus exception: 0x%2)").
                arg(reply->errorString()).
                arg(reply->rawResult().exceptionCode(), -1, 16);
        emit infoMsg(entry, false);
        disconnectDevice();
    } else {
        // ERROR
        entry = tr("Read response error: %1 (code: 0x%2)").
                arg(reply->errorString()).
                arg(reply->error(), -1, 16);
        emit infoMsg(entry, false);
        disconnectDevice();
    }
}

void Gripper::getCurrentVelocity()
{
    auto reply = qobject_cast<QModbusReply *>(sender());
    if (!reply)
        return;

    QString entry;

    if (reply->error() == QModbusDevice::NoError) {
        const QModbusDataUnit unit = reply->result();
        for (int i = 0, total = int(unit.valueCount()); i < total; ++i) {
            entry = QString::number(unit.value(i), 16);
            setCurrentVelocity(unit.value(i));
        }
    } else if (reply->error() == QModbusDevice::ProtocolError) {
        // ERROR PROTOCOL
        entry = tr("Read response error: %1 (Mobus exception: 0x%2)").
                arg(reply->errorString()).
                arg(reply->rawResult().exceptionCode(), -1, 16);
        emit infoMsg(entry, false);
        disconnectDevice();
    } else {
        // ERROR
        entry = tr("Read response error: %1 (code: 0x%2)").
                arg(reply->errorString()).
                arg(reply->error(), -1, 16);
        emit infoMsg(entry, false);
        disconnectDevice();
    }
}
