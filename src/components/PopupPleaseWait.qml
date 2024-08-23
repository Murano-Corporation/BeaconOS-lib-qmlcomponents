import QtQuick 2.12
import QtQuick.Controls 2.12
import QtMultimedia 5.12
import Qt.labs.platform 1.1

Popup {
    id: popupPleaseWait

    property string pleaseWaitMessage: qsTr("Please Wait")
    property Item contentCenterTarget
    property rect contentCenterPoint
    property alias timeoutTimer: timerTimeout
    property bool timeoutEnabled: true
    width: root.contentItem.width
    height: root.contentItem.height

    anchors {
        centerIn: Overlay.overlay
    }

    background: Rectangle {
        color: "#80000000"
    }

    //Rectangle{
    //    color: "green"
    //    opacity: 0.2
    //    x: contentCenterPoint.x
    //    y: contentCenterPoint.y
    //    height: contentCenterPoint.height
    //    width: contentCenterPoint.width
    //}
    onOpened: {
        if (timeoutEnabled === false)
            return

        timerTimeout.interval = CameraController.imageProcessTimeout
        var timeout = CameraController.imageProcessTimeout
        timerTimeout.start()
    }

    onClosed: {
        timerTimeout.stop()
    }

    Timer {
        id: timerTimeout

        onTriggered: {
            console.error("CAMERA IMAGE PROCESSING TIMEDOUT")
            popupPleaseWait.close()
        }
    }

    Item {
        id: content

        height: (progressImageCapture.y + progressImageCapture.height)

        width: 400

        x: (popupPleaseWait.contentCenterPoint.x
            + (0.5 * popupPleaseWait.contentCenterPoint.width)) - (width * 0.5)
        y: (popupPleaseWait.contentCenterPoint.y
            + (0.5 * popupPleaseWait.contentCenterPoint.height)) - (height * 0.5)
        CompLabel {
            id: lblMessage

            text: popupPleaseWait.pleaseWaitMessage
            anchors {
                top: parent.top
                horizontalCenter: parent.horizontalCenter
            }
        }

        ProgressBar {
            id: progressImageCapture

            indeterminate: true

            anchors {
                top: lblMessage.bottom
                topMargin: 20

                horizontalCenter: lblMessage.horizontalCenter
            }
        }
    }
}
