import QtQuick 2.12
import QtGraphicalEffects 1.0

Flipable {
    id: compFlippableAssetMetaDataOmega

    property string assetType: AssetInfo.asstType
    property string assetName: AssetInfo.assetName
    property string assetDescription: AssetInfo.assetName
    property string assetSerialNumber:AssetInfo.serialNumber
    property string assetMeterialId: AssetInfo.materialID
    property bool flipped: false


    Component.onCompleted: {
        loaderBackImg.active = true
    }

    //side: 1
    front: Item {
        id: viewUnflipped

        anchors{
            fill: parent
            topMargin: 100
            leftMargin: 50
            rightMargin: 50
            bottomMargin: 150

        }


        CompGradientRect {
            id: compGradientRect

            anchors{
                fill: parent
                topMargin: 150
            }

        }

        Item{
            id: imgGroup
            anchors{
                //top: parent.top
                horizontalCenter: parent.horizontalCenter
            }

            width: 814
            height: 508

            Loader{
                active: (compFlippableAssetMetaDataOmega.assetType === "CNC")
                asynchronous: true
                anchors.fill: parent
                sourceComponent: ImgAssetCNC {
                    anchors.fill: parent
                    fillMode: Image.PreserveAspectFit
                }
            }

            Loader{
                active: (compFlippableAssetMetaDataOmega.assetType === "Generator")
                asynchronous: true
                anchors.fill: parent
                sourceComponent: ImgAssetGenerator {

                    anchors.fill: parent
                    fillMode: Image.PreserveAspectFit
                }
            }

            Loader{
                active: (compFlippableAssetMetaDataOmega.assetType === "Vehicle")
                asynchronous: true
                anchors.fill: parent
                sourceComponent: ImgAssetVehicle {

                    anchors.fill: parent
                    fillMode: Image.PreserveAspectFit
                }
            }

            Loader{
                active: (compFlippableAssetMetaDataOmega.assetType === "Growler")
                asynchronous: true
                anchors.fill: parent
                sourceComponent: ImgAssetGrowler {
                    anchors.fill: parent
                    fillMode: Image.PreserveAspectFit
                }
            }

            Loader{
                active: (compFlippableAssetMetaDataOmega.assetType === "Unknown")
                asynchronous: true
                anchors.fill: parent
                sourceComponent: ImgAssetNano {
                    anchors.fill: parent
                    fillMode: Image.PreserveAspectFit
                }
            }




        }

        Item{
            id: textGroup

            anchors{
                //horizontalCenter: parent.horizontalCenter
                left: parent.left
                right: parent.right
                top: imgGroup.bottom
                topMargin: 21
                leftMargin: 40
                rightMargin: 40
            }

            //height: (lblAssetName.y + lblAssetMaterialId.height + lblAssetMaterialId.y)

            CompLabel{
                id: lblAssetName
                color: "White"
                anchors{
                    top: parent.top
                    left: parent.left

                }

                text: compFlippableAssetMetaDataOmega.assetName
                font{
                    pixelSize: 74

                }

            }

            CompIconBtn {
                id: btnEdit

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
                    right: lblAssetName.right
                    top: lblAssetName.bottom
                    topMargin: 13
                }

                text: compFlippableAssetMetaDataOmega.assetDescription

                font{
                    pixelSize: 38

                }
            }

            Rectangle{
                id: separator

                anchors{
                    left: lblAssetName.left
                    top: lblAssetDescription.bottom
                    right: lblAssetName.right
                    topMargin: 45
                }

                width: 759
                height: 2

                radius: 1

                color: "#33FFFFFF"
            }

            CompLabel{
                id: lblAssetSerial
                color: "White"
                anchors{
                    left: lblAssetName.left
                    right: lblAssetName.right
                    top: separator.bottom
                    topMargin: 91
                }

                text: qsTr("Serial No.: ") + compFlippableAssetMetaDataOmega.assetSerialNumber

                font{
                    pixelSize: 42

                    weight: Font.Light
                }
            }

            CompLabel{
                id: lblAssetMaterialId
                color: "White"
                anchors{
                    left: lblAssetName.left
                    right: lblAssetName.right
                    top: lblAssetSerial.bottom
                    topMargin: 24
                    bottom: parent.bottom
                }

                text: qsTr("Material ID: ") + compFlippableAssetMetaDataOmega.assetMeterialId
                font{
                    pixelSize: 42

                    weight: Font.Light
                }
            }

        }


    }

    back: Item {
        id: viewFlipped
        //visible: (compFlippableAssetMetaDataOmega.flipped === true)
        anchors{
            fill: parent
            topMargin: 100
            leftMargin: 50
            rightMargin: 50
            bottomMargin: 150

        }

        CompGradientRect {
            id: compGradientRectBack

            anchors{
                fill: parent
                topMargin: 150
            }

        }
        Item{
            id: imgGroupBack
            anchors{
                //top: parent.top
                horizontalCenter: parent.horizontalCenter
            }

            width: 814
            height: 508


            Loader{
                id: loaderBackImg
                active: false
                anchors.fill: parent
                asynchronous: true
                sourceComponent: ImgAssetNano {
                    id: imgBeaconInfo
                    anchors.fill: parent
                    fillMode: Image.PreserveAspectFit
                }
            }

        }
        Item{
            id: beaconInfo

            anchors{
                //horizontalCenter: parent.horizontalCenter
                left: parent.left
                right: parent.right
                top: imgGroupBack.bottom
                topMargin: 21
                leftMargin: 40
                rightMargin: 40
            }

            //height: (lblAssetName.y + lblAssetMaterialId.height + lblAssetMaterialId.y)

            CompLabel{
                id: lblbeaconID
                color: "White"
                anchors{
                    top: parent.top
                    left: parent.left
                    right: parent.right
                }
                text: compFlippableAssetMetaDataOmega.beaconID
                font{
                    pixelSize: 60

                }

            }

            Rectangle{
                id: separatorBack

                anchors{
                    left: lblbeaconID.left
                    top: lblbeaconID.bottom
                    right: lblbeaconID.right
                    topMargin: 45
                }

                width: 759
                height: 2

                radius: 1

                color: "#33FFFFFF"
            }

            CompLabel{
                id: lblbeaconLastSeen
                color: "White"
                anchors{
                    left: lblbeaconID.left
                    right: lblbeaconID.right
                    top: separatorBack.bottom
                    topMargin: 60
                }
                text: qsTr("Beacon Last Seen: ") + compFlippableAssetMetaDataOmega.beaconLastSeenTxt

                font{
                    pixelSize: 42

                    weight: Font.Light
                }
            }

            CompLabel{
                id: lblbeaconState
                color: "White"
                anchors{
                    left: lblbeaconID.left
                    right: lblbeaconID.right
                    top: lblbeaconLastSeen.bottom
                    topMargin: 24
                    bottom: parent.bottom
                }

                text: qsTr("Beacon State: ") + compFlippableAssetMetaDataOmega.beaconState
                font{
                    pixelSize: 42

                    weight: Font.Light
                }
            }

        }
    }

    transform: Rotation {
        id: rotation
        origin.x: compFlippableAssetMetaDataOmega.width / 2
        origin.y: compFlippableAssetMetaDataOmega.height / 2
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
        when: compFlippableAssetMetaDataOmega.flipped
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
        onClicked: {
            console.log("compFlippableAssetMetaDataOmega.beaconID" + compFlippableAssetMetaDataOmega.beaconID)
            compFlippableAssetMetaDataOmega.flipped = !compFlippableAssetMetaDataOmega.flipped}
    }
}

/*##^##
Designer {
    D{i:0;autoSize:true;formeditorColor:"#4c4e50";formeditorZoom:0.25;height:1920;width:1080}
}
##^##*/
