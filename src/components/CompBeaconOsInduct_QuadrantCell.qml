import QtQuick 2.0
import QtQuick.Controls 2.12
import QtGraphicalEffects 1.12


Item{
    id: compBeaconOsInduct_QuadrantCell

    property alias quadrantId: lblQuadrantId.text
    property alias quadrantTag: compBeaconOsInduct_QuadrantTag.text
    property alias percentcomplete: compProgressBar_Circle.percentComplete
    property real cornerRadius: 42
    property bool infoAlignedLeft: true
    property bool infoAlignedTop: true
    property color colorIdle : "#8000ffff"



    signal clicked()
    signal entered()
    signal exited()

    height: 0.5 * parent.height
    width: 0.5 * parent.width

    CompRectangleMultiRadii {
        id: compRectangleMultiRadii

        color: compBeaconOsInduct_QuadrantCell.colorIdle

        anchors.fill: parent

        tlRadius: ((compBeaconOsInduct_QuadrantCell.infoAlignedLeft && compBeaconOsInduct_QuadrantCell.infoAlignedTop) ? compBeaconOsInduct_QuadrantCell.cornerRadius : 0)
        trRadius: ((!compBeaconOsInduct_QuadrantCell.infoAlignedLeft && compBeaconOsInduct_QuadrantCell.infoAlignedTop) ? compBeaconOsInduct_QuadrantCell.cornerRadius : 0)
        brRadius: ((!compBeaconOsInduct_QuadrantCell.infoAlignedLeft && !compBeaconOsInduct_QuadrantCell.infoAlignedTop) ? compBeaconOsInduct_QuadrantCell.cornerRadius : 0)
        blRadius: ((compBeaconOsInduct_QuadrantCell.infoAlignedLeft && !compBeaconOsInduct_QuadrantCell.infoAlignedTop) ? compBeaconOsInduct_QuadrantCell.cornerRadius : 0)
    }

    Row{

        spacing: 16
        height: 64
        anchors.top: compBeaconOsInduct_QuadrantCell.infoAlignedTop ? parent.top : undefined
        anchors.margins: 35
        anchors.left: compBeaconOsInduct_QuadrantCell.infoAlignedLeft ? parent.left : undefined
        anchors.right: compBeaconOsInduct_QuadrantCell.infoAlignedLeft ? undefined : parent.right
        anchors.bottom: compBeaconOsInduct_QuadrantCell.infoAlignedTop ? undefined : parent.bottom

        layoutDirection: compBeaconOsInduct_QuadrantCell.infoAlignedLeft ? Qt.LeftToRight : Qt.RightToLeft

        CompLabel{
            id: lblQuadrantId

            text: "Q1"

            color: "white"

            anchors.verticalCenter: parent.verticalCenter
        }

        CompBeaconOsInduct_QuadrantTag {
            id: compBeaconOsInduct_QuadrantTag

            anchors.verticalCenter: parent.verticalCenter
        }


        CompProgressBar_Circle {
            id: compProgressBar_Circle

            anchors.verticalCenter: parent.verticalCenter
        }
    }



    MouseArea{
        anchors.fill: parent

        onEntered: compBeaconOsInduct_QuadrantCell.entered()
        onExited: compBeaconOsInduct_QuadrantCell.exited()
        onClicked: compBeaconOsInduct_QuadrantCell.clicked()
    }

}
