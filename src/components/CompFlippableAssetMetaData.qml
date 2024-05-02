import QtQuick 2.12
import QtGraphicalEffects 1.12

Comp__BASE_Flipable {
    id: compFlippableAssetMetaData

    property string assetType: AssetInfo.asstType
    property string assetName: AssetInfo.assetName
    property string assetDescription: AssetInfo.assetName
    property string assetSerialNumber:AssetInfo.serialNumber
    property string assetMeterialId: AssetInfo.materialID
    property string beaconID: AssetInfo.beaconID
    property string beaconLastSeen: AssetInfo.beaconLastSeen
    property string beaconState: AssetInfo.beaconState
    property string beaconLastSeenTxt: AssetInfo.beaconLastSeen ? AssetInfo.beaconLastSeen : "Now"
    property bool flipped: false

    height: isDelta ? 202 :  undefined
    width: isDelta ? 654 : undefined

    front: Item {
        id: viewUnflipped
        //visible: (compFlippableAssetMetaData.flipped === false)

        anchors{
            fill: parent
            topMargin: isDelta ? 0 : 100
            leftMargin: isDelta ? 0 : 50
            rightMargin: isDelta ? 0 : 50
            bottomMargin: isDelta ? 0 : 150
        }


        CompGradientRect {
            id: compGradientRect
            anchors.fill: parent
            anchors.topMargin: isDelta ? 0 : 150
        }

        Item{
            id: imgGroup
            anchors{
                top: isDelta ? parent.top : undefined
                topMargin: isDelta ? 27 : 0
                left: isDelta ? parent.left : undefined
                leftMargin: isDelta ? 36 : 0
                bottom: isDelta ? parent.bottom : undefined
                bottomMargin: isDelta ? 27 : 0
                horizontalCenter: isDelta ? undefined : parent.horizontalCenter
            }

            width: isDelta ?  237 : 814
            height: isDelta ? undefined : 508

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
                verticalCenter: isDelta ? parent.verticalCenter : undefined
                left: isDelta ? imgGroup.right : parent.left
                leftMargin: isDelta ? 21 : 40
                right: isDelta ? undefined : parent.right
                rightMargin: isDelta ? 0 : 40
                top: isDelta ? undefined : imgGroup.bottom
                topMargin: isDelta ? 0 : 21
            }

            height: isDelta ? (lblAssetName.y + lblAssetMaterialId.height + lblAssetMaterialId.y) : undefined

            CompLabel{
                id: lblAssetName
                color: "White"
                anchors{
                    left: isDelta ? parent.right : parent.left
                    top: parent.top
                }

                text: compFlippableAssetMetaData.assetName
                font{
                    pixelSize: isDelta ? 32 : 74

                }

            }
            CompIconBtn {
                id: btnEdit
                visible: !isDelta

                anchors {
                    top: parent.top
                    left: lblAssetName.right
                    leftMargin: 42
                    verticalCenter: lblAssetName.verticalCenter
                }

                height: 53
                width: 51
                iconUrl: "file:///usr/share/BeaconOS-lib-images/images/EditPencil.svg"
                iconColor: "White"

            }

            CompLabel{
                id: lblAssetDescription
                color: "#9287ED"
                anchors{
                    left: lblAssetName.left
                    top: lblAssetName.bottom
                    topMargin: isDelta ? 1 : 13
                    right: isDelta ? undefined : lblAssetName.right
                }

                text: compFlippableAssetMetaData.assetDescription

                font{
                    pixelSize: isDelta ? 12 : 38

                }
            }

            Rectangle{
                id: separator

                anchors{
                    left: lblAssetName.left
                    top: lblAssetDescription.bottom
                    right: isDelta ? undefined : lblAssetName.right
                    topMargin: isDelta ? 17 : 45
                }

                width: isDelta ? 304 : 759
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
                    right: isDelta ? undefined : lblAssetName.right
                    topMargin: isDelta ? 10 : 91
                }

                text: qsTr("Serial No.: ") + compFlippableAssetMetaData.assetSerialNumber

                font{
                    pixelSize: isDelta ? 14 : 42

                    weight: Font.Light
                }
            }

            CompLabel{
                id: lblAssetMaterialId
                color: "White"
                anchors{
                    left: lblAssetName.left
                    top: lblAssetSerial.bottom
                    right: isDelta ? undefined : lblAssetName.right
                    topMargin: isDelta ? 1 : 24
                    bottom: isDelta ? undefined : parent.bottom
                }

                text: qsTr("Material ID: ") + compFlippableAssetMetaData.assetMeterialId
                font{
                    pixelSize: isDelta ? 14 : 42

                    weight: Font.Light
                }
            }

        }


    }



    back: Item {
        id: viewFlipped
        //visible: (compFlippableAssetMetaData.flipped === true)
        anchors{
            fill: parent
            topMargin: isDelta ? 0 : 100
            leftMargin: isDelta ? 0 : 50
            rightMargin: isDelta ? 0 : 50
            bottomMargin: isDelta ? 0 : 150
        }

        CompGradientRect {
            anchors.fill: parent
            anchors.topMargin: isDelta ? 0 : 150
        }
        Item{
            id: imgBeaconInfoParent
            anchors{
                top: isDelta ? parent.top : undefined
                topMargin: isDelta ? 27 : 0
                left: isDelta ? parent.left : undefined
                leftMargin: isDelta ? 36 : 0
                bottom: isDelta ? parent.bottom : undefined
                bottomMargin: isDelta ? 27 : 0
                horizontalCenter: isDelta ? undefined : parent.horizontalCenter
            }

            width: isDelta ?  237 : 814
            height: isDelta ? undefined : 508

            ImgAssetNano {
                id: imgBeaconInfo
                anchors.fill: parent
                fillMode: Image.PreserveAspectFit
            }
        }
        Item{
            id: beaconInfo

            anchors{
                verticalCenter: isDelta ? parent.verticalCenter : undefined
                left: isDelta ? imgBeaconInfoParent.right : parent.left
                leftMargin: isDelta ? 21 : 40
                right: isDelta ? undefined : parent.right
                rightMargin: isDelta ? 0 : 40
                top: isDelta ? undefined :imgBeaconInfoParent.bottom
                topMargin: isDelta ? 0  : 21
            }

            height: isDelta ? (lblAssetName.y + lblAssetMaterialId.height + lblAssetMaterialId.y) : undefined

            CompLabel{
                id: lblbeaconID
                color: "White"
                anchors{
                    left: isDelta ? parent.right : parent.left
                    top: parent.top
                    right: isDelta ? undefined : parent.right
                }

                text: compFlippableAssetMetaData.beaconID
                font{
                    pixelSize: isDelta ? 32 : 60

                }

            }

            Rectangle{
                id: separatorBack

                anchors{
                    left: lblbeaconID.left
                    top: lblbeaconID.bottom
                    right: isDelta ? undefined : lblbeaconID.right
                    topMargin: isDelta ? 17 : 45
                }

                width: isDelta ? 304 : 759
                height: 2

                radius: 1

                color: "#33FFFFFF"
            }

            CompLabel{
                id: lblbeaconLastSeen
                color: "White"
                anchors{
                    left: lblbeaconID.left
                    top: separatorBack.bottom
                    right: isDelta ? undefined : lblbeaconID.right
                    topMargin: isDelta ? 10 : 60
                }
                text: qsTr("Beacon Last Seen: ") + compFlippableAssetMetaData.beaconLastSeenTxt

                font{
                    pixelSize: isDelta ? 14 : 42

                    weight: Font.Light
                }
            }

            CompLabel{
                id: lblbeaconState
                color: "White"
                anchors{
                    left: lblbeaconID.left
                    top: lblbeaconLastSeen.bottom
                    right: isDelta ? undefined : lblbeaconID.right
                    topMargin: isDelta ? 1 : 24
                    bottom: isDelta ? undefined : parent.bottom
                }

                text: qsTr("Beacon State: ") + compFlippableAssetMetaData.beaconState
                font{
                    pixelSize: isDelta ? 14 : 42

                    weight: Font.Light
                }
            }

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
