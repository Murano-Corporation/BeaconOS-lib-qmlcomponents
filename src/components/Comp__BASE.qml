import QtQuick 2.12
import CONSTANTS 1.0

Item {
    readonly property int targetDevice: TARGET_DEVICE
    readonly property string imageLocation: "file:////usr/share/BeaconOS-lib-images/images/"

    property bool isDelta: (targetDevice === Constants.ETargetDevice_Delta)
    property bool isOmega: (targetDevice === Constants.ETargetDevice_Omega)
    property bool isPopupComponent: false
}

/*##^##
Designer {
    D{i:0;autoSize:true;height:480;width:640}
}
##^##*/

