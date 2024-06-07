import QtQuick 2.12
import QtQuick.Controls 2.12
import CONSTANTS 1.0

CompIconBtn {
    id: btnConnection

    property int connectionState: WifiController.connectionState
    property int connectionType: WifiController.connectionType

    iconUrl: WifiController.iconUrl_Connection

    iconColor: btnIconColor
    iconHeight: btnIconSize
    onClicked: Applications.slot_Request_OpenApp(Constants.ESourceUUID_Popup_WifiSettings, {})

}
