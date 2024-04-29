import QtQuick 2.0

Item {
    id: subscreenInduct_Select_Root

    property string assetNameSelected
    property string assetInductionDateSelected
    property string assetDetailsSelected
    property string assetImagePath

    property int resultsFound: 4
    property string resultsString: resultsFound <= 0 ? "No Results Found" : resultsFound + " Result" + (resultsFound > 1 ? "s" : "")


    anchors.fill: parent

    signal assetSelected()
    signal currentIndexChanged(int i)
    function selectAsset(name, inductionDate, details, imgPath)
    {
        subscreenInduct_Select_Root.assetNameSelected = name
        subscreenInduct_Select_Root.assetInductionDateSelected = inductionDate
        subscreenInduct_Select_Root.assetDetailsSelected = details
        subscreenInduct_Select_Root.assetImagePath = imgPath

        //subscreenInduct_Select_Root.assetSelected()
    }


    CompCustomisableTextField{
        id: searchField

        anchors{
            top: parent.top
            topMargin: 20
            left: parent.left
            leftMargin: 12
            rightMargin: 12
            right: parent.right

        }
        height:100

        placeholderText: "Search by Asset Title or BuNo"
    }

    Item{
        id: groupControls

        height: comboFilterResults.height

        anchors{
            top: searchField.bottom
            topMargin: 40
            left: searchField.left
            right: searchField.right

        }

        CompLabel{
            id: lblResultsFound

            text: subscreenInduct_Select_Root.resultsString
            font.pixelSize: 35

            anchors.left: parent.left

        }

        CompCombobox{
            id: comboFilterResults

            anchors{
                right: parent.right
            }
        }
    }

    CompBeaconOsInductScreen_SelectAssetItem_Omega {
        id: compBeaconOsInductScreen_SelectAssetItem

        anchors{
            top: groupControls.bottom
            topMargin: 28
            left: searchField.left
            right: searchField.right
            bottom: parent.bottom
            bottomMargin: 100
        }

        onCurrentIndexChanged: i =>{

           subscreenInduct_Select_Root.selectAsset(
               compBeaconOsInductScreen_SelectAssetItem.assetName,
               compBeaconOsInductScreen_SelectAssetItem.inductionData,
               compBeaconOsInductScreen_SelectAssetItem.assetDetails,
               compBeaconOsInductScreen_SelectAssetItem.assetImagePath)
           subscreenInduct_Select_Root.currentIndexChanged(i)
       }

    }
}

/*##^##
Designer {
    D{i:0;autoSize:true;formeditorColor:"#4c4e50";formeditorZoom:0.33;height:914;width:1800}
}
##^##*/
