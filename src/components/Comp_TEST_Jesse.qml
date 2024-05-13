import QtQuick 2.15

Comp__BASE {

    property alias textName: lblName.text
    property alias textValue: lblValue.text


    height: 200
    width: 200


    Rectangle {
        id: rectBase

        anchors.fill: parent

        CompLabel{
            id: lblName

            height: 20

            fontPixelSize: 14
            text: "Altitude (m)"
            anchors{
                top: parent.top
                left: parent.left
                right: parent.right

                topMargin: 6

                leftMargin: 6
                rightMargin: 6
            }

            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter

            color: "green"
        }

        CompLabel{
            id: lblValue

            height: 44

            text: "0.00"
            fontPixelSize: 44

            anchors{
                bottom: parent.bottom
                left: parent.left
                right: parent.right

                bottomMargin: 10

                leftMargin: 6
                rightMargin: 6
            }

            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter


            color: "purple"
        }
    }

}
