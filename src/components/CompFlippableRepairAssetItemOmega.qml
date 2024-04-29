import QtQuick 2.0
import QtQuick.Controls 2.12

Flipable{
    id: compFlippableRepairAssetItemOmegaRoot
    property bool flipped: false
    property string assetName: "F/A-18"
    property string inductionData: "01-02-2024 13:14:15"
    property string assetDetails: "Lots of incredibly meaningful, inciteful, and absolutely important information that ulltimately cannot be excluded from existence as it is just so very, very, useful. Lots of incredibly meaningful, inciteful, and absolutely important information that ulltimately cannot be excluded from existence as it is just so very, very, useful."
    property string assetsInducted: "3 assets inducted on depot floor"
    property string assetImagePath: "file:///usr/share/BeaconOS-lib-images/images/Induct_Asset_Growler.png"

//    property bool showBureauCombo: false
//    property bool allowAssetClick: true
//    property var listBureauNumbers
//    property int indexOfBuNoSelected: -1
//    property alias currentText: currentText
    signal clicked()
    function click(){
        compFlippableRepairAssetItemOmegaRoot.flipped = !compFlippableRepairAssetItemOmegaRoot.flipped
        //listViewSelectAsset.currentIndex = index
        compFlippableRepairAssetItemOmegaRoot.clicked()
    }

    height: 383
    width: 830

    front: Item {
        id: viewUnflipped

        anchors.fill: parent

        CompGradientRect {
            id: compGradientRect
            anchors.fill: parent
        }
        MouseArea {
            anchors.fill: parent
            onClicked: {
                console.log("clicked on the card")
                compFlippableRepairAssetItemOmegaRoot.clicked()
            }
        }
        Item {
            anchors{
                top: parent.top
                topMargin: 27
                left: parent.left
                leftMargin: 36
                bottom: parent.bottom
                bottomMargin: 27
            }
            CompImageIcon{
                id: assetImage

                color: "#9287ED"

                source: compFlippableRepairAssetItemOmegaRoot.assetImagePath

                width: 426
                height: 297

                transform: Rotation{
                    origin.x: assetImage.width * 0.5
                    origin.y: assetImage.height * 0.5
                    angle: 180
                }
            }
        }
        Item{
            anchors{
                top: parent.top
                topMargin: 27
                right: parent.right
                rightMargin: 36
                bottom: parent.bottom
                bottomMargin: 27
            }

            CompLabel{
                id: lblAssetName


                color: "white"
                text: compFlippableRepairAssetItemOmegaRoot.assetName
                font.pixelSize: 48
                anchors{
                    top: parent.top
                    right: parent.right
                    rightMargin: 40
                }

            }

            CompLabel{
                id: lblInductionDate

                text: compFlippableRepairAssetItemOmegaRoot.inductionData
                color: "white"
                font.pixelSize: 26
                anchors{
                    top: lblAssetName.bottom
                    right: lblAssetName.right
                }

                topPadding: 15
            }

            CompImageIcon{
                source: "file:///usr/share/BeaconOS-lib-images/images/Flip.svg"
                color: "#9287ED"
                height: 48
                width: 118
                anchors{
                    right: parent.right
                    rightMargin: 40
                    bottom: parent.bottom
                    bottomMargin: 40
                }
                MouseArea {
                    anchors.fill: parent
                    onClicked: {
                        compFlippableRepairAssetItemOmegaRoot.click()
                    }
                }
            }
        }


    }
    back: Item {
        id: viewFlipped

        anchors.fill: parent

        CompGradientRect {
            anchors.fill: parent
        }

        CompLabel{
            id: lblAssetNameBack

            color: "white"
            text: compFlippableRepairAssetItemOmegaRoot.assetName
            font.pixelSize: 48
            anchors{
                top: parent.top
                topMargin: 40
                left: parent.left
                leftMargin: 40
            }

        }

        CompLabel{
            id: lblInductionDateBack

            text: compFlippableRepairAssetItemOmegaRoot.inductionData
            color: "white"
            font.pixelSize: 26
            anchors{
                top: lblAssetNameBack.bottom
                left: lblAssetNameBack.left
            }

            topPadding: 15
        }
        ScrollView{
            id: assetDetailsScroll
            anchors{
                left: lblAssetNameBack.left
                top: lblInductionDateBack.bottom
                right: parent.right
                bottom: iconFlip.top
                bottomMargin: 20
            }
            clip: true
            ScrollBar.horizontal.policy: ScrollBar.AlwaysOff
            //Flickable.boundsBehavior: Flickable.StopAtBounds
            CompLabel{
                id: lblAssetDetails
                color: "white"
                text: compFlippableRepairAssetItemOmegaRoot.assetDetails
                wrapMode: Text.WordWrap
                font.pixelSize: 26
                topPadding: 15
                width: assetDetailsScroll.width
            }
        }
        CompLabel{
            id: lblAssetsInducted

            text: compFlippableRepairAssetItemOmegaRoot.assetsInducted
            color: "white"
            font.pixelSize: 26
            anchors{
                //left: lblAssetNameBack.left
                //top: assetDetailsScroll.bottom
                right: parent.right
                rightMargin: 40
                bottom: parent.bottom
                bottomMargin: 40
            }

            topPadding: 15
        }

        CompImageIcon{
            id: iconFlip
            source: "file:///usr/share/BeaconOS-lib-images/images/Flip.svg"
            color: "#9287ED"
            height: 48
            width: 118
            anchors{
                left: parent.left
                leftMargin: 40
                bottom: parent.bottom
                bottomMargin: 40
            }
            MouseArea {
                anchors.fill: parent
                onClicked: {compFlippableRepairAssetItemOmegaRoot.click()
                }
            }
        }
    }

    transform: Rotation {
        id: rotation
        origin.x: compFlippableRepairAssetItemOmegaRoot.width / 2
        origin.y: compFlippableRepairAssetItemOmegaRoot.height / 2
        axis.x: 0
        axis.y: 1
        axis.z: 0 // set axis.y to 1 to rotate around y-axis
        angle: 0 // the default angle
    }

    states: State {
        name: "back"
        PropertyChanges {
            target: rotation
            angle: 180
        }
        when: compFlippableRepairAssetItemOmegaRoot.flipped
    }

    transitions: Transition {
        NumberAnimation {
            target: rotation
            property: "angle"
            duration: 500
        }
    }

}
