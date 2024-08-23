import QtQuick 2.15
import QtQuick.Controls 2.12

ScrollView {
    property alias model: droneScrollMenu.model
    property alias delegate: droneScrollMenu.delegate

    property bool estopIsActive: false

    width: 230 + xTranslate.x
    height: 640 //360
    contentWidth: droneScrollMenu.width
    contentHeight: droneScrollMenu.height
    clip: true

    GridView {
        id: droneScrollMenu

        signal openPopup_Parameters()

        transform: Translate {
            id: xTranslate
            x: 20
        }

        width: 220
        height: 990
        cellWidth: 110
        cellHeight: 110
        clip: true

        model: ListModel {
            ListElement { isActive: true; iconPath: "file:///usr/share/BeaconOS-lib-images/images/Refresh.svg"; action: function(){DroneController.sendCommand_FlightController_Restart()}}
            ListElement { isActive: true; iconPath: "file:///usr/share/BeaconOS-lib-images/images/MessageCMD.svg"; action: function(){console.log("Action occured!") }}
            ListElement { isActive: true; iconPath: "file:///usr/share/BeaconOS-lib-images/images/ManualCMD.svg"; action: function(){console.log("Action occured!") }}
            ListElement { isActive: true; iconPath: "file:///usr/share/BeaconOS-lib-images/images/ViewParam.svg"; action: function(){console.log("Action occured!") }}
            ListElement { isActive: true; iconPath: "file:///usr/share/BeaconOS-lib-images/images/HUD.svg"; action: function(){console.log("Action occured!") }}
            ListElement { isActive: true; iconPath: "file:///usr/share/BeaconOS-lib-images/images/MAP.svg"; action: function(){console.log("Action occured!") }}
            ListElement { isActive: true; iconPath: "file:///usr/share/BeaconOS-lib-images/images/DATA.svg"; action: function(){console.log("Action occured!") }}
            ListElement { isActive: true; iconPath: "file:///usr/share/BeaconOS-lib-images/images/ControlEnabled.svg"; action: function(){console.log("Action occured!") }}
            ListElement { isActive: true; iconPath: "file:///usr/share/BeaconOS-lib-images/images/Analytics.svg"; action: function(){console.log("Action occured!") }}
        }

        delegate: CompRaptorNavMenuItem {
            opacity: 0.6
            imgIconSrc: model.iconPath
            imgIconColor: model.isActive() ? "White" : "Red"
            onClicked: model.action()
        }

    }

    ScrollBar.vertical: ScrollBar{
        anchors.top: parent.top
        anchors.bottom: parent.bottom
        anchors.right: parent.right
        anchors.rightMargin: 15
        anchors.leftMargin: 20
        policy: ScrollBar.AlwaysOn
        width: 8
        topPadding: 8
        bottomPadding: 8
    }

}
