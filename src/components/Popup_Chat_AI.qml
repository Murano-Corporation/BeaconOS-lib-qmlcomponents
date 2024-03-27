import QtQuick 2.0
import QtQuick.Controls 2.12

Popup {

    closePolicy: Popup.NoAutoClose
    modal: true

    background: Item{}


    CompConversationalAIChat{
        id: compConversationalAIChat
        //visible: isChatModeActive

        //beaconID: compDrawerInfo.beaconID
        //assetID: compDrawerInfo.assetID

        onVisibleChanged: {
            if(visible === false)
                return

            //console.log("Sending target: " + compDrawerInfo.targetAlertForChat.map_data)
            ChatControllerAI.slot_StartAiConversationWithAlert(compDrawerInfo.targetAlertForChat.map_data)

        }



    }


}
