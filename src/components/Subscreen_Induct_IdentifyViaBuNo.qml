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
    property alias currentText: selectedAssetInfo.currentText
    property var listOfBureauNumbers: ListModel{
        ListElement{ key: "Select BuNo"; value: -1}
        ListElement{ key: "168267"; value: 0}
    }

    signal nextClicked()
    

    CompBeaconOsInductScreen_SelectAssetItem{
        id: selectedAssetInfo

        listBureauNumbers: subscreenInduct_Identify_Root.listOfBureauNumbers
        showBureauCombo: true
        allowAssetClick: false
        indexOfBuNoSelected: -1
        anchors{
            top: parent.top
            topMargin: 16
            left: parent.left
            right: parent.right
            bottom: parent.bottom
            bottomMargin: 40
        }
    }

    CompIconBtn {
        id: btnNext

        visible: (selectedAssetInfo.indexOfBuNoSelected >= 1 ?  true : false)

        anchors{
            right: selectedAssetInfo.right
            rightMargin: 40
            bottom: selectedAssetInfo.bottom
            bottomMargin: 40
        }

        height: 92
        width: height

        iconUrl: "file:///usr/share/BeaconOS-lib-images/images/RightFill.svg"
        iconColor: "#9287ED"
        onClicked: {
            subscreenInduct_Identify_Root.nextClicked()
        }
    }

}

/*##^##
Designer {
    D{i:0;autoSize:true;formeditorColor:"#4c4e50";formeditorZoom:0.5;height:914;width:1800}
}
##^##*/
