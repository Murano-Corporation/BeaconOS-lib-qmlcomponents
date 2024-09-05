import QtQuick 2.15
import QtQuick.Controls 2.12
import Murano.Beacon.Raptor.DeviceControllers 1.0

CompResizableMoveableContainer {
    id: contentsRoot

    required property RaptorDroneController controller
    property point startPoint: Qt.point(0, 0)
    property size startSize: {
        width: 400
        height: 600
    }
    readonly property bool isOpen: visible

    visible: false
    showDevLabels: true
    minimumHeight: 90
    minimumWidth: 400

    function toggleOpen() {
        if (isOpen)
            close()
        else
            open()
    }

    function open() {
        contentsRoot.visible = true
    }

    function close() {
        contentsRoot.visible = false
    }

    Component.onCompleted: {

        if (startSize.width <= minimumWidth)
            startSize.width = minimumWidth

        if (startSize.height <= minimumHeight)
            startSize.height = minimumHeight

        console.log("Setting start size to: " + startSize)
        console.log("Setting start origin to: " + startPoint)

        contentsRoot.x = startPoint.x
        contentsRoot.y = startPoint.y
        contentsRoot.width = startSize.width
        contentsRoot.height = startSize.height
    }

    CompPopupBG {
        id: bg
        anchors.fill: parent

        CompLabel {
            id: lblPrearmChecks

            anchors {
                top: parent.top
                left: parent.left
                right: parent.right
                margins: 20
            }

            text: "Messages"
        }

        ListView {
            id: listPrearmChecks

            property int lblWidth_Severity: 64
            property int lblWidth_Text: width - lblWidth_Severity - lblSpacing
            property int lblSpacing: 40
            property int itemHeight: 64
            property int itemWidth: lblWidth_Severity + lblSpacing + lblWidth_Text

            spacing: 20

            boundsBehavior: Flickable.StopAtBounds
            clip: true
            model: controller.pDataModel_Messages

            onCountChanged: {
                listPrearmChecks.currentIndex = (listPrearmChecks.count - 1)
            }

            anchors {
                top: lblPrearmChecks.bottom
                left: lblPrearmChecks.left
                right: lblPrearmChecks.right
                bottom: parent.bottom
                bottomMargin: 20
            }

            delegate: Item {
                id: compRaptorControlMessageDelegate

                property int severity: model.severity
                property string text: model.text

                opacity: index === listPrearmChecks.currentIndex ? 1.0 : 0.3
                height: Math.max(listPrearmChecks.itemHeight, lblText.height)
                width: listPrearmChecks.itemWidth

                CompLabel {
                    id: lblSeverity

                    width: listPrearmChecks.lblWidth_Severity
                    text: parent.severity
                    verticalAlignment: Text.AlignTop
                    anchors {
                        top: parent.top
                        left: parent.left
                        bottom: parent.bottom
                    }
                }

                CompLabel {
                    id: lblText

                    width: listPrearmChecks.lblWidth_Text
                    text: parent.text
                    verticalAlignment: Text.AlignTop
                    wrapMode: Text.WordWrap
                    anchors {
                        top: parent.top
                        left: lblSeverity.right
                        leftMargin: listPrearmChecks.lblSpacing
                        bottom: parent.bottom
                    }
                }
            }
        }
    }
}
