import QtQuick 2.12
import QtQuick.Controls 2.12
import QtGraphicalEffects 1.12

Item{
    id: compHomeNavBtn
    
    height: 202
    width: 156
    
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
            height: 156

            icon.source: compHomeNavBtn.iconPath
            width: 156

            onClicked: compHomeNavBtn.clicked(compHomeNavBtn.name)
        }
        
        Label {
            id: lblName
            text: compHomeNavBtn.name
            font.pixelSize: 24
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
