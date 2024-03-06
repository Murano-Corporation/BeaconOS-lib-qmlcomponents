import QtQuick 2.0
import QtQuick.Controls 2.12

Comp__BASE{
    id: compBeaconOsInductScreen_SelectAssetItem

    property string assetName: "F/A-18"
    property string inductionData: "01-02-2024 13:14:15"
    property string assetDetails: "Lots of wonderfully meaningful information displayed here."
    property string assetsInducted: "3 assets inducted on depot floor"
    property string assetImagePath: "file:///usr/share/BeaconOS-lib-images/images/Induct_Asset_Growler.png"
    property bool showBureauCombo: false
    property bool allowAssetClick: true

    property var listBureauNumbers

    property int indexOfBuNoSelected: -1
    property alias currentText: comboSelectBureauNumber.currentText
    signal assetClicked()

    CompGradientRect{
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

            leftMargin: 90
            topMargin: 180
            bottomMargin: 180

        }

        color: "white"

        source: compBeaconOsInductScreen_SelectAssetItem.assetImagePath

        width: height
    }

    Rectangle{
        id: rectSep

        anchors{
            top: parent.top
            left: assetImage.right
            bottom: parent.bottom

            leftMargin: 90

        }

        width: 6
        color: "#80000000"
    }

    Item{
        id: groupAssetInfo

        anchors{
            top: parent.top
            topMargin: 40
            left: rectSep.right
            leftMargin: 40
            bottom: parent.bottom
            bottomMargin: 40
            right: parent.right
            rightMargin: 40
        }

        CompCombobox {
            id: comboSelectBureauNumber

            unselectedText: "Select BuNo"
            textRole: "key"
            visible: compBeaconOsInductScreen_SelectAssetItem.showBureauCombo
            model: compBeaconOsInductScreen_SelectAssetItem.listBureauNumbers

            anchors{
                top:  lblAssetName.top
                right: parent.right
                bottom: lblAssetName.bottom

            }

            width: 400

            onCurrentIndexChanged: {
                console.log("Current Index Changed to: " + currentIndex)
                scaleTrans.xScale = 1.0
                scaleTrans.yScale = 1.0
                compBeaconOsInductScreen_SelectAssetItem.indexOfBuNoSelected = currentIndex
            }
            onCurrentValueChanged: {
                console.log("Current Value now: " + currentValue)
            }

            onCurrentTextChanged: {
                console.log("Current text changed to: " + currentText)
            }

            transform: Scale{
                id: scaleTrans
                xScale: 1
                yScale: 1

                origin{
                    x: comboSelectBureauNumber.width
                    y: comboSelectBureauNumber.height * 0.5
                }
            }

            SequentialAnimation{
                id: animSeq
                property real maxValue: 1.1

                running: comboSelectBureauNumber.currentIndex <= 0 && !comboSelectBureauNumber.popup.visible
                loops: Animation.Infinite

                ParallelAnimation{
                    NumberAnimation {
                        target: scaleTrans
                        property: "yScale"
                        duration: 2000
                        easing.type: Easing.InOutQuad
                        from: 1.0
                        to: animSeq.maxValue
                    }
                    NumberAnimation {
                        target: scaleTrans
                        property: "xScale"
                        duration: 2000
                        easing.type: Easing.InOutQuad
                        from: 1.0
                        to: animSeq.maxValue
                    }
                }

                ParallelAnimation{
                    NumberAnimation {
                        target: scaleTrans
                        property: "yScale"
                        duration: 1000
                        easing.type: Easing.InOutQuad
                        from: animSeq.maxValue
                        to: 1.0
                    }
                    NumberAnimation {
                        target: scaleTrans
                        property: "xScale"
                        duration: 1000
                        easing.type: Easing.InOutQuad
                        from: animSeq.maxValue
                        to: 1.0
                    }
                }

            }



        }

        CompLabel{
            id: lblAssetName

            text: compBeaconOsInductScreen_SelectAssetItem.assetName
            color: "white"
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
            color: "white"
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
            color: "white"
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
            color: "white"
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
    D{i:0;autoSize:true;formeditorColor:"#4c4e50";formeditorZoom:0.5;height:914;width:1800}
}
##^##*/
