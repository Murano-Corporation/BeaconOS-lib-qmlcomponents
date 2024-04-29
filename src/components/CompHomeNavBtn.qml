import QtQuick 2.12
import QtQuick.Controls 2.12
import QtGraphicalEffects 1.12

Comp__BASE{
    id: compHomeNavBtn
    
    height: isDelta ? 202 : 200
    width: isDelta ? 156 : 200
    
    property string name: 'Health'
    property string pathName: name
    property string iconPath: "file:///usr/share/BeaconOS-lib-images/images/Health.svg"
    
    signal clicked(string name)
    
    onClicked: name => {
                   SingletonScreenManager.slot_GoToScreen(pathName)
               }
    
    ToolTip{
        visible: btnRoot.hovered && !compHomeNavBtn.enabled
        text: "Currently Disabled"
    }
    
    Column{
        anchors.fill: parent
        spacing: 9
        
        CompIconBtnRound {
            id: btnRoot
            height: isDelta ? 156 : 200

            icon.source: compHomeNavBtn.iconPath
            width: isDelta ? 156 : 200

            onClicked: compHomeNavBtn.clicked(compHomeNavBtn.name)
            anchors.bottomMargin: isDelta ? 0 : 16
        }
        
        Label {
            id: lblName
            text: compHomeNavBtn.name
            font.pixelSize: isDelta ? 24 : 36
            color: "White"
            font.family: "Lato"
            font.weight: Font.Normal
            horizontalAlignment: "AlignHCenter"
            width: parent.width
            wrapMode: "WordWrap"
            opacity: (enabled) ? 1.0 : 0.15
        }
    }

}
