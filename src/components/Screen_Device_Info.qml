import QtQuick 2.12
import QtLocation 5.12
import QtPositioning 5.12
import QtQuick.Controls 2.12
import QtGraphicalEffects 1.0

Item {
    id: compMapViewerRoot

    property point centerPoint: Qt.point(0,0)
    property var listAssets: TableModelAssetDashboardGridView
    property var selectedAssetDataModel: undefined
    property bool showAssets: true
    property bool captureMouseCoords: false
    property int activeMapTypeIndex: mapPlugin.name === 'mapboxgl' ? 4 : 0
    property int maxMapTypeIndex: map.supportedMapTypes.length
    //property alias targetListDelegate: mapView_Targets.delegate
    property alias tilt: map.tilt
    property alias center: map.center
    property alias zoomLevel: map.zoomLevel
    property alias bearing: map.bearing

    property real zoomCurrent

    function centerOnPoint(coords)
    {
        map.center = coords
    }

    function centerOnPointXY(x, y)
    {
        centerOnPoint(QtPositioning.coordinate(x,y))
    }

    function clear(){

    }

    function setZoomLevel(zoomLevel)
    {
        map.zoomLevel = zoomLevel
    }

    Component.onCompleted: {

        //console.log("Setting zoom level")
        setZoomLevel(1.0)

        //console.log("Setting active map type")
        //setActiveMapTypeIndex(4)

        //console.log("Centering on point")
        centerOnPointXY(40, -100)
    }

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

    Map {
        id: map
        anchors{
            top: parent.top
            //topMargin: 20
            left: parent.left
            //right: parent.right
            bottom: parent.bottom
            bottomMargin: 20
        }

        width: 1250

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

        MouseArea
        {
            id:mouseArea_CoordGrabber

            property var coordinate: map.toCoordinate(Qt.point(mouseX, mouseY))

            //enabled: compMapViewerRoot.captureMouseCoords
            visible: enabled

            anchors.fill: parent
            //hoverEnabled: true
            propagateComposedEvents: true


        }
    }

    Comp_Device_Info{

        id: antennaInfo

        anchors{
            top: map.top
            //topMargin: 20
            left: map.right
            leftMargin: 20
            right: parent.right
            //bottom: map.bottom
            bottomMargin: 10
        }
        height: 478

        labelTitle.text: "Antennas"
        isDeviceAntenna: true

    }
    Comp_Device_Info{

        anchors{
            top: antennaInfo.bottom
            topMargin: 20
            left: map.right
            leftMargin: 20
            right: parent.right
            //bottom: map.bottom
            //bottomMargin: 20
        }

        height: antennaInfo.height
        labelTitle.text: "Drones"
        isDeviceAntenna: false
    }
}
