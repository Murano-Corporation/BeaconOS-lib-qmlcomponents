import QtQuick 2.15
import QtQuick.Controls 2.12

Drawer {
    id: drawerRaptorDeviceInfoControl

    height: 780
    width: 415
    dim: false
    modal: false
    leftPadding: 10

    signal signalBeaconIDChanged(var beaconID)
    signal signalSelectedItemChanged(var model)

    background: CompGlassRect {
        id: rectExpandedBg
        anchors.fill: parent
    }

    Comp_Device_Info {
        id: deviceInfo

        anchors.fill: parent
        anchors.topMargin: 20

        listofDevices: TableModelRaptorMap
        onSignalSelectedItemChanged: model => {
                                         drawerRaptorDeviceInfoControl.signalSelectedItemChanged(
                                             model)
                                     }
        onSignalBeaconIDChanged: bid => {
                                     drawerRaptorDeviceInfoControl.signalBeaconIDChanged(
                                         bid)
                                 }
    }
}
