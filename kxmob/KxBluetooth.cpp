#include "KxBluetooth.h"
#include <QDebug>
#include <QBluetoothLocalDevice>

KxBluetooth::KxBluetooth(QObject *parent)
    : QObject(parent)
{
    m_pBluetooth = new QBluetoothLocalDevice(this);
    QObject::connect(m_pBluetooth, SIGNAL(deviceConnected(QBluetoothAddress)), this, SLOT(onDeviceConnected(QBluetoothAddress)));
    QObject::connect(m_pBluetooth, SIGNAL(deviceDisconnected(QBluetoothAddress)), this, SLOT(onDeviceDisconnected(QBluetoothAddress)));
}

void KxBluetooth::onDeviceConnected(const QBluetoothAddress &address)
{
    emit connected(address.toString());
}

void KxBluetooth::onDeviceDisconnected(const QBluetoothAddress &address)
{
    emit disconnected(address.toString());
}
