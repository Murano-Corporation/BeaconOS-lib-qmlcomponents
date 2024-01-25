import QtQuick 2.12
import QtQuick.Controls 2.12

RoundButton {
    id: btnViewHistory
    //visible: compAssetAlertsPanel.listOfAlerts.length > 0

    text: qsTr("View Alert History")
    radius: (height * 0.5)

    font {
        family: "Lato"
        pixelSize: 10
        weight: Font.Normal
    }

}
