import QtQuick 2.12
import QtQuick.Controls 2.12


Comp__BASE {
    id: compAssetDashboardGridItemRoot

    property string assetName: "AssetName"
    property string beaconID: "BeaconID"
    property string assetState: "Active"
    property string beaconState: "Active"
    property string assetType: "Vehicle"

    width: 373
    height: 368

    CompGlassRect{
        id: rectBg
        anchors.fill: parent
    }

    MouseArea {
        anchors.fill: parent
        
        onClicked: {
            SystemController.targetBeaconID = beaconID
            SingletonScreenManager.slot_GoToScreen("Health Dashboard", true)
        }
        
    }
    
    Item {
        id: assetImgRoot

        anchors{
            left: parent.left
            right: parent.right
            top: parent.top
            topMargin: 37
            leftMargin: 30
            rightMargin: 30
        }

        height: 233

        ImgAssetGenerator {

            visible: assetType === "Generator"

            anchors.fill: parent
            cache: true
            fillMode: Image.PreserveAspectFit
            asynchronous: true
        }


        ImgAssetCNC {
            visible: assetType === "CNC"
            anchors.fill: parent
            cache: true
            fillMode: Image.PreserveAspectFit
            asynchronous: true
        }

        ImgAssetVehicle {
            visible: assetType === "Vehicle"
            anchors.fill: parent
            opacity: 0.8
            asynchronous: true
            cache: true
            fillMode: Image.PreserveAspectFit
        }

        ImgAssetGrowler {
            visible: assetType === "Growler"
            anchors.fill: parent
            opacity: 0.8
            asynchronous: true
            cache: true
            fillMode: Image.PreserveAspectFit
        }

        ImgAssetNano {
            visible: assetType === "Unknown"
            anchors.fill: parent
            opacity: 0.8
            asynchronous: true
            cache: true
            fillMode: Image.PreserveAspectFit

            antialiasing: true
            smooth: true
        }

        Image {
            visible: assetType === "Lathe"
            anchors.fill: parent

            asynchronous: true
            cache: true
            source: "file:///usr/share/BeaconOS-lib-images/images/Help.svg"
            fillMode: Image.PreserveAspectFit
        }

    }

    Row {
        id: rowAssetInfo

        anchors.horizontalCenter: parent.horizontalCenter
        anchors.top: assetImgRoot.bottom

        spacing: 11

        CompImageIcon {
            id: iconAssetStatus

            height: lblAssetName.height
            width: 20

            iconHeight: 20
            iconWidth: 20

            color: ((assetState === "Active") ? "#A2D47B" : "Red")
            source: "file:///usr/share/BeaconOS-lib-images/images/CheckFill.svg"

            verticalAlignment: Image.AlignVCenter

            MouseArea {
                id: assetStatusMouseArea
                anchors.fill: parent
            }

            CompTooltip {
                visible: assetStatusMouseArea.containsMouse

                text: qsTr("Some very helpful text explaining things")
            }
        }

        Label {
            id: lblAssetName

            text: assetName
            color: "White"
            verticalAlignment: "AlignVCenter"
            font {
                pixelSize: 25
                family: "Lato"
                weight: Font.Normal
            }
        }
    }

    Row {
        id: rowNanoInfo

        anchors.horizontalCenter: parent.horizontalCenter
        anchors.top: rowAssetInfo.bottom
        anchors.topMargin: 7

        spacing: 11


        CompImageIcon {
            id: iconNanoStatus

            color: (beaconState === "Active" ? "#A2D57B" : "Red")
            width: 20
            height: lblNanoName.height
            source: "file:///usr/share/BeaconOS-lib-images/images/PlugFill.svg"

            MouseArea {
                id: nanoStatusMouseArea
                anchors.fill: parent
            }

            CompTooltip {
                visible: nanoStatusMouseArea.containsMouse

                text: qsTr("Some very helpful text explaining things")
            }
        }

        Label {
            id: lblNanoName

            text: beaconID
            color: "White"

            font {
                pixelSize: 25
                family: "Lato"
                weight: Font.Normal
            }
        }
    }
}
