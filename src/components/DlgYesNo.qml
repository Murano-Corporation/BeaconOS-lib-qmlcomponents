import QtQuick 2.12
import QtQuick.Controls 2.12

Dialog{
    id: dlgYesNo

    property alias headerText: lblHeader.text
    property alias bodyText: lblContents.text
    property var funcOnYes
    property var funcOnNo
    property real btnHeight: 40

    // @disable-check M16
    Overlay.modal: Rectangle{
        anchors.fill: parent

        color: "#F0000000"
    }

    height: 352
    width: 831

    onClosed: {
        funcOnNo = undefined
        funcOnYes = undefined
        headerText = qsTr("SetMe")
        bodyText = ""
    }

    anchors{
        centerIn: Overlay.overlay
    }

    onAccepted: {
        dlgYesNo.funcOnYes()
    }

    onRejected: {
        dlgYesNo.funcOnNo()
    }

    modal: true

    background: CompGlassRect{}

    header: CompLabel{
        id: lblHeader
        leftPadding: 20
        rightPadding: 20
        topPadding: 10

        text: "Header"
        font{
            pixelSize: 30
        }
    }

    contentItem: CompLabel{
        id: lblContents

        leftPadding: 20
        rightPadding: 20
        topPadding: 20
        bottomPadding: 20

        text: "Content"
        wrapMode: "WordWrap"
        font{
            pixelSize: 24
        }

    }

    footer: Row{
        leftPadding: 20
        rightPadding: 20
        bottomPadding: 20

        layoutDirection: Qt.RightToLeft
        spacing: dlgYesNo.btnHeight * 0.5

        CompBtnBreadcrumb{
            text: qsTr("Yes")
            height: dlgYesNo.btnHeight
            width: 200
            onClicked: dlgYesNo.accepted()

            textObject.horizontalAlignment: Text.AlignHCenter
            textObject.anchors.fill: textObject.parent
            textObject.verticalAlignment: Text.AlignVCenter

            iconHeight: 0
            iconWidth: 0

        }

        CompBtnBreadcrumb{
            text: qsTr("No")
            height: dlgYesNo.btnHeight
            width: 200
            onClicked: dlgYesNo.rejected()

            textObject.horizontalAlignment: Text.AlignHCenter
            textObject.anchors.fill: textObject.parent
            textObject.verticalAlignment: Text.AlignVCenter

            iconHeight: 0
            iconWidth: 0

        }

    }

}

/*##^##
Designer {
    D{i:0;formeditorZoom:0.75}
}
##^##*/
