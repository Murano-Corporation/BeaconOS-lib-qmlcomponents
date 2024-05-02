import QtQuick 2.12
import QtQuick.Controls 2.12
import Qt.labs.qmlmodels 1.0
import QtQml 2.11

Item {

//    Rectangle{
//        anchors.fill: parent

//        color: "#1B03A3"

//        MouseArea{
//            anchors.fill: parent

//            onClicked: {
//                console.log("screenHealthDashboardRoot.listOfHotParams = " + screenHealthDashboardRoot.listOfHotParams.toString())
//            }
//        }
//    }

    Rectangle {
        id: groupContentBg

        anchors{
            fill: parent
            topMargin: 300
        }

        color: "#14818087"
        rotation: 0
    }

    CompLabel{

        id: lblAssetName

        text: screenHealthDashboardRoot.assetName
        font {
            pixelSize: 75
        }
        color: "White"
        anchors {
            right: parent.right
            rightMargin: 20
            bottom: groupContentBg.top
            bottomMargin: 20
        }


    }
    Rectangle {
        id: rectSelectedTabBg

        anchors{
            verticalCenter: groupContentBg.top
            left: parent.left
            right: parent.right
        }

        height: 6
        radius: 3
        color: "#4D4A5F"
    }

    GridView{

        anchors{
            left: rectSelectedTabBg.left
            //horizontalCenter: rectSelectedTabBg.horizontalCenter
            leftMargin: 50

            //horizontalCenter: parent.horizontalCenter

            right: rectSelectedTabBg.right
            top: rectSelectedTabBg.bottom
            topMargin: 50
            bottom: parent.bottom
            bottomMargin: 20
        }

        //boundsBehavior: Flickable.StopAtBounds

        cellWidth: width
        cellHeight: height/6

        model: screenHealthDashboardRoot.listOfHotParams

      //model: ['GPS_LOCATION','OIL_PRESSURE','BATTERY_VOLTAGE','OPERATION_STATUS','ESTIMATED_FUEL_LEVEL','COOLANT_TEMPERATURE']

        delegate: CompAssetHotParam {

//            anchors.topMargin: 100
//            anchors.leftMargin: 50
            id: hotParamLocation

            property var myModel: modelData
            property bool isGpsLocation: paramName === 'GPS LOCATION'

            height: 175
            width: 875

            hotParamIconGroup.height: 140
            hotParamIconGroup.width: 140
            hotParamIcon.height: 90
            hotParamIcon.width: 90
            hotParamName.font.pixelSize: 35
            hotParamValue1.font.pixelSize: 35
            hotParamValue1.anchors.leftMargin: 16
            hotParamValue2.font.pixelSize: 35

            paramName: Settings.getDataMapKeyForHotParam(modelData)
            displayName: Settings.getDisplayStringForHotParam(modelData)
            value1: Settings.getDefaultValueForHotParam(modelData)
            value2: Settings.getDefaultUnitForHotParam(modelData)
            color2: "#9287ED"
            color1: "#709060"
            iconPath: Settings.getIconPathForHotParam(modelData)

            Component.onCompleted: {
                if(!TableModelHealthDashboard)
                    return

                TableModelHealthDashboard.signal_DataChanged.connect(onDataChanged)
            }

            Component.onDestruction: {

                if(!TableModelHealthDashboard)
                    return

                TableModelHealthDashboard.signal_DataChanged.disconnect(onDataChanged)
            }

            function onDataChanged(indexLeft, indexRight, role)
            {
                if(!TableModelHealthDashboard)
                    return

                if(isGpsLocation)
                {
                    value1 = TableModelHealthDashboard.getGpsLocationString();
                    return;
                }

                var dataChangedName = TableModelHealthDashboard.data(indexLeft, 257)
                if(dataChangedName === paramName)
                {
                    //console.log('My data changed!!!')
                    value1 = TableModelHealthDashboard.data(indexLeft, 258)
                    value2 = TableModelHealthDashboard.data(indexLeft, 265)
                }

                //console.log('DataChanged for ' + dataChangedName)
                //console.log('My Paramname is ' + paramName)
            }

            MouseArea{
                visible: isGpsLocation

                anchors.fill: parent

                onClicked: {
                    var ptCenter = Qt.point(0,0)
                    var lat = AssetInfo.gpsLatValue
                    var lon = AssetInfo.gpsLonValue
                    ptCenter.x = lat
                    ptCenter.y = lon

                    loaderMapView.centerOnPoint = ptCenter
                    loaderMapView.active = true
                }
            }
        }

    }

}
/*##^##
Designer {
    D{i:0;autoSize:true;formeditorColor:"#000000";formeditorZoom:0.33;height:1920;width:1080}
}
##^##*/
