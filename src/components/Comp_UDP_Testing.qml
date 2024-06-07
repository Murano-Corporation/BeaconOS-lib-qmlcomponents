import QtQuick 2.15
import QtQuick.Controls 2.15

Item {

    Column{
        anchors.fill: parent

        Row {
            id: row_Headers

            width: parent.width
            height: 60

            spacing: 20

            CompLabel{
                id: lblMessage

                text: "Message"

            }

            CompLabel{
                id: lblTarget

                text: "Target"

            }

            CompLabel{
                id: lblPort

                text: "Port"

            }
        }

        Row {
            id: row_Inputs

            spacing: 20
            width: parent.width
            TextEdit{
                id: edtMessage

                width: lblMessage.width
            }

            TextEdit{
                id: edtTarget

                width: lblTarget.width
            }

            TextEdit{
                id: edtPort

                width: lblPort.width
            }
        }

        RoundButton{
            id: btnSend

            text: "SEND"
            width: 100
        }



    }

}
