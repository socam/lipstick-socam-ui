#ifndef EVENTFILTER_H
#define EVENTFILTER_H


#include <QObject>
#include <QEvent>
#include <QInputContext>



class EventFilter : public QObject
{
protected:
    bool eventFilter(QObject *obj, QEvent *event) {
        QInputContext *ic = qApp->inputContext();
        if (ic) {
            if (ic->focusWidget() == 0 && prevFocusWidget) {
                QEvent closeSIPEvent(QEvent::CloseSoftwareInputPanel);
                ic->filterEvent(&closeSIPEvent);
            } else if (prevFocusWidget == 0 && ic->focusWidget()) {
                QEvent openSIPEvent(QEvent::RequestSoftwareInputPanel);
                ic->filterEvent(&openSIPEvent);
            }
            prevFocusWidget = ic->focusWidget();
        }
        return QObject::eventFilter(obj,event);
    }

private:
    QWidget *prevFocusWidget;

};


#endif // EVENTFILTER_H
