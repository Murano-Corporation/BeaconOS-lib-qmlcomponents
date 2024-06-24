import QtQuick 2.15
import QtQuick3D 1.15
import QtQuick.Controls 2.15
import QtPositioning 5.12

//import "file:///home/murano/.nerf_models/Cheburashka.qml" as TestMesh

Item {
    id: comp_3DOverlay_Battlespace

    height: 1000
    width: 1000

    property var mapCoords
    property point viewPoint

    readonly property real constEarthRadius: 12756
    readonly property real constRadians: (Math.PI / 180)

    onMapCoordsChanged: {
        //console.log("3D Overlay MapCoords In Lat: " + mapCoords.latitude)
        //console.log("3D Overlay MapCoords In Lon: " + mapCoords.longitude)

        var retPoint = locationToPoint({lat: mapCoords.latitude, lon: mapCoords.longitude, elv: 10});
        comp_3DOverlay_Battlespace.viewPoint = Qt.point(retPoint.x, retPoint.y)

        //var lat_rad = mapCoords.latitude * constRadians
        //var lon_rad = mapCoords.longitude * constRadians
        //var lat_cos = Math.cos(lat_rad)
        //var earthRad_x_lat_cos = constEarthRadius * lat_cos
        //var x = earthRad_x_lat_cos * Math.cos(lon_rad)
        //var y = earthRad_x_lat_cos * Math.sin(lon_rad)

        //comp_3DOverlay_Battlespace.viewPoint = Qt.point(x, y);

        //var retPoint = attemptLLHtoECEF(mapCoords.latitude,mapCoords.longitude,1)

        //comp_3DOverlay_Battlespace.viewPoint = Qt.point(retPoint.x, retPoint.y)

        //comp_3DOverlay_Battlespace.viewPoint = Qt.point(mapCoords.latitude, mapCoords.longitude)
    }

    onViewPointChanged: {
        console.log("3D Overlay view point now: " + viewPoint)

        //camera_Perspective_1.z = comp_3DOverlay_Battlespace.viewPoint.x
        //camera_Perspective_1.x = comp_3DOverlay_Battlespace.viewPoint.y
    }

    function locationToPoint(c)
    {
        // Convert (lat, lon, elv) to (x, y, z).
        var lat = c.lat * Math.PI / 180.0;
        var lon = c.lon * Math.PI / 180.0;
        var radius = earthRadiusInMeters(lat);
        var clat   = geocentricLatitude(lat);

        var cosLon = Math.cos(lon);
        var sinLon = Math.sin(lon);
        var cosLat = Math.cos(clat);
        var sinLat = Math.sin(clat);
        var x = radius * cosLon * cosLat;
        var y = radius * sinLon * cosLat;
        var z = radius * sinLat;

        // We used geocentric latitude to calculate (x,y,z) on the Earth's ellipsoid.
        // Now we use geodetic latitude to calculate normal vector from the surface, to correct for elevation.
        var cosGlat = Math.cos(lat);
        var sinGlat = Math.sin(lat);

        var nx = cosGlat * cosLon;
        var ny = cosGlat * sinLon;
        var nz = sinGlat;

        x += c.elv * nx;
        y += c.elv * ny;
        z += c.elv * nz;

        return {x:x, y:y, z:z, radius:radius, nx:nx, ny:ny, nz:nz};
    }

    function geocentricLatitude(lat)
    {
        var e2 = 0.00669437999014;
        var clat = Math.atan((1.0 - e2) * Math.tan(lat));
        return clat;
    }

    function earthRadiusInMeters(latitudeRadians)
    {
        // latitudeRadians is geodetic, i.e. that reported by GPS.
        // http://en.wikipedia.org/wiki/Earth_radius
        var a = 6378137.0;  // equatorial radius in meters
        var b = 6356752.3;  // polar radius in meters
        var cos = Math.cos(latitudeRadians);
        var sin = Math.sin(latitudeRadians);
        var t1 = a * a * cos;
        var t2 = b * b * sin;
        var t3 = a * cos;
        var t4 = b * sin;
        return Math.sqrt((t1*t1 + t2*t2) / (t3*t3 + t4*t4));
    }

    function attemptLLHtoECEF(lat, lon, alt){

    var rad = (6378137.0)        // Radius of the Earth (in meters)
    var f = (1.0/298.257223563)  // Flattening factor WGS84 Model
    var cosLat = Math.cos(lat)
    var sinLat = Math.sin(lat)
    var FF     = (1.0-f)**2
    var C      = 1/Math.sqrt((cosLat**2 )+ (FF * sinLat**2))
    var S      = C * FF

    var ret_x = (rad * C + alt)*cosLat * Math.cos(lon)
    var ret_y = (rad * C + alt)*cosLat * Math.sin(lon)
    var ret_z = (rad * S + alt)*sinLat

    return ({x:ret_x, y:ret_y, z:ret_z})
    }


    Node {
        id: scene_Main

        /// LIGHTING
        DirectionalLight {
            eulerRotation{
                x: -45

            }
        }

        DirectionalLight {
            eulerRotation{
                x: 45

            }
        }

        DirectionalLight {
            eulerRotation{
                y: 45

            }
        }

        DirectionalLight {
            eulerRotation{
                y: -45

            }
        }


        // MODELS
        Model {
            id: modelWall1
            position: Qt.vector3d(0,0,500);
            source: "#Cube"
            scale: Qt.vector3d(1,1,1)
            materials: [DefaultMaterial {
                    diffuseColor: "red"
                }]
        }

        Model {
            id: modelWall2
            position: Qt.vector3d(0,0,-500);
            source: "#Cube"
            scale: Qt.vector3d(1,1,1)
            materials: [DefaultMaterial {
                    diffuseColor: "blue"
                }]
        }

        Model {
            id: modelWall3
            position: Qt.vector3d(-500,0,0);
            source: "#Cube"
            scale: Qt.vector3d(1,1,1)
            materials: [DefaultMaterial {
                    diffuseColor: "green"
                }]
        }

        Model {
            id: modelWall4
            position: Qt.vector3d(500,0,0);
            source: "#Cube"
            scale: Qt.vector3d(1,1,1)
            materials: [DefaultMaterial {
                    diffuseColor: "yellow"
                }]
        }

        Model {
            id: modelWall5
            position: Qt.vector3d(0,500,0);
            source: "#Cube"
            scale: Qt.vector3d(1,1,1)
            materials: [DefaultMaterial {
                    diffuseColor: "black"
                }]
        }

        Model {
            id: modelWall6
            position: Qt.vector3d(0,-500,0);
            source: "#Cube"
            scale: Qt.vector3d(1,1,1)
            materials: [DefaultMaterial {
                    diffuseColor: "purple"
                }]
        }

        /// CAMERA
        PerspectiveCamera{
            id: camera_Perspective_1
            x: 0
            y: 600
            z: -100

            //x: 0
            //y: 0
            //z: 0


            eulerRotation{
                // x: 90 /// Rotate Up
                x: -90 /// Rotate Down
                //y: 90
            }

        }
    }



    /// VIEW
    View3D {
        id: viewMain
        importScene: scene_Main
        anchors.fill: parent

        camera: camera_Perspective_1
    }

}
