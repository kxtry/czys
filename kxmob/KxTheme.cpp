#include "KxTheme.h"

KxTheme::KxTheme(QObject *parent)
    : QObject(parent)
//    , m_clrAccent("#009688")
//    , m_clrBackground("#4CAF50")
//    , m_clrForeground("#8BC34A")
//    , m_clrPrimary("#4CAF50")
{

}

QColor KxTheme::accent() const
{
    return m_clrAccent;
}

void KxTheme::setAccent(const QColor &clr)
{
    m_clrAccent = clr;
}

QColor KxTheme::background() const
{
    return m_clrBackground;
}

void KxTheme::setBackground(const QColor &clr)
{
    m_clrBackground = clr;
}

QColor KxTheme::foreground() const
{
    return m_clrForeground;
}

void KxTheme::setForeground(const QColor &clr)
{
    m_clrForeground = clr;
}

QColor KxTheme::primary() const
{
    return m_clrPrimary;
}

void KxTheme::setPrimary(const QColor &clr)
{
    m_clrPrimary = clr;
}
