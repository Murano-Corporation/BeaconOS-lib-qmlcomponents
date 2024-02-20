import QtQuick 2.0
import QtLocation 5.12
import QtPositioning 5.2
import QtQuick.Controls 2.12

Item {
    id: compMapViewerRoot
    property point centerPoint: Qt.point(0,0)
    property var listAssets: TableModelAssetDashboardGridView
    property var selectedAssetDataModel: undefined
    property bool showAssets: true
    property bool captureMouseCoords: false
    property int activeMapTypeIndex: mapPlugin.name === 'mapboxgl' ? 4 : 0
    property int maxMapTypeIndex: map.supportedMapTypes.length
    property real zoomCurrent

    ListView{
        id: listMapTypes
        anchors{
            top: parent.top
            left: parent.left
            right: parent.right
        }

        height: 64

        orientation: ListView.Horizontal

        model: map.supportedMapTypes

        delegate: CompBtnBreadcrumb{
            text: getSimpleMapNameString(model.name)

            onClicked: compMapViewerRoot.activeMapTypeIndex = index
        }
    }

    onActiveMapTypeIndexChanged: {
        //console.log("Active map type index now: " + activeMapTypeIndex)
        //console.log("Supported map types count: " + map.supportedMapTypes.length)
        if(map.supportedMapTypes.length === 0)
                {
                    console.error("NO SUPPORTED MAP TYPES");
                    return;
                }
        else if(activeMapTypeIndex <= -1)
        {
            activeMapTypeIndex = 0
            return
        } else if(activeMapTypeIndex >= maxMapTypeIndex)
        {
            activeMapTypeIndex = maxMapTypeIndex-1
            return
        }

        map.activeMapType = map.supportedMapTypes[activeMapTypeIndex]
    }

    function getSimpleMapNameString(mapTypeName)
    {

        console.log("Map name: " + mapTypeName)
        switch(mapTypeName)
        {
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

    function setActiveMapTypeIndex(index)
    {
        activeMapTypeIndex = index
    }

    function clear(){

    }

    function setZoomLevel(zoomLevel)
    {
        map.zoomLevel = zoomLevel
    }

    function addPoint(lat, lon, type)
    {
        var mapPoint = Qt.createQmlObject('import QtLocation 5.3; MapCircle {}', compMapViewerRoot)
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

    Component{
        id: compClickableMapItem

        MapQuickItem{

            anchorPoint: Qt.point(sourceItem.width * 0.5, sourceItem.height * 0.5)

            onCoordinateChanged: {
                sourceItem.coords = coordinate
                console.log("Coordinates now " + coordinate)
            }

            sourceItem: ImgAssetVehicle{
                id: imgSub
                height: 100
                width: 100

                property var coords

                MouseArea{
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

    function centerOnPointXY(x, y)
    {
        centerOnPoint(QtPositioning.coordinate(x,y))
    }

    function centerOnPoint(coords)
    {
        map.center = coords
    }

    onCenterPointChanged: {
        map.center = QtPositioning.coordinate(centerPoint.x, centerPoint.y)
        map.fitViewportToVisibleMapItems()


        //map.addMapItem()
    }

   //Component.onCompleted: {
   //    //console.log("Available Map Types:")
   //    //console.log("Supported Plugin Service Providers " + mapPlugin.availableServiceProviders)
   //
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
   //
   //
   //
   //}
   //

    Plugin {
        id: mapPlugin

        preferred: ["mapboxgl", "osm"]
        //required: Plugin.OnlineMappingFeature | Plugin.OfflineMappingFeature | Plugin.LocalizedMappingFeature |
        //          Plugin.NoPlacesFeatures | Plugin.NoRoutingFeatures | Plugin.AnyGeocodingFeatures

        PluginParameter{
            name: "esri.token"
            value: "AAPK89749ac0dd3e4a108bedf722e117c92ah5KdAZ_1yGyeBOSzoW7gPur9Fy0jHoq2aXa9SlwgTxhhfP0qyw3rvgD67YGQwakb"
        }

        PluginParameter{
            name: "osm.access_token"
            value: "242e69891b264077a78f5f9f87e095c0"
        }

        PluginParameter{
            name: "mapbox.access_token"
            value: "sk.eyJ1IjoiYWp0LW11cmFubyIsImEiOiJjbHFjbWQzOXkwM3BvMnhxdzh5M3ZmbDZiIn0.dGKKlVL8RAT4Od4-TtIEbg"
        }
        PluginParameter{
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

    //MapType{
    //    id: mapTypeInfo
    //
    //    night: true
    //    mobile: true
    //}

    Map {
        id: map
        anchors{
            top: listMapTypes.bottom
            topMargin: 20
            left: parent.left
            right: parent.right
            bottom: parent.bottom
        }

        onZoomLevelChanged: compMapViewerRoot.zoomCurrent = zoomLevel
        copyrightsVisible: false
        activeMapType: supportedMapTypes[compMapViewerRoot.activeMapTypeIndex]
        //activeMapType: mapPlugin.name === "osm" ? supportedMapTypes[3] : mapPlugin.name === "mapboxgl" ? supportedMapTypes[9] : supportedMapTypes[0]
        //onActiveMapTypeChanged: {
        //    console.log("ActiveMapType is now: " + activeMapType.name)
        //}



        plugin: mapPlugin
        center: QtPositioning.coordinate(center.x, centerPoint.y)

        //Component.onCompleted:{
        //    //console.log("Supported map types:")
        //    for(var i = 0; i < supportedMapTypes.length; i++)
        //    {
        //        var mapType = supportedMapTypes[i]
        //
        //        console.log("- " + mapType)
        //        console.log("--- Name: " + mapType.name)
        //        console.log("--- Description: " + mapType.description)
        //        console.log("--- Mobile?: " + mapType.mobile)
        //        console.log("--- Night?: " + mapType.night)
        //        console.log("--- Style: " + mapType.style)
        //    }
        //}

        MapItemView{
            model: compMapViewerRoot.listAssets
            delegate: CompMapAssetItem {
                id: compMapAssetItem

                lat: model.Latitude
                lon: model.Longitude
                assetType: model.asset_type

                onCenterOnPoint: {

                    if(compMapViewerRoot.selectedAssetDataModel === model)
                    {
                        compMapViewerRoot.selectedAssetDataModel = undefined
                    } else {
                        compMapViewerRoot.selectedAssetDataModel = model
                    }

                    compMapViewerRoot.centerOnPoint(coordinate)
                }
                onFitViewportToVisibleMapItems: map.fitViewportToVisibleMapItems()
            }

        }



    }

    onSelectedAssetDataModelChanged: {
        if(selectedAssetDataModel === undefined)
        {
            popupSelectedAsset.close()
        } else {
            popupSelectedAsset.open()
        }
    }

    Popup{
        id: popupSelectedAsset


        closePolicy: Popup.CloseOnEscape | Popup.CloseOnPressOutsideParent
        focus: true
        modal: true

        height: map.height
        width: map.width
        background: Rectangle{
            color: "#80000000"

            MouseArea{
                anchors{
                    fill: parent
                }

                onClicked: compMapViewerRoot.selectedAssetDataModel = undefined
            }
        }
        onClosed: {
            compMapViewerRoot.selectedAssetDataModel = undefined
        }

        CompAssetDashboardGridItem{
            id: selectAssetItem

            height: 375
            width: 387


            onEnabledChanged: {
                if(enabled)
                {
                    focus = true
                }
            }



            anchors{
                centerIn: parent
                horizontalCenterOffset: -width
            }

            //onFocusChanged: {
            //    console.log("My focus is now: "  + focus)
            //}

            property var modelData: visible ? selectedAssetDataModel : undefined

            assetName: modelData ? modelData.asset_name : ''
            beaconID: modelData ? modelData.Beacon_ID : ''
            assetState: modelData ? modelData.Asset_Status : ''
            beaconState: modelData ? modelData.status : ''
            assetType: modelData ? modelData.asset_type : ''
        }

    }




    MouseArea
    {
        id:mouseArea_CoordGrabber

        enabled: compMapViewerRoot.captureMouseCoords
        visible: enabled

        anchors.fill: map
        hoverEnabled: true
        property var coordinate: map.toCoordinate(Qt.point(mouseX, mouseY))
        CompLabel
        {
            x: parent.mouseX - width
            y: parent.mouseY - height - 5
            text: "lat: %1; lon:%2".arg(parent.coordinate.latitude).arg(parent.coordinate.longitude)

            font{
                pixelSize: 12
            }
        }
    }

}
