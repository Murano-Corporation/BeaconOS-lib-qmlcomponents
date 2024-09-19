import QtQuick 2.12
import QtLocation 5.12
import QtPositioning 5.12
import QtQuick.Controls 2.12
import QtGraphicalEffects 1.0

Comp__BASE {
    id: compMapViewerRoot

    property point centerPoint: Qt.point(0, 0)
    property var listAssets: TableModelAssetDashboardGridView
    property var selectedAssetDataModel: undefined
    property bool showAssets: true
    property bool captureMouseCoords: false
    property int activeMapTypeIndex: mapPlugin.name === 'mapboxgl' ? 1 : 0 //(screenToLoad === "Raptor") ? (1) : (mapPlugin.name === 'mapboxgl' ? 4 : 0)
    property int maxMapTypeIndex: map.supportedMapTypes.length
    property alias targetListDelegate: mapView_Targets.delegate
    property alias tilt: map.tilt
    property alias center: map.center
    property alias zoomLevel: map.zoomLevel
    property alias bearing: map.bearing
    property alias mapPolyLine: mapPolyLineMain
    property bool showMapTypes: true

    property real zoomCurrent

    onSelectedAssetDataModelChanged: {
        if (selectedAssetDataModel === undefined) {
            popupSelectedAsset.close()
        } else {
            popupSelectedAsset.open()
        }
    }

    function getSimpleMapNameString(mapTypeName) {

        //console.log("Map name: " + mapTypeName)
        switch (mapTypeName) {
        case " ":
            return qsTr("No Map")
        case "mapbox://styles/mapbox/streets-v10":
            return qsTr("Street")
        case "mapbox://styles/mapbox/basic-v9":
            return qsTr("Basic")
        case "mapbox://styles/mapbox/bright-v9":
            return qsTr("Bright")
        case "mapbox://styles/mapbox/outdoors-v10":
            return qsTr("Terrain")
        case "mapbox://styles/mapbox/satellite-streets-v10":
            return qsTr("Hybrid")
        case "mapbox://styles/mapbox/light-v9":
            return qsTr("Street (Light)")
        case "mapbox://styles/mapbox/dark-v9":
            return qsTr("Street (Dark)")
        case "mapbox://styles/mapbox/satellite-v9":
            return qsTr("Satellite")
        case "mapbox://styles/mapbox/navigation-preview-day-v2":
            return qsTr("Nav Preview (Day)")
        case "mapbox://styles/mapbox/navigation-guidance-day-v2":
            return qsTr("Nav Guidance (Day)")
        case "mapbox://styles/mapbox/navigation-preview-night-v2":
            return qsTr("Nav Preview (Night)")
        case "mapbox://styles/mapbox/navigation-guidance-night-v2":
            return qsTr("Nav Guidance (Night)")
        }

        return "?"
    }

    function setActiveMapTypeIndex(index) {
        activeMapTypeIndex = index
    }

    function clear() {}

    function setZoomLevel(zoomLevel) {
        map.zoomLevel = zoomLevel
    }

    function addPoint(lat, lon, type) {
        var mapPoint = Qt.createQmlObject(
                    'import QtLocation 5.3; MapCircle {}', compMapViewerRoot)
        var coords = QtPositioning.coordinate(lat, lon)
        mapPoint.center = coords
        mapPoint.radius = 20
        mapPoint.color = "#800000FF"

        map.addMapItem(mapPoint)

        var toAdd = compClickableMapItem.createObject(compMapViewerRoot)
        toAdd.coordinate = coords
        map.addMapItem(toAdd)

        compMapViewerRoot.centerPoint = Qt.point(lat, lon)
    }

    function centerOnPointXY(x, y) {
        centerOnPoint(QtPositioning.coordinate(x, y))
    }

    function centerOnPoint(coords) {
        map.center = coords
    }

    ListView {
        id: listMapTypes

        visible: compMapViewerRoot.showMapTypes
        anchors {
            top: parent.top
            left: parent.left
            right: parent.right
            //bottom: parent.bottom
            topMargin: raptorNavMenu.selectedScreen === "Raptor" ? 100 : 0
        }

        height: compMapViewerRoot.showMapTypes ? (isDelta ? 64 : 110) : 0
        spacing: 20
        clip: true
        orientation: ListView.Horizontal

        model: map.supportedMapTypes
        onModelChanged: currentIndex = -1

        delegate: CompBtnBreadcrumb {
            text: getSimpleMapNameString(model.name)

            height: isDelta ? 64 : 100
            font.pixelSize: isDelta ? 20 : 40

            onClicked: {
                compMapViewerRoot.activeMapTypeIndex = index
                listMapTypes.currentIndex = index
            }
        }
        highlightMoveVelocity: 6000
        highlight: Rectangle {
            width: listMapTypes.cellWidth
            height: listMapTypes.cellHeight
            border {
                width: 4
                color: "#9287ED"
            }
            color: "Transparent"
            radius: 20

            Behavior on width {
                SpringAnimation {
                    spring: 3
                    damping: 0.2
                }
            }

            Behavior on x {
                SpringAnimation {
                    spring: 3
                    damping: 0.2
                }
            }
        }

        highlightFollowsCurrentItem: true
        focus: true

        ScrollBar.horizontal: ScrollBar {
            policy: ScrollBar.AsNeeded

            height: ListView.height
        }
    }

    onActiveMapTypeIndexChanged: {
        //console.log("Active map type index now: " + activeMapTypeIndex)
        //console.log("Supported map types count: " + map.supportedMapTypes.length)
        if (map.supportedMapTypes.length === 0) {
            console.error("NO SUPPORTED MAP TYPES")
            return
        } else if (activeMapTypeIndex <= -1) {
            activeMapTypeIndex = 0
            return
        } else if (activeMapTypeIndex >= maxMapTypeIndex) {
            activeMapTypeIndex = maxMapTypeIndex - 1
            return
        }

        map.activeMapType = map.supportedMapTypes[activeMapTypeIndex]
    }

    Component {
        id: compClickableMapItem

        MapQuickItem {

            anchorPoint: Qt.point(sourceItem.width * 0.5,
                                  sourceItem.height * 0.5)

            onCoordinateChanged: {
                sourceItem.coords = coordinate
                console.log("compClickableMapItem:: Coordinates now " + coordinate)
            }

            sourceItem: ImgAssetVehicle {
                id: imgSub
                height: 100
                width: 100

                property var coords

                MouseArea {
                    anchors.fill: parent

                    onClicked: {
                        compMapViewerRoot.centerOnPoint(parent.coords)
                    }

                    onDoubleClicked: {
                        map.fitViewportToVisibleMapItems()
                        compMapViewerRoot.centerOnPoint(parent.coords)
                    }
                }
            }
        }
    }

    onCenterPointChanged: {
        map.center = QtPositioning.coordinate(centerPoint.x, centerPoint.y)
        map.fitViewportToVisibleMapItems()

        //map.addMapItem()
    }

    //Component.onCompleted: {
    //    //console.log("Available Map Types:")
    //    //console.log("Supported Plugin Service Providers " + mapPlugin.availableServiceProviders)
    //    //for(var j = 0; j < map.supportedMapTypes.length; j++)
    //    //{
    //    //    var mapTypeCurrent = map.supportedMapTypes[j]
    //    //    var typeName = mapTypeCurrent.name
    //    //    var nightMode = mapTypeCurrent.night
    //    //    var style = mapTypeCurrent.style
    //    //    var description = mapTypeCurrent.description
    //    //    var metaData = mapTypeCurrent.metadata
    //    //    var isMobile = mapTypeCurrent.mobile
    //    //    console.log(" - " + typeName)
    //    //    console.log(" --- Description: " + description)
    //    //    console.log(" --- IsNightMode: " + nightMode)
    //    //    console.log(" --- IsMobile: " + isMobile)
    //    //    console.log(" --- Style: " + style)
    //    //    console.log(" --- MetaData: " + metaData)
    //    //    console.log(" ")
    //    //}
    //}
    Plugin {
        id: mapPlugin

        preferred: ["mapboxgl", "osm"]

        //required: Plugin.OnlineMappingFeature | Plugin.OfflineMappingFeature | Plugin.LocalizedMappingFeature |
        //          Plugin.NoPlacesFeatures | Plugin.NoRoutingFeatures | Plugin.AnyGeocodingFeatures
        PluginParameter {
            name: "esri.token"
            value: "AAPK89749ac0dd3e4a108bedf722e117c92ah5KdAZ_1yGyeBOSzoW7gPur9Fy0jHoq2aXa9SlwgTxhhfP0qyw3rvgD67YGQwakb"
        }

        PluginParameter {
            name: "osm.access_token"
            value: "242e69891b264077a78f5f9f87e095c0"
        }

        PluginParameter {
            name: "mapbox.access_token"
            value: "sk.eyJ1IjoiYWp0LW11cmFubyIsImEiOiJjbHFjbWQzOXkwM3BvMnhxdzh5M3ZmbDZiIn0.dGKKlVL8RAT4Od4-TtIEbg"
        }
        PluginParameter {
            name: "mapboxgl.access_token"
            value: "sk.eyJ1IjoiYWp0LW11cmFubyIsImEiOiJjbHFjbWQzOXkwM3BvMnhxdzh5M3ZmbDZiIn0.dGKKlVL8RAT4Od4-TtIEbg"
        }

        //onNameChanged: {
        //    compMapViewerRoot.activeMapTypeIndex = 0
        //}

        //Component.onCompleted:{
        //    console.log("Available Map Plugins: " + availableServiceProviders)
        //    console.log("Available plugin params:")
        //    console.log(parameters)
        //}
    }

    Map {
        id: map
        anchors {
            top: listMapTypes.bottom
            topMargin: compMapViewerRoot.showMapTypes ? 20 : 0
            left: parent.left
            right: parent.right
            bottom: parent.bottom
        }

        onZoomLevelChanged: {
            compMapViewerRoot.zoomCurrent = zoomLevel
        }

        copyrightsVisible: false
        activeMapType: supportedMapTypes[compMapViewerRoot.activeMapTypeIndex]
        plugin: mapPlugin
        center: QtPositioning.coordinate(center.x, centerPoint.y)

        MapPolyline {
            id: mapPolyLineMain

            line.width: 5
            line.color: "blue"
        }

        MouseArea {
            id: mouseArea_CoordGrabber

            property var coordinate: map.toCoordinate(Qt.point(mouseX, mouseY))

            enabled: compMapViewerRoot.captureMouseCoords
            visible: enabled

            anchors.fill: parent
            //hoverEnabled: true
            propagateComposedEvents: true

            onClicked: {
                console.log("map.toCoordinate(Qt.point(mouseX, mouseY)): " + map.toCoordinate(
                                Qt.point(mouseX, mouseY)))
            }
        }

        MapItemView {
            id: mapView_Targets
            model: compMapViewerRoot.listAssets

            delegate: CompMapAssetItem {
                id: compMapAssetItem

                lat: model.Latitude
                lon: model.Longitude
                assetType: model.asset_type
                assetID: model.beacon_id //(model.asset_type === "Antenna" || model.asset_type === "Drone") ? "" : model.Beacon_ID
                assetTypelbl.font.pixelSize: isDelta ? 20 : 40
                imgSource: model.asset_type === "Antenna" ? "file:///usr/share/BeaconOS-lib-images/images/Antenna.svg" : "file:///usr/share/BeaconOS-lib-images/images/Drone.svg"
                iconDetails.color: (model.asset_type === "Antenna"
                                    || model.asset_type === "Drone") ? "Transparent" : "#9287ED"
                iconDetails.opacity: (model.asset_type === "Antenna"
                                      || model.asset_type === "Drone") ? 1.0 : 0.9
                is_selected: model.is_selected

                onCenterOnPoint: {
                    if (!(model.asset_type === "Antenna"
                          || model.asset_type === "Drone")) {
                        if (compMapViewerRoot.selectedAssetDataModel === model) {
                            compMapViewerRoot.selectedAssetDataModel = undefined
                        } else {
                            compMapViewerRoot.selectedAssetDataModel = model
                        }
                    }

                    compMapViewerRoot.centerOnPoint(coordinate)
                }
                onFitViewportToVisibleMapItems: map.fitViewportToVisibleMapItems()
            }
        }
    }

    Popup {
        id: popupSelectedAsset

        closePolicy: Popup.CloseOnEscape | Popup.CloseOnPressOutsideParent
        focus: true
        modal: true

        height: map.height
        width: map.width
        background: Rectangle {
            color: "#80000000"

            MouseArea {
                anchors {
                    fill: parent
                }

                onClicked: compMapViewerRoot.selectedAssetDataModel = undefined
            }
        }
        onClosed: {
            compMapViewerRoot.selectedAssetDataModel = undefined
        }

        CompAssetDashboardGridItem {
            id: selectAssetItem

            property var modelData: visible ? selectedAssetDataModel : undefined

            height: 375
            width: 387

            onEnabledChanged: {
                if (enabled) {
                    focus = true
                }
            }

            anchors {
                centerIn: parent
                horizontalCenterOffset: -width
            }

            //onFocusChanged: {
            //    console.log("My focus is now: "  + focus)
            //}
            assetName: modelData ? modelData.asset_name : ''
            beaconID: modelData ? modelData.beacon_id : ''
            assetState: modelData ? modelData.Asset_Status : ''
            beaconState: modelData ? modelData.status : ''
            assetType: modelData ? modelData.asset_type : ''
        }
    }
}
