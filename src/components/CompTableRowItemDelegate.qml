import QtQuick 2.15


Item{
    id: compTableRowItemDelegateRoot

    property string paramName: "%PARAM NAME%"


    property string value: "%VALUE%"
    property string valueUnits: ""
    property string min: "%MIN%"
    property string max: "%MAX%"

    property real paramNameLabelWidth: 400
    property real valueLabelWidth: 200
    property real unitLabelWidth: 100
    property real minLabelWidth: 200
    property real maxLabelWidth: 200

    property real fontPixelSize: 20
    property real labelHorizontalMargin: 12

    property color borderColor: "#4D4A5F"
    property real borderThickness: 2

    width: (paramNameLabelWidth + valueLabelWidth + minLabelWidth + maxLabelWidth + unitLabelWidth)
    height: 53

    Component.onCompleted: {
        AssetInfo.signal_EnvImuParamDataChanged.connect( onParamDataChanged );
    }

    function onParamDataChanged( pName, pData){

        if((!compTableRowItemDelegateRoot) ||  (pName !== compTableRowItemDelegateRoot.paramName) )
            return

        //console.log("FRONTEND:: TABLE ROW DELEGATE:: Data CHANGED:: " + pName + " vs " + paramName);

        //console.log("FRONTEND:: Param updated: " + paramName + "..." )
        //console.log(pData);

        compTableRowItemDelegateRoot.value = pData.scaled_val
        compTableRowItemDelegateRoot.min = pData.min
        compTableRowItemDelegateRoot.max = pData.max
        compTableRowItemDelegateRoot.valueUnits = pData.unit

    }

    Rectangle{
        id: rectBg

        anchors{
            fill: parent
        }

        color: "#1E273A"
    }

    Rectangle{
        id: rectBorderBottom

        anchors{
            left: parent.left
            right: parent.right
            bottom: parent.bottom
        }

        height: parent.borderThickness

        color: parent.borderColor
    }

    Rectangle{
        id: rectBorderLeft

        anchors{
            left: parent.left
            top: parent.top
            bottom: lblParamName.bottom
        }

        width: parent.borderThickness

        color: parent.borderColor
    }

    CompLabel {
        id: lblParamName

        anchors{
            left: parent.left
            leftMargin: parent.labelHorizontalMargin
            top: parent.top
            bottom: rectBorderBottom.top

        }

        width: parent.paramNameLabelWidth - (parent.labelHorizontalMargin * 2)

        text: parent.paramName

        font{
            pixelSize: parent.fontPixelSize
        }
        verticalAlignment: "AlignVCenter"
    }

    Rectangle{
        anchors{
            horizontalCenter: lblParamName.right
            horizontalCenterOffset: parent.labelHorizontalMargin
            top: lblParamName.top
            bottom: lblParamName.bottom
        }

        width: parent.borderThickness

        color: parent.borderColor
    }

    CompLabel{
        id: lblValue

        anchors{
            top: parent.top
            bottom: parent.bottom
            rightMargin: 10
            left: lblParamName.right
            leftMargin: parent.labelHorizontalMargin * 2
        }

        width: compTableRowItemDelegateRoot.valueLabelWidth - (parent.labelHorizontalMargin * 2)

        text: compTableRowItemDelegateRoot.value
        font{
            pixelSize: compTableRowItemDelegateRoot.fontPixelSize
        }
        verticalAlignment: "AlignVCenter"
        horizontalAlignment: "AlignRight"

        elide: Text.ElideLeft
    }

    Rectangle{
        anchors{
            horizontalCenter: lblValue.right
            horizontalCenterOffset: parent.labelHorizontalMargin
            top: lblParamName.top
            bottom: lblParamName.bottom
        }

        width: parent.borderThickness

        color: parent.borderColor
    }

    CompLabel{
        id: lblUnit

        anchors{
            left: lblValue.right
            leftMargin: parent.labelHorizontalMargin * 2
            top: parent.top
            bottom: parent.bottom
        }

        width: compTableRowItemDelegateRoot.unitLabelWidth - (parent.labelHorizontalMargin * 2)

        text: compTableRowItemDelegateRoot.valueUnits
        font{
            pixelSize: compTableRowItemDelegateRoot.fontPixelSize
        }
        verticalAlignment: "AlignVCenter"
        horizontalAlignment: "AlignLeft"

    }

    Rectangle{
        anchors{
            horizontalCenter: lblUnit.right
            horizontalCenterOffset: parent.labelHorizontalMargin
            top: lblParamName.top
            bottom: lblParamName.bottom
        }

        width: parent.borderThickness

        color: parent.borderColor
    }

    CompLabel {
        id: lblMin

        anchors{
            left: lblUnit.right
            leftMargin: parent.labelHorizontalMargin * 2
            top: parent.top
            bottom: parent.bottom

        }

        width: compTableRowItemDelegateRoot.minLabelWidth - (parent.labelHorizontalMargin * 2)

        text: parent.min
        font{
            pixelSize: parent.fontPixelSize
        }
        verticalAlignment: "AlignVCenter"
        horizontalAlignment: "AlignHCenter"
    }

    Rectangle{
        anchors{
            horizontalCenter: lblMin.right
            horizontalCenterOffset: parent.labelHorizontalMargin
            top: lblParamName.top
            bottom: lblParamName.bottom
        }

        width: parent.borderThickness

        color: parent.borderColor
    }

    CompLabel {
        id: lblMax

        anchors{
            left: lblMin.right
            leftMargin: parent.labelHorizontalMargin * 2
            top: parent.top
            bottom: parent.bottom

        }

        width: parent.maxLabelWidth - (parent.labelHorizontalMargin * 2)

        text: parent.max
        font{
            pixelSize: parent.fontPixelSize
        }
        verticalAlignment: "AlignVCenter"
        horizontalAlignment: "AlignHCenter"
    }

    Rectangle{
        anchors{
            top: lblParamName.top
            bottom: lblParamName.bottom
            right: parent.right
        }

        width: parent.borderThickness

        color: parent.borderColor
    }


}
