import QtQuick 2.12
import QtGraphicalEffects 1.12

Item {
    id: compAssetHotParam
    
    property string paramName: "Location"
    property string displayName: ''
    property string value1: "#VALUE1#"
    property string value2: ""
    property color color1: "#9287ED"
    property color color2: "#9287ED"
    property string iconPath: ''

    height: 93
    width: 364

    CompGradientRect {
        id: rectBg

        anchors.fill: parent

    }
    
    Item{
        id: iconGroup
        height: 62
        width: 62
        anchors{
            top: parent.top
            topMargin: 15
            left: parent.left
            leftMargin: 18

        }

        CompGradientRect {
            anchors.fill: parent
            opacity: 1.0
            radius: 18
            color1: compAssetHotParam.color1
            color2: compAssetHotParam.color2
        }

        CompImageIcon {
            id: imgIcon
            anchors.centerIn: iconGroup
            height: 32
            width: 32
            color: "White"
            source: compAssetHotParam.iconPath

        }
    }

    CompLabel{
        id: lblName
        text: compAssetHotParam.displayName
        
        anchors{
            top: lblValue.bottom
            topMargin: 2
            left: lblValue.left
        }
        
        color: "#9287ED"

        font{
            pixelSize: 14
            capitalization: Font.AllUppercase
        }
    }
    
    CompLabel{
        id: lblValue
        
        anchors{
            top: parent.top
            topMargin: 20
            left: iconGroup.right
            leftMargin: 16
            
        }
        
        font{
            pixelSize: 25
            weight: Font.Normal
        }
        
        text: compAssetHotParam.value1
    }
    
    CompLabel{
        id: lblValue2
        
        anchors{
            bottom: lblValue.bottom

            left: lblValue.right
            leftMargin: 6
        }
        
        font{
            pixelSize: 12
            weight: Font.Normal
        }
        
        text: compAssetHotParam.value2
    }
    
    
}
