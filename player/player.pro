QT += quick multimedia

# You can make your code fail to compile if it uses deprecated APIs.
# In order to do so, uncomment the following line.
#DEFINES += QT_DISABLE_DEPRECATED_BEFORE=0x060000    # disables all the APIs deprecated before Qt 6.0.0

SOURCES += \
        albumimage.cpp \
        customvideosurface.cpp \
        generatecoverplan.cpp \
        main.cpp \
        medialistmodel.cpp \
        mediaplayer.cpp \
        videooutput.cpp

RESOURCES += qml.qrc \
    player_res.qrc

# Additional import path used to resolve QML modules in Qt Creator's code model
QML_IMPORT_PATH =

# Additional import path used to resolve QML modules just for Qt Quick Designer
QML_DESIGNER_IMPORT_PATH =

# Default rules for deployment.
qnx: target.path = /tmp/$${TARGET}/bin
else: unix:!android: target.path = /userdata/ui/src/apps
!isEmpty(target.path): INSTALLS += target

include(../client/client.pri)
INCLUDEPATH += ../client

HEADERS += \
    albumimage.h \
    customvideosurface.h \
    generatecoverplan.h \
    medialistmodel.h \
    mediaplayer.h \
    videooutput.h
