import QtQuick 2.0
import QtQuick.Controls 2.12
import QtGraphicalEffects 1.12


Item{
    id: compBeaconOsInduct_QuadrantTag

    property alias text: lblQuadrantId2.text

    height: 64
    width: 64

    Rectangle{
        id: rectBg_QuadrantTag

        visible: false

        anchors.fill: parent

        radius: 0.5 * height
    }

    DropShadow{
        anchors.fill: rectBg_QuadrantTag
        source: rectBg_QuadrantTag
        color: "#80000000"

    }

    CompLabel{
        id: lblQuadrantId2

        text: "JD"

        color: "#80000000"

        anchors.fill: parent
        font.pixelSize: height * 0.6
        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter
        font.capitalization: Font.AllUppercase
    }


}
