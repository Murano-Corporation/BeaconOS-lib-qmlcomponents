import QtQuick 2.12
import QtQuick.Controls 2.12

Item {
    id: compNotificationsPanel

    property alias listHeight: listAlerts.height
    property int pixelsizeBreadcrumbBtns: 35

    height: 413
    width: 589

    property var listOfNotifications: TableModelAlerts

    Column{
        id: colContents
        anchors.fill: parent
        spacing: 30
        
        Label{
            id: lblTitle
            text: listAlerts.visible ? qsTr("Notifications") : qsTr("No Notifications")
            color: "White"
            font.pixelSize: 34
            font.family: "Lato"
            font.weight: Font.Normal
        }
        
        ListView{
            id: listAlerts
            visible: count > 0

            height: 336
            width: parent.width
            clip: true

            spacing: 32
            
            model: compNotificationsPanel.listOfNotifications

            delegate: CompExpandableBtnBreadcrumb{

                width: parent.width
                labelMain.font.pixelSize: compNotificationsPanel.pixelsizeBreadcrumbBtns
                //appSourceName: myModelData ? myModelData.appSource : '?'
                titleText: model ? model.title : '?'
                titleIconSource: ''
                contents: model.Parameters.data
                listQuickActions: model.Parameters.responses

                onChatWithAiClicked: {
                    compAssetAlertsPanel.chatWithAiClicked(model)
                }
            }
        }

        
    }
}
