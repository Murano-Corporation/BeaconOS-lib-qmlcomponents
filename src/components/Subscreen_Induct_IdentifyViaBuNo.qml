import QtQuick 2.0

Item {
    id: subscreenInduct_Identify_Root
    anchors.fill: parent

    property alias assetName: selectedAssetInfo.assetName
    property alias assetDetails: selectedAssetInfo.assetDetails
    property alias assetImagePath: selectedAssetInfo.assetImagePath
    property alias assetInductionDate: selectedAssetInfo.inductionData
    property alias assetsInducted: selectedAssetInfo.assetsInducted

    property alias indexOfBuNoSelected: selectedAssetInfo.indexOfBuNoSelected

    signal nextClicked()
    
    CompLabel{
        id: lblTitle

        text: "Identify Aircraft via Bureau Number"

        font.pixelSize: 38
    }

    CompBeaconOsInductScreen_SelectAssetItem{
        id: selectedAssetInfo

        showBureauCombo: true
        indexOfBuNoSelected: -1
        anchors{
            top: lblTitle.bottom
            topMargin: 32
            left: parent.left
            right: parent.right
            bottom: parent.bottom
            bottomMargin: 40
        }
    }

    CompIconBtn {
        id: btnNext

        visible: (selectedAssetInfo.indexOfBuNoSelected === -1 ?  false : true)

        anchors{
            right: selectedAssetInfo.right
            rightMargin: 40
            bottom: selectedAssetInfo.bottom
            bottomMargin: 40
        }

        height: 92
        width: height

        iconUrl: "file:///usr/share/BeaconOS-lib-images/images/RightFill.svg"
    }

}

/*##^##
Designer {
    D{i:0;autoSize:true;formeditorColor:"#4c4e50";formeditorZoom:0.5;height:914;width:1800}
}
##^##*/
