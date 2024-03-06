import QtQuick 2.12
import QtQuick.Controls 2.12
import Qt.labs.qmlmodels 1.0

CompIconBtn{
    id: btnClose


    anchors{
    }

    iconUrl: "file:///usr/share/BeaconOS-lib-images/images/CancelFill.svg"
    iconColor: "red"

    mousearea{
        anchors.margins: -40
    }
}

/*##^##
Designer {
    D{i:0;autoSize:true;height:480;width:640}
}
##^##*/
