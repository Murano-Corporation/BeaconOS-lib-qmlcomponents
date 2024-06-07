import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQml.Models 2.15

Popup_Settings_View__BASE {
    id: popup_Settings_Wifi_Root

    viewName: "Networking Settings"

    //controlWidth: isDelta ? searchField.width : parent.width * 0.8
    property int controlWidth: 400

    Item {
        id: areaContent_Root

        anchors {
            fill: contents
            margins: contentsBgRadius
        }

        ListView {
            id: listActiveConnections

            model: WifiController.listActiveConnections

            anchors.fill: parent
            clip: true
            boundsBehavior: Flickable.StopAtBounds

            delegate: Item{

            height: 64
            width: listActiveConnections.width

                Row {

                    anchors.fill: parent

                    spacing: 20

                    CompLabel{
                        text: modelData.name
                    }

                    CompLabel{
                        text: modelData.uuid
                    }

                    CompLabel{
                        text: modelData.type
                    }

                    CompLabel{
                        text: modelData.device
                    }

                    CompLabel{
                        text: modelData.state
                    }

                    CompLabel{
                        text: modelData.state_ext
                    }
                }

            }
        }


    }


}
