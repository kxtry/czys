#ifndef _KXAPPVIEW_H_
#define _KXAPPVIEW_H_

#include<QQuickView>

class KxQuickView : public QQuickView
{
    Q_OBJECT
public:
    explicit KxQuickView(QWindow *parent = NULL);
};

#endif
