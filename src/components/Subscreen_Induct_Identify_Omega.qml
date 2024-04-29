import QtQuick 2.0

Item {
    id: subscreenInduct_Identify_Root
    anchors.fill: parent

    property alias assetName: selectedAssetInfo.assetName
    property alias assetDetails: selectedAssetInfo.assetDetails
    property alias assetImagePath: selectedAssetInfo.assetImagePath
    property alias assetInductionDate: selectedAssetInfo.inductionData
    property alias assetsInducted: selectedAssetInfo.assetsInducted

    property int indexOfBuNoSelected: -1

    function resetComboBox(){
        comboSelectBureauNumber.currentIndex = -1
    }

    property alias currentText: comboSelectBureauNumber.currentText
    property bool allowAssetClick: true
    property var listBureauNumbers
    property var listOfBureauNumbers: ListModel{
        ListElement{ key: "Select BuNo"; value: -1}
        ListElement{ key: "168267"; value: 0}
    }

    signal nextClicked()

    CompFlippableRepairAssetItemOmega{
        id: selectedAssetInfo
        anchors{
            left: parent.left
            right: parent.right
            bottom: parent.verticalCenter
            bottomMargin: 40
            leftMargin: 40
            rightMargin: 40
        }
    }

    CompCombobox {
        id: comboSelectBureauNumber

        unselectedText: "Select BuNo"
        textRole: "key"
        model: listOfBureauNumbers

        anchors{
            top:  selectedAssetInfo.bottom
            left: parent.left
            leftMargin: 40
            right: parent.right
            rightMargin: 40
            topMargin: 40
        }

        height: 100
        valueFontSize: 50

        onCurrentIndexChanged: {
            console.log("Current Index Changed to: " + currentIndex)
            indexOfBuNoSelected = currentIndex
        }
        onCurrentValueChanged: {
            console.log("Current Value now: " + currentValue)
        }

        onCurrentTextChanged: {
            console.log("Current text changed to: " + currentText)
        }

    }



}
