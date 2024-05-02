import QtQuick 2.12
import QtQml 2.12
import QtQuick.Controls 2.12

Item{
    id: compHealthDashboardContentContextNavOmega

    property bool isMTConnectData: false
    property string systemSelected: "null"
    property string context1Selected: "null"
    property string context2Selected: "null"
    property bool isMaxWidth: true
    property bool isMaxHeight: false
    property string mtcSortFilterString
    property alias btnHeight: viewSystemType.btnHeight
    property alias btnSpacing: viewSystemType.btnSpacing

    property var modelData_EnvImuJ1939J1708_Context1: TableModelHealthDashboard.listOfContext1Options
    property var modelData_MTC_Context1: TableModelMTConnect_Context1

    property var modelData_Context1: (isMTConnectData ? modelData_MTC_Context1 : modelData_EnvImuJ1939J1708_Context1)

    function getContext1Name(iIndex, model)
    {
        if( isMTConnectData )
        {
            console.log("model.display in getContext1Name: " + model.display)
            return model.display
        } else {
            return TableModelHealthDashboard.getContext1Name(iIndex)
        }
    }

    Component.onCompleted: {

        if( !isMTConnectData )
        {
            MqttTopicCmdBOS.slot_Request_Context2Map(AssetInfo.beaconID);
        }


        systemSelected = "null"
    }

    onSystemSelectedChanged: {
        context1Selected = "null"
    }
    onContext1SelectedChanged: {
        context2Selected = "null"
    }

    Item {
        id: viewSystemType
        visible: parent.systemSelected === "null"

        property real btnSpacing: 41
        property real btnWidth: ((compHealthDashboardContentContextNavOmega.width - btnSpacing) * 0.33)
        property real btnHeight: 350

        anchors{
            centerIn: parent
        }

        height: childrenRect.height
        width: childrenRect.width

        CompHealthContextNavBtnOmega {
            id: navBtnBeacon

            anchors{
                left: parent.left
                top: parent.top
                //topMargin: 10
            }

            width: 892
            height: viewSystemType.btnHeight

            iconUrl: "file:///usr/share/BeaconOS-lib-images/images/Beacon.svg"
            text: qsTr("Beacon Metrics")
            fontPixelSize: 50

            onClicked: txt => {
                           compHealthDashboardContentContextNavOmega.systemSelected = txt
                       }
        }

        CompHealthContextNavBtnOmega {
            id: navBtnAsset

            anchors{
                left: navBtnBeacon.left
                top: navBtnBeacon.bottom
                topMargin: viewSystemType.btnSpacing
            }

            width: navBtnBeacon.width
            height: navBtnBeacon.height

            iconUrl: "file:///usr/share/BeaconOS-lib-images/images/AssetFill.svg"
            text: qsTr("Asset Metrics")
            fontPixelSize: 50

            onClicked: txt => {
                           compHealthDashboardContentContextNavOmega.systemSelected = txt
                       }
        }

        CompHealthContextNavBtnOmega {
            id: navBtnVision

            anchors{
                left: navBtnBeacon.left
                top: navBtnAsset.bottom
                topMargin: viewSystemType.btnSpacing
            }

            width: navBtnBeacon.width
            height: navBtnBeacon.height

            iconUrl: "file:///usr/share/BeaconOS-lib-images/images/CameraFill.svg"
            text: qsTr("Camera Gallery")
            fontPixelSize: 50

            onClicked: txt => {
                           compHealthDashboardContentContextNavOmega.systemSelected = txt
                       }
        }
    }

    Item {
        id: viewContext1_Beacon
        visible: (parent.systemSelected === "Beacon Metrics" && parent.context1Selected === "null")

        property real btnSpacing: 41
        property real btnWidth: 892
        property real btnHeight: 304

        anchors{
            centerIn: parent
        }

        height: childrenRect.height
        width: childrenRect.width

        CompHealthContextNavBtnOmega{

            id:navBtnBeaconImu
            width: viewContext1_Beacon.btnWidth
            height: viewContext1_Beacon.btnHeight
            iconUrl: "file:///usr/share/BeaconOS-lib-images/images/IMU.svg"
            text: "IMU"
            myHierarchyPath: compHealthDashboardContentContextNavOmega.systemSelected + "." + text
            anchors{
                left: parent.left
                topMargin: 10

            }
            fontPixelSize: 50
            onClicked: txt => {
                           compHealthDashboardContentContextNavOmega.context1Selected = txt
                       }
        }

        CompHealthContextNavBtnOmega{

            id:navBtnBeaconEnv
            width: viewContext1_Beacon.btnWidth
            height: viewContext1_Beacon.btnHeight
            iconUrl: "file:///usr/share/BeaconOS-lib-images/images/Environmental.svg"
            text: "ENV"
            myHierarchyPath: compHealthDashboardContentContextNavOmega.systemSelected + "." + text
            anchors{
                left: parent.left
                top: navBtnBeaconImu.bottom
                topMargin: 52
            }
            fontPixelSize: 50
            onClicked: txt => {
                           compHealthDashboardContentContextNavOmega.context1Selected = txt
                       }
        }

    }


    Item{
        id: viewContext1_Asset
        visible: (parent.systemSelected === "Asset Metrics" && parent.context1Selected === "null")

        property real btnSpacing: 41
        property real btnHeight: 304
        property real btnWidth: 892
        property int fontPixelSize: 50

        anchors{
            fill: parent
        }

        GridView {
            id: rowDynamicContexts
            clip: true
            boundsBehavior: Flickable.StopAtBounds

            anchors{
                fill: parent
                topMargin: 20
                leftMargin: 10
            }

           model: compHealthDashboardContentContextNavOmega.visible ? compHealthDashboardContentContextNavOmega.modelData_Context1 : undefined

            cellHeight: viewContext1_Asset.btnHeight + viewContext1_Asset.btnSpacing
            cellWidth: viewContext1_Asset.btnWidth + viewContext1_Asset.btnSpacing
            delegate: CompHealthContextNavBtnOmega{
                id: navBtnDelegate
                property var myModel: model
                width: viewContext1_Asset.btnWidth
                height: viewContext1_Asset.btnHeight
                iconUrl:  (text === "?" ) ? "" : ((isMTConnectData ? "" : "file:/usr/share/BeaconOS-lib-images/images/"+ text +".svg"))

                text: compHealthDashboardContentContextNavOmega.getContext1Name(index, model)
                myHierarchyPath: compHealthDashboardContentContextNavOmega.systemSelected + "." + text
                fontPixelSize: viewContext1_Asset.fontPixelSize

                onClicked: function(txt){
                    if(compHealthDashboardContentContextNavOmega.isMTConnectData)
                    {
                        compHealthDashboardContentContextNavOmega.mtcSortFilterString = navBtnDelegate.myModel.name
                    }

                    compHealthDashboardContentContextNavOmega.context1Selected = txt



                }
            }

        }

    }


    Item {
        id: viewContext2
        visible: (parent.context1Selected !== "null" && parent.context2Selected === "null" && parent.systemSelected !== "null")

        anchors{
            fill: parent
            topMargin: 20
            leftMargin: 10
        }

        GridView {
            id: gridContext2

            clip: true

            property real cellSpacing: 26
            property real btnWidth: 892
            property real btnHeight: 128

            model: compHealthDashboardContentContextNavOmega.visible ? TableModelHealthDashboard.listOfContext2Options : undefined

            delegate:
                CompHealthContextNavBtnOmega{

                text: TableModelHealthDashboard.getContext2Name(index, compHealthDashboardContentContextNavOmega.context1Selected)
                myHierarchyPath: compHealthDashboardContentContextNavOmega.systemSelected + "." + compHealthDashboardContentContextNavOmega.context1Selected + "." + text
                height: gridContext2.btnHeight
                width: gridContext2.btnWidth
                rightBtnArrow.visible: true

                fontPixelSize: 40

                onClicked: txt => {
                               compHealthDashboardContentContextNavOmega.context2Selected = txt
                           }
            }


            cellHeight: btnHeight + cellSpacing
            cellWidth: btnWidth + cellSpacing


            anchors{
                fill: parent
            }

            ScrollBar.vertical: ScrollBar{
                policy:  ScrollBar.AsNeeded
                width: 8
                //topInset: 51
                topPadding: 51
            }
        }

    }


}

/*##^##
Designer {
    D{i:0;autoSize:true;formeditorColor:"#000000";formeditorZoom:0.33;height:1920;width:1080}
}
##^##*/
