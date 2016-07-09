#ifndef _KXTAGPARSER_H_
#define _KXTAGPARSER_H_

#include<QObject>
#include<QVariant>

class KxTagParser : public QObject
{
    Q_OBJECT
public:
    explicit KxTagParser(QObject *parent = NULL);

    Q_INVOKABLE QVariant get(const QString& file) const;

private:
    bool isSupportFormat(const QString& file) const;
};

#endif
