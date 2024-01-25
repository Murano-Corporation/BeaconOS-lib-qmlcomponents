import QtQuick 2.12
import QtGraphicalEffects 1.12

Flipable {
    id: compFlippableAssetMetaData

    property string assetType: AssetInfo.asstType
    property string assetName: AssetInfo.assetName
    property string assetDescription: AssetInfo.assetName
    property string assetSerialNumber:AssetInfo.serialNumber
    property string assetMeterialId: AssetInfo.materialID
    property bool flipped: false

    height: 202
    width: 654

    front: Item {
        id: viewUnflipped
        //visible: (compFlippableAssetMetaData.flipped === false)

        anchors.fill: parent


        CompGradientRect {
            id: compGradientRect
            anchors.fill: parent
        }

        Item{
            id: imgGroup
            anchors{
                top: parent.top
                topMargin: 27
                left: parent.left
                leftMargin: 36
                bottom: parent.bottom
                bottomMargin: 27
            }

            width: 237

            ImgAssetCNC {
                id: imgCNC
                visible: (compFlippableAssetMetaData.assetType === "CNC")
                anchors.fill: parent
                fillMode: Image.PreserveAspectFit
            }

            ImgAssetGenerator {
                id: imgGenerator
                visible: (compFlippableAssetMetaData.assetType === "Generator")
                anchors.fill: parent
                fillMode: Image.PreserveAspectFit
            }

            ImgAssetVehicle {
                id: imgVehicle
                visible: (compFlippableAssetMetaData.assetType === "Vehicle")
                anchors.fill: parent
                fillMode: Image.PreserveAspectFit
            }

            ImgAssetGrowler {
                id: imgGrowler
                visible: (compFlippableAssetMetaData.assetType === "Growler")
                anchors.fill: parent
                fillMode: Image.PreserveAspectFit
            }

            Image {
                id: imgLathe
                visible: (compFlippableAssetMetaData.assetType === "Lathe")
                anchors.fill: parent
                fillMode: Image.PreserveAspectFit
                source: "file:///usr/share/BeaconOS-lib-images/images/favicon.png"
            }

            ImgAssetNano {
                id: imgUnknown
                visible: (compFlippableAssetMetaData.assetType === "Unknown")
                anchors.fill: parent
                fillMode: Image.PreserveAspectFit
            }

        }

        Item{
            id: textGroup

            anchors{
                verticalCenter: parent.verticalCenter
                left: imgGroup.right
                leftMargin: 21
            }

            height: (lblAssetName.y + lblAssetMaterialId.height + lblAssetMaterialId.y)

            CompLabel{
                id: lblAssetName
                color: "White"
                anchors{
                    left: parent.right
                    top: parent.top
                }

                text: compFlippableAssetMetaData.assetName
                font{
                    pixelSize: 32

                }

            }

            CompLabel{
                id: lblAssetDescription
                color: "#9287ED"
                anchors{
                    left: lblAssetName.left
                    top: lblAssetName.bottom
                    topMargin: 1
                }

                text: compFlippableAssetMetaData.assetDescription

                font{
                    pixelSize: 12

                }
            }

            Rectangle{
                id: separator

                anchors{
                    left: lblAssetName.left
                    top: lblAssetDescription.bottom
                    topMargin: 17
                }

                width: 304
                height: 2

                radius: 1

                color: "#33FFFFFF"
            }

            CompLabel{
                id: lblAssetSerial
                color: "White"
                anchors{
                    left: lblAssetName.left
                    top: separator.bottom
                    topMargin: 10
                }

                text: qsTr("Serial No.: ") + compFlippableAssetMetaData.assetSerialNumber

                font{
                    pixelSize: 14

                    weight: Font.Light
                }
            }

            CompLabel{
                id: lblAssetMaterialId
                color: "White"
                anchors{
                    left: lblAssetName.left
                    top: lblAssetSerial.bottom
                    topMargin: 1
                }

                text: qsTr("Material ID: ") + compFlippableAssetMetaData.assetMeterialId
                font{
                    pixelSize: 14

                    weight: Font.Light
                }
            }

        }


    }



    back: Item {
        id: viewFlipped
        //visible: (compFlippableAssetMetaData.flipped === true)
        anchors.fill: parent

        CompGradientRect {
            anchors.fill: parent
        }
    }

    transform: Rotation {
        id: rotation
        origin.x: compFlippableAssetMetaData.width / 2
        origin.y: compFlippableAssetMetaData.height / 2
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
        when: compFlippableAssetMetaData.flipped
    }

    transitions: Transition {
        NumberAnimation {
            target: rotation
            property: "angle"
            duration: 500
        }
    }

    MouseArea {
        anchors.fill: parent
        onClicked: compFlippableAssetMetaData.flipped = !compFlippableAssetMetaData.flipped
    }
}
