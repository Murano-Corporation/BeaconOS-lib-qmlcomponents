import QtQuick 2.0

Item {
    id: subscreenInduct_Select_Root

    property string assetNameSelected
    property string assetInductionDateSelected
    property string assetDetailsSelected
    property string assetImagePath

    property int resultsFound: 1
    property string resultsString: resultsFound <= 0 ? "No Results Found" : resultsFound + " Result" + (resultsFound > 1 ? "s" : "")


    anchors.fill: parent

    signal assetSelected()
    function selectAsset(name, inductionDate, details, imgPath)
    {
        subscreenInduct_Select_Root.assetNameSelected = name
        subscreenInduct_Select_Root.assetInductionDateSelected = inductionDate
        subscreenInduct_Select_Root.assetDetailsSelected = details
        subscreenInduct_Select_Root.assetImagePath = imgPath

        subscreenInduct_Select_Root.assetSelected()
    }


    CompCustomisableTextField{
        id: searchField

        anchors{
            top: parent.top
            topMargin: 16
            left: parent.left
            right: parent.right

        }

        placeholderText: "Search by Asset Title or BuNo"
    }

    Item{
        id: groupControls

        height: comboFilterResults.height

        anchors{
            top: searchField.bottom
            topMargin: 40
            left: searchField.left
            leftMargin: 12
            right: searchField.right
            rightMargin: 12
        }

        CompLabel{
            id: lblResultsFound

            text: subscreenInduct_Select_Root.resultsString
            font.pixelSize: 20

            anchors.verticalCenter: parent.verticalCenter
        }

        CompCombobox{
            id: comboFilterResults

            anchors{
                right: parent.right
            }
        }
    }

    CompBeaconOsInductScreen_SelectAssetItem {
        id: compBeaconOsInductScreen_SelectAssetItem

        anchors{
            top: groupControls.bottom
            topMargin: 28
            left: searchField.left
            right: searchField.right
            bottom: parent.bottom
            bottomMargin: 85
        }

        onAssetClicked: {
            subscreenInduct_Select_Root.selectAsset(
                        compBeaconOsInductScreen_SelectAssetItem.assetName,
                        compBeaconOsInductScreen_SelectAssetItem.inductionData,
                        compBeaconOsInductScreen_SelectAssetItem.assetDetails,
                        compBeaconOsInductScreen_SelectAssetItem.assetImagePath)
        }
    }
}

/*##^##
Designer {
    D{i:0;autoSize:true;formeditorColor:"#4c4e50";formeditorZoom:0.33;height:914;width:1800}
}
##^##*/
