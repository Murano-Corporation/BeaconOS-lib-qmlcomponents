import QtQuick 2.0

Comp__BASE {
    id: popup_Settings_View__BASE

    required property string viewName
    property real controlWidth: 600
    property alias contents: areaContents
    property alias contentsBgRadius: areaContents.radiusBG

    width: controlWidth
    height: parent.height

    CompLabel{
        id: lblTitle

        text: popup_Settings_View__BASE.viewName

        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter

        anchors{
            top: parent.top
            left: parent.left
            right: parent.right
        }

        height: 40
        font.pixelSize: isDelta ? 25 : 60

        //Rectangle{
        //    anchors.fill: parent

        //    color: "red"
        //}
    }

    CompPopupBG{
        id: areaContents
        anchors{
            top: lblTitle.bottom
            left: parent.left
            right: parent.right
            bottom: parent.bottom
            topMargin: 20

            fill: undefined
        }


    }

}
