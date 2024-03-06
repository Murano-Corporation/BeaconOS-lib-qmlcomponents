import QtQuick 2.12
import QtQuick.Controls 2.12

Comp__BASE {
    id: compCustomisableTextField
    height: 41
    width: 638


    
    property alias text: txtfldSearch.text
    property alias placeholderText: txtfldSearch.placeholderText
    property alias textColor: txtfldSearch.color
    property alias placeholderTextColor: txtfldSearch.placeholderTextColor
    property alias iconColor: iconSearch.color
    property alias cancelColor: btnClear.iconColor
    
    signal enterPressed()



    Rectangle{
        anchors.fill: parent
        border{
            color: "#4DE9E9E9"
        }
        radius: height * 0.5

        color: "transparent"
    }

    CompImageIcon{
        id: iconSearch
        anchors{
            top: parent.top
            topMargin: 10
            left: parent.left
            leftMargin: 16
            bottom: parent.bottom
            bottomMargin: 10
        }

        width: height

        source: "file:///usr/share/BeaconOS-lib-images/images/SearchInspect.svg"
        color: "#80FFFFFF"
    }

    TextField {
        id: txtfldSearch

        anchors.top: parent.top
        anchors.bottom: parent.bottom
        anchors.left: iconSearch.right
        anchors.leftMargin: 10
        anchors.right: btnClear.left
        anchors.rightMargin: 10

        color: "White"
        placeholderTextColor: iconSearch.color

        width: parent.width - 100
        height: parent.height            

        placeholderText: qsTr("Search...")
        
        verticalAlignment: "AlignVCenter"
        font.pixelSize: 20
        font.family: "Lato"
        font.weight: Font.Normal

        background: Item {}

        onPressAndHold: {
            selectAll()
        }

        onAccepted: {

            if(text.length === 0)
                return


            compCustomisableTextField.enterPressed()
        }

        onActiveFocusChanged: {
            if(!activeFocus)
            {
                return
            }

            selectAll()
        }
    }


    Button {
        id: btnClear
        
        property color iconColor: iconSearch.color
        
        onClicked: {
            txtfldSearch.clear()
        }

        anchors.top: parent.top
        anchors.bottom: parent.bottom
        anchors.right: parent.right
        anchors.rightMargin: 20
        anchors.topMargin: 10
        anchors.bottomMargin: 10

        width: 23

        contentItem: CompImageIcon{
            source: "file:///usr/share/BeaconOS-lib-images/images/CancelFill.svg"
            color: btnClear.iconColor
            height: btnClear.height
            anchors.fill: parent
        }

        background: Item{}
    }




}

/*##^##
Designer {
    D{i:0;formeditorColor:"#4c4e50";formeditorZoom:1.75}
}
##^##*/
