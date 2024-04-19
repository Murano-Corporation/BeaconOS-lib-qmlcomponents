import QtQuick 2.12
import CONSTANTS 1.0

Item {
    readonly property int targetDevice: TARGET_DEVICE

    property bool isDelta: (targetDevice === Constants.ETargetDevice_Delta)
    property bool isOmega: (targetDevice === Constants.ETargetDevice_Omega)

    // onTargetDeviceChanged: {
        // console.log("Target Device is now: " + targetDevice)
    // }

    // Component.onCompleted: {
        // console.log("Target Device is now: " + targetDevice)
        // console.log("---Is Delta: " + isDelta)
        // console.log("---Is Omega: " + isOmega)
    // }

}

/*##^##
Designer {
    D{i:0;autoSize:true;height:480;width:640}
}
##^##*/
