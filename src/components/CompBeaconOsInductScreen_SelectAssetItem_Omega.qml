import QtQuick 2.0
import QtQuick.Controls 2.12

Comp__BASE{
    id: compBeaconOsInductScreen_SelectAssetItem

    property string assetName: "F/A-18"
    property string inductionData: "01-02-2024 13:14:15"
    property string assetDetails: "Lots of incredibly meaningful, inciteful, and absolutely important information that ulltimately cannot be excluded from existence as it is just so very, very, useful. Lots of incredibly meaningful, inciteful, and absolutely important information that ulltimately cannot be excluded from existence as it is just so very, very, useful."
    property string assetsInducted: "3 assets inducted on depot floor"
    property string assetImagePath: "file:///usr/share/BeaconOS-lib-images/images/Induct_Asset_Growler.png"

    property bool enableNext: true
    signal assetClicked()
    signal currentIndexChanged(int i)


    Component {
        id: highlight
        Rectangle {
            width: listViewSelectAsset.width; height: 383
            border {
                width: 4
                color: "#9287ED"
            }
            color: "Transparent"
            radius: 5
            y: listViewSelectAsset.currentItem.y
            Behavior on y {
                SpringAnimation {
                    spring: 3
                    damping: 0.2
                }
            }
        }
    }

    ListView{

        id: listViewSelectAsset

        anchors{
            top: parent.top
            topMargin: 35
            left: parent.left
            //leftMargin: 40
            right: parent.right
            //rightMargin: 40
            bottom: parent.bottom
            bottomMargin: 60
        }
        clip:true
        spacing: 60
        model: [
            {assetName: "F/A-18",
                inductionData: "01-02-2024 13:14:15",
                assetDetails: "Lots of incredibly meaningful, inciteful, and absolutely important information that ulltimately cannot be excluded from existence as it is just so very, very, useful. Lots of incredibly meaningful, inciteful, and absolutely important information that ulltimately cannot be excluded from existence as it is just so very, very, useful.",
                assetsInducted: "3 assets inducted on depot floor",
                assetImagePath: "file:///usr/share/BeaconOS-lib-images/images/Induct_Asset_Growler.png"
            },
            {assetName: "F/A-18",
                inductionData: "01-02-2024 13:14:15",
                assetDetails: "Lots of incredibly meaningful, inciteful, and absolutely important information that ulltimately cannot be excluded from existence as it is just so very, very, useful. Lots of incredibly meaningful, inciteful, and absolutely important information that ulltimately cannot be excluded from existence as it is just so very, very, useful.",
                assetsInducted: "3 assets inducted on depot floor",
                assetImagePath: "file:///usr/share/BeaconOS-lib-images/images/Induct_Asset_Growler.png"
            },
            {assetName: "F/A-18",
                inductionData: "01-02-2024 13:14:15",
                assetDetails: "Lots of incredibly meaningful, inciteful, and absolutely important information that ulltimately cannot be excluded from existence as it is just so very, very, useful. Lots of incredibly meaningful, inciteful, and absolutely important information that ulltimately cannot be excluded from existence as it is just so very, very, useful.",
                assetsInducted: "3 assets inducted on depot floor",
                assetImagePath: "file:///usr/share/BeaconOS-lib-images/images/Induct_Asset_Growler.png"
            },
            {assetName: "F/A-18",
                inductionData: "01-02-2024 13:14:15",
                assetDetails: "Lots of incredibly meaningful, inciteful, and absolutely important information that ulltimately cannot be excluded from existence as it is just so very, very, useful. Lots of incredibly meaningful, inciteful, and absolutely important information that ulltimately cannot be excluded from existence as it is just so very, very, useful.",
                assetsInducted: "3 assets inducted on depot floor",
                assetImagePath: "file:///usr/share/BeaconOS-lib-images/images/Induct_Asset_Growler.png"
            }
        ]
        onModelChanged: currentIndex = -1
        onCurrentIndexChanged: {
            compBeaconOsInductScreen_SelectAssetItem.currentIndexChanged(currentIndex)
        }

        delegate:
            CompFlippableRepairAssetItemOmega {
            id: assetInfo
            width: listViewSelectAsset.width

            assetName: modelData.assetName
            inductionData: modelData.inductionData
            assetDetails: modelData.assetDetails
            assetsInducted: modelData.assetsInducted
            assetImagePath: modelData.assetImagePath

            onClicked:{
                listViewSelectAsset.currentIndex = index
                compBeaconOsInductScreen_SelectAssetItem.assetName = modelData.assetName
                compBeaconOsInductScreen_SelectAssetItem.inductionData = modelData.inductionData
                compBeaconOsInductScreen_SelectAssetItem.assetDetails = modelData.assetDetails
                compBeaconOsInductScreen_SelectAssetItem.assetsInducted = modelData.assetsInducted
                compBeaconOsInductScreen_SelectAssetItem.assetImagePath = modelData.assetImagePath
            }

        }
        ScrollBar.vertical: ScrollBar{
            policy:  ScrollBar.AsNeeded
            width: 8
            //topInset: 51
            topPadding: 51
        }

        highlight: highlight
        highlightFollowsCurrentItem: true
        focus: true

    }
//    CompBtnBreadcrumb{
//        id: btnCancel

//        anchors{
//            left: parent.left
//            leftMargin: 50
//            bottom: parent.bottom
//            bottomMargin: 50
//        }

//        height: 128
//        width: 454

//        text: qsTr("Back")

//        onClicked: {
//            console.log("Clicked back");
//        }

//    }



}

/*##^##
Designer {
    D{i:0;autoSize:true;formeditorColor:"#4c4e50";formeditorZoom:0.25;height:1920;width:1080}
}
##^##*/
