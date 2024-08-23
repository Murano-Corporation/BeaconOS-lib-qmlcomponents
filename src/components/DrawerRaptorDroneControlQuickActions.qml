import QtQuick 2.15
import QtQuick.Controls 2.12

Drawer{
    id: drawerRaptorDroneControlQuickActions

    property alias model: compRaptorDroneGridView.model
    property alias delegate: compRaptorDroneGridView.delegate

    closePolicy: Popup.NoAutoClose
    dim: false
    modal: false
    width: 220
    height: 578
    rightPadding: 10
    leftPadding: 10
    background: CompGlassRect{

        anchors.fill: parent
    }

    CompRaptorDroneGridView{
        id: compRaptorDroneGridView

        transform: Scale {
            xScale: 0.8
            yScale: 0.8
        }

        anchors{
            top: parent.top
            topMargin: 20
            right: parent.right
            rightMargin: -58
        }


    }
}
