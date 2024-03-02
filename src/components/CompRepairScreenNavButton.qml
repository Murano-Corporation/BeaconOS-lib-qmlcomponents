import QtQuick 2.12
import QtQuick.Controls 2.12
import QtGraphicalEffects 1.12

Item{
    id: compRepairScreenNavButton

    property color color1: "#8BBEC4"
    property color color2: "#ffffff"
    property string name: "nameMe"
    property string iconPath: "file:///usr/share/BeaconOS-lib-images/images/HelpFill.svg"

    signal navButtonClicked()

    onNavButtonClicked: {
        "Clicked!"
    }

    CompHealthContextNavBtn{
        id: rectBackground
        text: parent.name
        iconUrl: parent.iconPath

        anchors{
            fill: parent
        }

    }


//    CompImageIcon{
//        id: icon
//        visible: false
//        anchors{
//            fill: parent
//            topMargin: parent.height * 0.025
//            bottomMargin: parent.height * 0.25
//            leftMargin: parent.width * 0.20
//            rightMargin: parent.width * 0.20
//        }

//        source: iconPath

//        color: "white"

//    }

//    ColorOverlay {

//        id: colorOverlay
//        anchors.fill: icon
//        antialiasing: true
//        smooth: true
//        source: icon
//        color: "white"

//    }
//    //

//    CompLabel{
//        id: lblName

//        text: name
//        color: "black"
//        horizontalAlignment: Text.AlignHCenter
//        verticalAlignment: Text.AlignVCenter

//        font.capitalization: Font.AllUppercase

//        anchors{
//            left: parent.left
//            right: parent.right
//            bottom: parent.bottom
//            top: icon.bottom
//        }
//    }

    MouseArea{
        anchors.fill: parent

        onClicked: {
            console.log("clicked")
            parent.navButtonClicked()
        }
    }
}

/*##^##
Designer {
    D{i:0;autoSize:true;height:480;width:640}
}
##^##*/
