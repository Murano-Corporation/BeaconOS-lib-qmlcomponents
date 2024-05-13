import QtQuick 2.15
import QtQuick.Controls 2.15

Column{
    id: screen_Configuration_View_Nano_Connect

    width: 600


    CompLabel{
        id: lblNanoConnected

        text: "Nano Connected: " + (isNanoConnected ? "TRUE" : "FALSE")
        color: isNanoConnected ? "Green" : "Red"
    }

    CompLabel{
        id: lblNanoPingable

        text: "Nano Pingable: " + (isPingOk ? "TRUE" : "FALSE")
        color: isPingOk ? "Green" : "Red"
    }

    CompLabel{
        id: lblNanoSshAble

        text: "Nano SSH OK?: " + (isSshOk ? "TRUE" : "FALSE")
        color: isSshOk ? "Green" : "Red"
    }

    CompLabel{
        id: lblNanoReady

        text: "Nano Ready?: " + (isNanoReady ? "TRUE" : "FALSE")
        color: isNanoReady ? "Green" : "Red"
    }
}
