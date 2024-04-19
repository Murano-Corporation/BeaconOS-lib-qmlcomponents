import QtQuick 2.0

Comp__BASE {
    id: popup_Settings__BASE_Root
    property string screenName: "NameMe"
    property real controlWidth
    property Component content: Rectangle{
        color: "green"

    }


    Column{
        id: colContents

        spacing: 20

        anchors{
            fill: parent
        }

        CompLabel{
            id: lblTitle

            text: popup_Settings__BASE_Root.screenName

            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignBottom

            height: 40
            width: parent.width
        }



        Item{
            id: bg
            width: parent.width
            height: parent.height - parent.spacing - lblTitle.height

            Loader{
                id: loader_contents

                anchors.fill: parent
                anchors.margins: 20

                active: true

                sourceComponent: popup_Settings__BASE_Root.content
            }

        }

    }


}
