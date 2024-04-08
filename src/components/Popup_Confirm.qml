import QtQuick 2.0

Popup__BASE{
    id: popup_confirm_root

    property alias titleControl: lblTitle
    property alias messageControl: lblMessage
    property alias acceptControl: btnAccept
    property alias declineControl: btnReject
    property bool isResponseSent: false
    popupName: "Confirmation"

    signal accepted()
    signal declined()

    Component.onCompleted: open()

    CompPopupBG{
        id: bg

        width: 600
        height: colContents.height
                + colContents.anchors.bottomMargin
                + colContents.anchors.topMargin

        anchors.centerIn: parent
        anchors.fill: undefined
    }

    Column{
        id: colContents

        anchors{
            left: bg.left
            right: bg.right
            top: bg.top

            margins: bg.radiusBG
        }

        spacing: 20

        CompLabel{
            id: lblTitle
            width: parent.width
            visible:  text !== ""
            wrapMode: Text.WordWrap
        }

        CompLabel{
            id: lblMessage

            visible:  text !== ""
            width: parent.width
            wrapMode: Text.WordWrap

            bottomPadding: 40
        }

        Row{
            id: rowControls

            height: 60
            width: parent.width

            spacing: 30

            layoutDirection: Qt.RightToLeft

            CompBtnBreadcrumb{
                id: btnReject

                visible: text !== ""

                height: parent.height
                width: 0.5 * (parent.width - parent.spacing)

                onClicked: popup_confirm_root.declined()
            }

            CompBtnBreadcrumb{
                id: btnAccept

                visible: text !== ""

                height: parent.height
                width: btnReject.width

                onClicked: popup_confirm_root.accepted()
            }
        }

    }


}
