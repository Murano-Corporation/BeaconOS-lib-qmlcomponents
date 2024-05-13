import QtQuick 2.0
import QtLocation 5.12
import QtPositioning 5.15

MapQuickItem {

    property alias targetDevice: compBase.targetDevice
    property real lat: 0.0
    property real lon: 0.0
    property real itemHeight: 78
    property real itemWidth: 52

    signal centerOnPoint(var coords)
    signal fitViewportToVisibleMapItems()

    anchorPoint: Qt.point(sourceItem.width * 0.5, sourceItem.height * 0.5)
    coordinate: QtPositioning.coordinate(lat, lon)

    onCoordinateChanged: {
        sourceItem.coords = coordinate
        //console.log("CompMapAssetItem::Coordinates now " + coordinate + " for BeaconID " + assetID)

    }

    Comp__BASE{
        id: compBase
    }
}
