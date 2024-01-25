import QtQuick 2.12
import QtQuick.Controls 2.12
import QtQuick.Window 2.12

Item{
    id: popupRoot

    property alias textTitle: popupMsgBoxInfoRoot.textTitle
    property alias textMessage: popupMsgBoxInfoRoot.textMessage

    height: popupMsgBoxInfoRoot.height
    width: popupMsgBoxInfoRoot.width

    Popup{
        id: popupMsgBoxInfoRoot

        anchors.centerIn: parent
        height: msgBoxInfoRoot.implicitHeight
        width: msgBoxInfoRoot.implicitWidth
        modal: true
        closePolicy: Popup.CloseOnEscape

        property string textTitle: 'Title'
        property string textMessage: 'Message'

        Rectangle {
            id: msgBoxInfoRoot
            anchors.centerIn: parent
            width: 400
            height: column.implicitHeight
            color: "#ededed"
            radius: 8
            layer.enabled: false



            Column {
                id: column
                anchors.fill: parent
                spacing: 10
                rightPadding: 20
                leftPadding: 20
                bottomPadding: 10
                topPadding: 10


                Label {
                    id: lblTitle

                    text: textTitle
                    horizontalAlignment: Text.AlignLeft
                    font.styleName: "Light"
                    font.family: "Lato"
                }

                Rectangle {
                    id: line
                    width: parent.width - (parent.leftPadding + parent.rightPadding)
                    height: 2

                    color: "#d0000000"
                    anchors.horizontalCenter: parent.horizontalCenter
                }

                TextArea {
                    id: textAreaMessage
                    width: parent.width - (parent.leftPadding + parent.rightPadding)
                    text: textMessage
                    wrapMode: Text.WordWrap
                    font.styleName: "Regular"
                    font.family: "Lato"
                    readOnly: true



                }

                Button {
                    id: btnOk

                    text: 'OK'

                    onClicked: popupMsgBoxInfoRoot.close()
                }

            }
        }

    }


}
