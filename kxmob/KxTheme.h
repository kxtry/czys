#ifndef _KXTHEME_H_
#define _KXTHEME_H_

#include<QObject>
#include<QColor>

class KxTheme : public QObject
{
    Q_OBJECT

    Q_PROPERTY(QColor accent WRITE setAccent READ accent NOTIFY accentChanged)
    Q_PROPERTY(QColor background WRITE setBackground READ background)
    Q_PROPERTY(QColor foreground WRITE setForeground READ foreground)
    Q_PROPERTY(QColor primary WRITE setPrimary READ primary)

public:
    explicit KxTheme(QObject *parent = NULL);

    QColor accent() const;
    void setAccent(const QColor& clr);

    QColor background() const;
    void setBackground(const QColor& clr);

    QColor foreground() const;
    void setForeground(const QColor& clr);

    QColor primary() const;
    void setPrimary(const QColor& clr);

Q_SIGNALS:
    void accentChanged();


private:
    QColor m_clrAccent;
    QColor m_clrBackground;
    QColor m_clrForeground;
    QColor m_clrPrimary;
};

#endif
