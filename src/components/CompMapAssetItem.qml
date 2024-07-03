import QtQuick 2.0
import QtLocation 5.12
import QtPositioning 5.2
import QtGraphicalEffects 1.0

Comp__BASE_MapQuickItem {
    id: compMapAssetItemRoot

    property string assetType: 'TYPE'
    property string assetID: 'ASSET_ID'
    property alias assetTypelbl: lblAssetType
    property string imgSource
    property alias iconDetails: colorOverlayMapPin

    anchorPoint: Qt.point(sourceItem.width * 0.5, sourceItem.height * 0.5)
    coordinate: QtPositioning.coordinate(lat, lon)
    onCoordinateChanged: {
        sourceItem.coords = coordinate
    }

    onAssetTypeChanged:{
        sourceItem.assetTypeText = assetID
    }

    sourceItem:
        Item {
        id: compMapAssetItemSourceRoot

        property alias assetTypeText: imgSub.assetTypeText
        property alias coords: imgSub.coords

        height: 78
        width: 52

        ImgIconMapPos{
            id: imgSub

            property alias assetTypeText:lblAssetType.text
            property var coords

            visible: false
            source: imgSource

            anchors{
                fill:parent
            }


        }

        ColorOverlay{
            id: colorOverlayMapPin

            anchors{
                fill: imgSub
            }

            source: imgSub
            color: "#9287ED"
            opacity: 0.9
        }

        CompLabel{
            id: lblAssetType

            text: "TYPE"

            font{
                pixelSize: 20
                weight: Font.Bold
            }

            anchors{
                bottom: parent.top
                horizontalCenter: parent.horizontalCenter
            }
        }

        MouseArea{
            anchors.fill: parent

            onClicked: {
                compMapAssetItemRoot.centerOnPoint(coordinate)
            }

            onDoubleClicked: {
                compMapAssetItemRoot.fitViewportToVisibleMapItems()
                compMapAssetItemRoot.centerOnPoint(coordinate)
            }
        }

    }

}
