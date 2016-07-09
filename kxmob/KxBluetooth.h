#ifndef _KXBLUETOOTH_H_
#define _KXBLUETOOTH_H_

#include<QObject>
#include<QPointer>

class QBluetoothLocalDevice;
class QBluetoothAddress;

class KxBluetooth : public QObject
{
    Q_OBJECT
public:
    explicit KxBluetooth(QObject *parent = NULL);

Q_SIGNALS:
    void connected(const QString& device);
    void disconnected(const QString& device);

private Q_SLOTS:
    void onDeviceConnected(const QBluetoothAddress &address);
    void onDeviceDisconnected(const QBluetoothAddress &address);
private:
    QPointer<QBluetoothLocalDevice> m_pBluetooth;
};

#endif
