import QtQuick 2.0

Item{
    id: compBeaconOsInductScreen_SelectAssetItem

    property string assetName: "[ASSET NAME]"
    property string inductionData: "[Induction Date]"
    property string assetDetails: "[ASSET DETAILS]"
    property string assetsInducted: "[# of assets inducted on depot floor]"
    property string assetImagePath: "file:///usr/share/BeaconOS-lib-images/images/HelpFill.svg"
    property bool showBureauCombo: false
    property bool allowAssetClick: true

    property var listBureauNumbers: [{"number": "BuNo-01"}, {"number": "BuNo-02"}]

    property int indexOfBuNoSelected: -1

    signal assetClicked()

    Rectangle{
        id: background

        radius: 45

        anchors{
            fill: parent
        }

    }

    CompImageIcon{
        id: assetImage

        anchors{
            top: parent.top
            left: parent.left
            bottom: parent.bottom
        }

        source: compBeaconOsInductScreen_SelectAssetItem.assetImagePath

        width: height
    }

    Item{
        id: groupAssetInfo

        anchors{
            top: parent.top
            topMargin: 40
            left: assetImage.right
            bottom: parent.bottom
            bottomMargin: 40
            right: parent.right
            rightMargin: 40
        }

        CompCombobox{
            id: comboSelectBureauNumber

            displayText: "Select BuNo"

            visible: compBeaconOsInductScreen_SelectAssetItem.showBureauCombo
            model: compBeaconOsInductScreen_SelectAssetItem.listBureauNumbers

            anchors{
                top:  lblAssetName.top
                right: parent.right
                bottom: lblAssetName.bottom

            }

            width: 400

            onCurrentIndexChanged: compBeaconOsInductScreen_SelectAssetItem.indexOfBuNoSelected = currentIndex
        }

        CompLabel{
            id: lblAssetName

            text: compBeaconOsInductScreen_SelectAssetItem.assetName
            color: "black"
            font.pixelSize: 48
            anchors{
                left: parent.left
                top: parent.top
                right: parent.right
            }

        }

        CompLabel{
            id: lblInductionDate

            text: compBeaconOsInductScreen_SelectAssetItem.inductionData
            color: "black"
            font.pixelSize: 26
            anchors{
                left: lblAssetName.left
                top: lblAssetName.bottom
                right: lblAssetName.right
            }

            topPadding: 15
        }

        CompLabel{
            id: lblAssetDetails
            color: "black"
            text: compBeaconOsInductScreen_SelectAssetItem.assetDetails
            font.pixelSize: 26
            anchors{
                left: lblAssetName.left
                top: lblInductionDate.bottom
                right: lblAssetName.right
                bottom: lblAssetsInducted.top
            }
            topPadding: 15
        }


        CompLabel{
            id: lblAssetsInducted

            text: compBeaconOsInductScreen_SelectAssetItem.assetsInducted
            color: "black"
            font.pixelSize: 26
            anchors{
                left: lblAssetName.left
                bottom: parent.bottom
                right: lblAssetName.right
            }

            topPadding: 15
        }
    }

    MouseArea{
        enabled: compBeaconOsInductScreen_SelectAssetItem.allowAssetClick

        anchors.fill: parent

        onClicked: compBeaconOsInductScreen_SelectAssetItem.assetClicked()
    }

}

/*##^##
Designer {
    D{i:0;autoSize:true;height:480;width:640}
}
##^##*/
